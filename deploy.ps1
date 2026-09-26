# Launcher deploy untuk Windows PowerShell.
#
# Logika deploy ada di deploy.py — file ini hanya memastikan interpreter
# Python yang benar dipakai lalu meneruskan seluruh argumen.
#
# Contoh:
#   .\deploy.ps1          # interaktif, ada konfirmasi
#   .\deploy.ps1 -Yes     # tanpa konfirmasi

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

$python = $null
foreach ($candidate in @('python3', 'python')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $python = $candidate
        break
    }
}

if (-not $python) {
    Write-Error 'Python tidak ditemukan di PATH. Pasang Python 3 lalu ulangi.'
    exit 1
}

& $python deploy.py @args
exit $LASTEXITCODE
