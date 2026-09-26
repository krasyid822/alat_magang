#!/usr/bin/env python3
"""Deploy alat_magang ke Firebase Hosting.

Urutan langkah:
  1. Cek tool wajib (dart, flutter, firebase) tersedia di PATH
  2. Cek working tree git bersih
  3. flutter pub get
  4. dart run build_runner build      -- regenerate .g.dart / .freezed.dart
  5. dart analyze                     -- gate, error -> berhenti
  6. dart scripts/increment_build.dart
  7. flutter build web --release
  8. Konfirmasi versi                 -- dilewati bila --yes
  9. firebase deploy --only hosting

Penggunaan:
  python deploy.py           # interaktif, ada konfirmasi
  python deploy.py --yes     # tanpa konfirmasi (CI / script)
"""

import argparse
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

REQUIRED_TOOLS = ("dart", "flutter", "firebase")


def fail(message):
    print(f"\n❌ {message}")
    sys.exit(1)


def run(command, capture=False):
    """Jalankan perintah; hentikan proses bila exit code bukan 0."""
    print(f"\n{'=' * 46}")
    print(f"❯ {' '.join(command)}")
    print('=' * 46)

    result = subprocess.run(
        command,
        check=False,
        text=True,
        capture_output=capture,
    )
    if result.returncode != 0:
        if capture:
            if result.stdout:
                print(result.stdout)
            if result.stderr:
                print(result.stderr, file=sys.stderr)
        fail(f"Perintah gagal (exit {result.returncode}): {' '.join(command)}")
    return result.stdout or ""


def check_tools():
    missing = [tool for tool in REQUIRED_TOOLS if shutil.which(tool) is None]
    if missing:
        fail(
            "Tool tidak ditemukan di PATH: "
            + ", ".join(missing)
            + "\n   Pastikan sudah terinstal dan PATH sudah di-set."
        )
    print(f"✅ Tool tersedia: {', '.join(REQUIRED_TOOLS)}")


def read_firebase_project():
    """Baca project default dari .firebaserc."""
    path = Path(".firebaserc")
    if not path.exists():
        fail("File .firebaserc tidak ditemukan — tidak tahu project Firebase mana.")
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"Gagal membaca .firebaserc: {error}")
    return (data.get("projects") or {}).get("default")


def check_firebase_auth(project):
    """Pastikan kredensial Firebase masih valid SEBELUM build berjalan.

    `firebase login:list` hanya memeriksa apakah akun tersimpan, bukan apakah
    token-nya masih berlaku. Tanpa cek ini, deploy baru gagal di langkah
    terakhir — setelah `flutter build web --release` memakan waktu lama.
    """
    result = subprocess.run(
        ["firebase", "hosting:sites:list", "--project", project],
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode == 0:
        print(f"✅ Kredensial Firebase valid untuk project '{project}'.")
        return

    detail = (result.stderr or result.stdout or "").strip()
    lowered = detail.lower()
    auth_error = "401" in lowered or "invalid authentication" in lowered

    if auth_error:
        fail(
            "Kredensial Firebase tidak valid atau kedaluwarsa.\n"
            "   Jalankan: firebase login\n"
            "   ('firebase login:list' tetap menampilkan akun meski token-nya "
            "sudah kedaluwarsa, jadi jangan dipakai sebagai indikator.)\n"
            f"   Detail: {detail.splitlines()[-1] if detail else '401'}"
        )
    fail(f"Gagal verifying project '{project}'.\n   Detail: {detail}")


def check_git_clean():
    if shutil.which("git") is None:
        print("⚠️  git tidak ditemukan — lewati pemeriksaan working tree.")
        return

    output = subprocess.run(
        ["git", "status", "--porcelain"],
        check=False,
        text=True,
        capture_output=True,
    ).stdout.strip()

    if not output:
        print("✅ Working tree git bersih.")
        return

    print("\n⚠️  Working tree git tidak bersih:")
    for line in output.splitlines()[:20]:
        print(f"     {line}")
    if len(output.splitlines()) > 20:
        print(f"     ... dan {len(output.splitlines()) - 20} baris lagi")
    print()


def read_version():
    """Baca versi yang akan dideploy dari app_version.dart."""
    try:
        with open("lib/app_version.dart", encoding="utf-8") as handle:
            content = handle.read()
    except OSError as error:
        fail(f"Gagal membaca lib/app_version.dart: {error}")

    def grab(pattern, default="?"):
        match = re.search(pattern, content)
        return match.group(1) if match else default

    semver = grab(r"const String kAppVersion = '([^']+)';")
    build = grab(r"const int kBuildNumber = (\d+);")
    return f"{semver}+{build}"


def confirm(version):
    print(f"\n{'─' * 46}")
    print(f"  Versi yang akan di-deploy : v{version}")
    print(f"  Target                    : Firebase Hosting (alat-magang)")
    print(f"{'─' * 46}")

    try:
        answer = input("  Lanjutkan? [y/N] ").strip().lower()
    except EOFError:
        answer = ""
    if answer not in ("y", "yes"):
        print("\n✋ Dibatalkan. Tidak ada yang di-deploy.")
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Deploy alat_magang ke Firebase Hosting.")
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Lewati konfirmasi sebelum deploy (untuk CI).",
    )
    args = parser.parse_args()

    check_tools()

    # Cek kredensial duluan: gagal di sini dalam hitungan detik, bukan
    # setelah build web yang memakan waktu lama.
    check_firebase_auth(read_firebase_project())

    check_git_clean()

    run(["flutter", "pub", "get"])
    run(["dart", "run", "build_runner", "build", "--delete-conflicting-outputs"])
    run(["dart", "analyze"])

    # Baru setelah semua gate lolos, sumber daya dimutasi.
    run(["dart", "scripts/increment_build.dart"])
    run(["flutter", "build", "web", "--release"])

    version = read_version()
    if not args.yes:
        confirm(version)

    run(["firebase", "deploy", "--only", "hosting"])

    print(f"\n🎉 Deploy selesai. Sekarang live di v{version}.")


if __name__ == "__main__":
    main()
