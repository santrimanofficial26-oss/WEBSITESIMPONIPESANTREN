$ErrorActionPreference = 'Stop'
$expectedRemote = 'https://github.com/santrimanofficial26-oss/WEBSITESIMPONIPESANTREN.git'
$repoPath = (Resolve-Path -LiteralPath $PSScriptRoot).Path

function Run-Git {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$GitArgs)
    & git -C $repoPath @GitArgs
    if ($LASTEXITCODE -ne 0) {
        throw "Git gagal (exit $LASTEXITCODE): git $($GitArgs -join ' ')"
    }
}

try {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw 'Git belum terpasang atau belum tersedia di PATH.'
    }

    $actualRoot = (& git -C $repoPath rev-parse --show-toplevel 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $actualRoot -or
        [IO.Path]::GetFullPath($actualRoot.Trim()) -ne [IO.Path]::GetFullPath($repoPath)) {
        throw 'Folder vercel-iframe harus merupakan repositori Git sendiri. Clone repositori Vercel dahulu.'
    }

    $branch = (& git -C $repoPath branch --show-current).Trim()
    if ($LASTEXITCODE -ne 0 -or $branch -ne 'main') {
        throw "Branch aktif harus main. Saat ini: '$branch'."
    }

    $remote = (& git -C $repoPath remote get-url origin 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $remote -or $remote.TrimEnd('/') -ne $expectedRemote) {
        throw "Remote origin tidak sesuai. Diharapkan: $expectedRemote"
    }

    Write-Host 'Memeriksa perubahan terbaru di GitHub...' -ForegroundColor Cyan
    Run-Git fetch origin main
    & git -C $repoPath merge-base --is-ancestor origin/main HEAD
    if ($LASTEXITCODE -ne 0) {
        throw 'origin/main sudah lebih baru atau riwayat berbeda. Sinkronkan perubahan remote secara manual sebelum push.'
    }

    Write-Host 'Menyiapkan perubahan wrapper Vercel...' -ForegroundColor Cyan
    Run-Git add -A
    & git -C $repoPath diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        Run-Git diff --cached --stat
        $stamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Run-Git commit -m "Update SIMPONI Vercel wrapper $stamp"
    } elseif ($LASTEXITCODE -eq 0) {
        Write-Host 'Tidak ada perubahan baru untuk di-commit.' -ForegroundColor Yellow
    } else {
        throw 'Gagal memeriksa perubahan yang sudah di-stage.'
    }

    Write-Host 'Mengirim branch main ke GitHub...' -ForegroundColor Cyan
    Run-Git push -u origin main
    Write-Host 'Selesai. GitHub menerima perubahan wrapper Vercel.' -ForegroundColor Green
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
