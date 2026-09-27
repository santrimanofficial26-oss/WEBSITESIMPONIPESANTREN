# SIMPONI Pesantren - Vercel Iframe Wrapper

Repositori ini berisi berkas *fullscreen iframe wrapper* produksi untuk **Sistem Informasi & Manajemen Pesantren (SIMPONI)** Pondok Pesantren Salaf & Modern Hidayatul Mubtadi'in Nganjuk, yang menghubungkan Web App Google Apps Script ke domain kustom Vercel secara aman dan responsif.

---

## 🎯 Informasi Tautan Layanan
- **Google Apps Script Web App**:  
  `https://script.google.com/macros/s/AKfycbyIw1RmAJTrQLd3LaZqIDQe7L4_9NozKMSGfzNJ-VkvdCx9h3WgqTc-y-tMVddcvz-6/exec`
- **Repositori GitHub**:  
  `https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git`

---

## 🚀 Cara Menghubungkan ke Vercel (Auto Deploy)
1. Buka [Vercel Dashboard](https://vercel.com/dashboard).
2. Klik **Add New...** > **Project**.
3. Pilih repositori **`santrimanofficial26-oss/WEBSITESIMPONIPESANTREN`**.
4. Biarkan konfigurasi default (Framework Preset: *Other*, Root Directory: `./`).
5. Klik **Deploy**.
6. Selesai! Web portal Anda kini dapat diakses dengan domain kustom HTTPS Vercel gratis.

---

## 💻 Cara Mengunggah Perubahan (Git Push)
Cukup jalankan berkas **`push_to_github.bat`** (klik ganda di Windows) atau jalankan perintah PowerShell:
```powershell
.\push_to_github.ps1
```
Skrip ini akan secara otomatis menambahkan perubahan, membuat commit dengan stempel waktu, dan melakukan push ke branch `main` GitHub.
