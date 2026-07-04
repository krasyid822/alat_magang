import subprocess
import sys

def run_command(command):
    print(f"\n==========================================")
    print(f"Executing: {' '.join(command)}")
    print(f"==========================================\n")
    try:
        # Menjalankan perintah dan langsung menampilkan outputnya ke terminal
        result = subprocess.run(command, check=True)
        return result.returncode == 0
    except subprocess.CalledProcessError as e:
        print(f"\n❌ Error: Perintah gagal dengan exit code {e.returncode}")
        return False
    except FileNotFoundError:
        print(f"\n❌ Error: Perintah '{command[0]}' tidak ditemukan. Pastikan program terinstal dan ada dalam PATH.")
        return False

def main():
    steps = [
        ["dart", "scripts/increment_build.dart"],
        ["flutter", "build", "web", "--release"],
        ["firebase", "deploy", "--only", "hosting"]
    ]

    for step in steps:
        success = run_command(step)
        if not success:
            print("\n⚠️ Deploy dihentikan karena terjadi kegagalan pada langkah sebelumnya.")
            sys.exit(1)

    print("\n🎉 Deploy berhasil diselesaikan sepenuhnya!")

if __name__ == "__main__":
    main()
