# CFO190 푸시 및 Vercel 배포 스크립트
# 사용법: 이 파일이 있는 폴더(CFO190-main)에서 PowerShell로 실행
#   .\push-and-deploy.ps1
# 또는 원격 URL 지정: $env:GIT_REMOTE = "https://github.com/사용자명/CFO190.git"; .\push-and-deploy.ps1

$ErrorActionPreference = "Stop"
$projectDir = $PSScriptRoot
if (-not $projectDir) { $projectDir = Get-Location }

Push-Location $projectDir

# GitHub 원격 URL (이전에 쓰던 저장소 주소로 바꾸세요)
# 예: https://github.com/사용자명/CFO190.git
$GIT_REMOTE = $env:GIT_REMOTE
if (-not $GIT_REMOTE) {
    $GIT_REMOTE = "https://github.com/sewoong333/CFO190.git"
}

# Git PATH 추가 (Windows 기본 설치 경로)
$gitPaths = @(
    "C:\Program Files\Git\cmd",
    "C:\Program Files (x86)\Git\cmd",
    "$env:LOCALAPPDATA\Programs\Git\cmd"
)
foreach ($p in $gitPaths) {
    if (Test-Path $p) { $env:Path = "$p;$env:Path"; break }
}

# --- Git 푸시 ---
try {
    $gitExe = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitExe) {
        Write-Host "Git을 찾을 수 없습니다. https://git-scm.com 에서 설치 후 다시 실행하세요." -ForegroundColor Red
        Pop-Location
        exit 1
    }

    if (-not (Test-Path ".git")) {
        git init
        Write-Host "Git 저장소 초기화 완료." -ForegroundColor Green
    }

    git add .
    $status = git status --short
    if ($status) {
        git commit -m "푸터 사업자정보 반영 및 배포"
        Write-Host "커밋 완료." -ForegroundColor Green
    } else {
        Write-Host "변경 사항 없음 (이미 커밋됨)." -ForegroundColor Gray
    }

    $remotes = git remote 2>$null
    if ($remotes -notmatch "origin") {
        git remote add origin $GIT_REMOTE
        Write-Host "원격 origin 추가: $GIT_REMOTE" -ForegroundColor Green
    }

    git branch -M main 2>$null
    git push -u origin main
    Write-Host "푸시 완료." -ForegroundColor Green
} catch {
    Write-Host "Git 푸시 중 오류 (원격 URL·권한 확인): $_" -ForegroundColor Red
}

# --- Vercel 배포 ---
Write-Host "`nVercel 배포 시도 중..." -ForegroundColor Cyan
try {
    npx vercel --yes
    Write-Host "배포 완료. 출력된 URL에서 확인하세요." -ForegroundColor Green
} catch {
    Write-Host "Vercel 배포 실패. 먼저 'npx vercel login' 으로 로그인 후 다시 실행하세요." -ForegroundColor Yellow
}

Pop-Location
