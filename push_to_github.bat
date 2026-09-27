@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
echo ========================================================
echo   SIMPONI Pesantren Vercel Iframe - Automated Git Push
echo   Target: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git
echo ========================================================
echo.

:: 1. Cek instalasi Git
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Git tidak ditemukan pada sistem PATH Anda.
    echo Silakan install Git terlebih dahulu: https://git-scm.com/
    pause
    exit /b 1
)

:: 2. Inisialisasi Git jika belum ada di folder vercel-iframe
if not exist ".git" (
    echo [*] Menginisialisasi repositori Git lokal di folder vercel-iframe...
    git init
    git branch -M main
    git remote add origin https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git
) else (
    echo [*] Repositori Git lokal sudah terdeteksi di folder ini.
    git remote set-url origin https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git
)

:: 3. Tambahkan file dan commit
echo [*] Melakukan git add seluruh file wrapper...
git add -A

set COMMIT_MSG=Deploy SIMPONI Vercel Iframe Wrapper - %date% %time%
echo [*] Melakukan commit dengan pesan: "!COMMIT_MSG!"
git commit -m "!COMMIT_MSG!"

:: 4. Push ke GitHub
echo [*] Mengunggah (push) ke GitHub origin/main...
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo  [SUKSES] Berhasil diunggah ke GitHub!
    echo  URL: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN
    echo ========================================================
) else (
    echo.
    echo [INFO] Mencoba sinkronisasi force push ke branch main...
    git push -u origin main --force
    if %ERRORLEVEL% equ 0 (
        echo.
        echo ========================================================
        echo  [SUKSES] Berhasil force push ke GitHub!
        echo  URL: https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN
        echo ========================================================
    ) else (
        echo.
        echo ========================================================
        echo  [PERINGATAN] Gagal melakukan push ke GitHub.
        echo  Kemungkinan penyebab:
        echo  1. Token/Kredensial GitHub (Personal Access Token / SSH) belum login di komputer ini.
        echo  2. Izin akses write pada repositori belum diberikan ke akun Anda.
        echo ========================================================
    )
)

echo.
echo Selesai.
pause
