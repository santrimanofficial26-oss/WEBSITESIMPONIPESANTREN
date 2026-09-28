(function () {
    'use strict';

    const CHANNEL = 'SIMPONI_CAMERA_BRIDGE_V1';
    const GAS_ORIGIN = /^https:\/\/(?:script\.google\.com|(?:[a-z0-9-]+-)?script\.googleusercontent\.com)$/i;
    const overlay = document.getElementById('simponi-camera-overlay');
    const status = document.getElementById('simponiCameraStatus');
    const frame = document.getElementById('simponi-frame');
    let requester = null;
    let scanner = null;
    let starting = false;
    let serial = 0;
    let pendingScan = null;
    let lastCode = '';
    let lastScanAt = 0;

    function send(type, details) {
        if (!requester) return;
        requester.source.postMessage({ channel: CHANNEL, type, ...details }, requester.origin);
    }

    function setStatus(message) {
        status.textContent = message;
    }

    async function stopCamera() {
        serial++;
        starting = false;
        if (pendingScan) clearTimeout(pendingScan.timer);
        pendingScan = null;
        const current = scanner;
        scanner = null;
        if (current) {
            try { if (current.isScanning) await current.stop(); } catch (error) { console.warn('Kamera gagal dihentikan:', error); }
            try { current.clear(); } catch (error) { console.warn('Scanner gagal dibersihkan:', error); }
        }
        overlay.classList.remove('is-open');
        send('stopped');
        requester = null;
    }

    function onQrDecoded(rawValue) {
        const code = String(rawValue || '').trim();
        if (!code || code.length > 256 || pendingScan) return;
        const now = Date.now();
        if (code === lastCode && now - lastScanAt < 3000) return;
        lastCode = code;
        lastScanAt = now;
        const scanId = String(now) + '-' + Math.random().toString(36).slice(2);
        const timer = setTimeout(() => {
            if (!pendingScan || pendingScan.id !== scanId) return;
            pendingScan = null;
            setStatus('Aplikasi belum merespons. Coba arahkan QR kembali.');
        }, 15000);
        pendingScan = { id: scanId, timer };
        setStatus('QR terbaca. Menyimpan absensi...');
        send('scan', { scanId, code });
    }

    async function startCamera() {
        if (!requester) return;
        if (starting) { send('starting'); return; }
        if (scanner && scanner.isScanning) { send('active'); return; }
        const currentSerial = ++serial;
        overlay.classList.add('is-open');
        setStatus('Meminta izin kamera browser...');
        send('starting');
        starting = true;
        try {
            if (!window.isSecureContext || !navigator.mediaDevices?.getUserMedia) {
                throw new Error('Kamera memerlukan HTTPS dan browser yang mendukung akses kamera.');
            }
            if (typeof Html5Qrcode === 'undefined') {
                throw new Error('Pembaca QR belum termuat. Periksa koneksi internet, lalu muat ulang halaman.');
            }
            const instance = new Html5Qrcode('simponiCameraReader');
            scanner = instance;
            await instance.start(
                { facingMode: 'environment' },
                { fps: 12, qrbox: { width: 250, height: 250 } },
                onQrDecoded,
                function () { /* QR belum terlihat dalam frame ini. */ }
            );
            if (currentSerial !== serial || !requester) {
                await instance.stop();
                instance.clear();
                return;
            }
            starting = false;
            setStatus('Kamera aktif. Arahkan QR kartu santri ke kamera.');
            send('active');
        } catch (error) {
            starting = false;
            if (scanner) {
                try { scanner.clear(); } catch (_) { /* Scanner belum selesai dibuat. */ }
                scanner = null;
            }
            const message = error && error.message ? error.message : String(error);
            setStatus('Kamera gagal dibuka: ' + message);
            send('error', { message });
            console.error('Kamera Vercel gagal dibuka:', error);
        }
    }

    window.addEventListener('message', function (event) {
        if (!GAS_ORIGIN.test(event.origin) || !event.source || event.source === window) return;
        const data = event.data;
        if (!data || data.channel !== CHANNEL) return;
        if (data.type === 'start') {
            if (requester && requester.source !== event.source) return;
            requester = { source: event.source, origin: event.origin };
            void startCamera();
        } else if (data.type === 'stop') {
            if (requester?.source === event.source) void stopCamera();
        } else if (data.type === 'scan-result' && requester?.source === event.source && pendingScan?.id === data.scanId) {
            clearTimeout(pendingScan.timer);
            pendingScan = null;
            setStatus(data.message || (data.success ? 'Absensi berhasil. Siap memindai QR berikutnya.' : 'QR gagal diproses. Coba lagi.'));
        }
    });

    document.getElementById('simponiCameraStop').addEventListener('click', function () { void stopCamera(); });
    frame.addEventListener('load', function () { if (requester) void stopCamera(); });
    window.addEventListener('pagehide', function () { void stopCamera(); });
})();
