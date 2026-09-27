# ========================================================
#   SIMPONI Pesantren Vercel Iframe - Automated Git Push (PowerShell)
#   Target: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git
# ========================================================

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  SIMPONI Pesantren Vercel Iframe - Automated Git Push" -ForegroundColor Green
Write-Host "  Target: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git" -ForegroundColor Yellow
Write-Host "========================================================`n" -ForegroundColor Cyan

# 1. Cek git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Git CLI tidak ditemukan pada sistem PATH Anda." -ForegroundColor Red
    Write-Host "Silakan download dan install Git: https://git-scm.com/" -ForegroundColor Yellow
    exit 1
}

# 2. Inisialisasi Git jika belum ada
if (-not (Test-Path ".git")) {
    Write-Host "[*] Menginisialisasi Git repository di folder vercel-iframe..." -ForegroundColor Cyan
    git init
    git branch -M main
    git remote add origin "https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git"
} else {
    Write-Host "[*] Repositori Git lokal sudah terdeteksi di folder ini." -ForegroundColor Cyan
    git remote set-url origin "https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git"
}

# 3. Add & Commit
Write-Host "[*] Menambahkan seluruh file wrapper..." -ForegroundColor Cyan
git add -A

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commitMsg = "Deploy SIMPONI Vercel Iframe Wrapper - $timestamp"
Write-Host "[*] Membuat commit: '$commitMsg'..." -ForegroundColor Cyan
try {
    git commit -m "$commitMsg"
} catch {
    Write-Host "[INFO] Tidak ada perubahan baru untuk di-commit." -ForegroundColor Gray
}

# 4. Push ke GitHub
Write-Host "[*] Mengunggah (push) ke branch main GitHub..." -ForegroundColor Cyan
try {
    git push -u origin main
    Write-Host "`n[SUKSES] Berhasil diunggah ke GitHub!" -ForegroundColor Green
    Write-Host "URL Repo: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN" -ForegroundColor Green
} catch {
    Write-Host "[INFO] Mencoba sinkronisasi force push..." -ForegroundColor Yellow
    try {
        git push -u origin main --force
        Write-Host "`n[SUKSES] Berhasil force push ke GitHub!" -ForegroundColor Green
        Write-Host "URL Repo: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN" -ForegroundColor Green
    } catch {
        Write-Host "`n[PERINGATAN] Gagal melakukan push. Pastikan kredensial/token GitHub Anda telah login di sistem ini." -ForegroundColor Red
    }
}
