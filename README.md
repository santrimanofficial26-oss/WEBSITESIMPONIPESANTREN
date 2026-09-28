# SIMPONI Pesantren - Vercel Iframe Wrapper

Repositori ini berisi berkas *fullscreen iframe wrapper* produksi untuk **Sistem Informasi & Manajemen Pesantren (SIMPONI)** Pondok Pesantren Salaf & Modern Hidayatul Mubtadi'in Nganjuk, yang menghubungkan Web App Google Apps Script ke domain kustom Vercel secara aman dan responsif.

## Kamera QR absensi

Kamera berjalan di halaman Vercel melalui `camera-bridge.js` dan pustaka `html5-qrcode`. Tombol **Aktifkan Kamera** di HTML Apps Script mengirim perintah ke halaman Vercel dengan `postMessage`. Setelah QR terbaca, kode dikirim kembali ke aplikasi, lalu aplikasi menyimpan absensi dengan `google.script.run` melalui action `attendance.scanQr`. Token login tetap berada di aplikasi Apps Script dan tidak dikirim ke wrapper Vercel.

Perubahan kamera memerlukan **dua deployment**: salin `index.html` utama ke proyek Apps Script dan buat deployment versi baru, lalu deploy isi folder `vercel-iframe` (termasuk `camera-bridge.js`) ke Vercel. Buka situs melalui domain Vercel HTTPS, masuk sebagai petugas, lalu uji tombol **Aktifkan Kamera**, scan QR, dan **Matikan Kamera**. Browser akan meminta izin kamera untuk domain Vercel. Jika pustaka QR CDN gagal dimuat, wrapper menampilkan pesan kesalahan; input NIS atau scanner USB tetap tersedia.

Contoh `FETCHINGKAMERA.js` dan `OPENCAMERAFETCHING.md` memakai `doPost`/`fetch` untuk arsitektur frontend mandiri. Wrapper SIMPONI saat ini memakai iframe Apps Script dan backend `apiRequest`, sehingga jembatan di atas mempertahankan jalur penyimpanan absensi yang sudah ada.

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
Skrip ini memeriksa bahwa folder ini adalah repositori Vercel di branch `main` dengan remote yang benar. Setelah `git fetch`, skrip berhenti bila `origin/main` sudah maju atau riwayat berbeda. Jika aman, skrip menambahkan perubahan, membuat commit dengan stempel waktu, dan melakukan push biasa ke `main`. Skrip tidak memakai force push.

Push ini hanya mengirim berkas dalam folder `vercel-iframe`, termasuk `camera-bridge.js`. Perubahan `index.html` utama tetap perlu disalin dan dideploy secara terpisah di Google Apps Script.
