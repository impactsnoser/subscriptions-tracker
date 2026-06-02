# Запуск из PowerShell (в папке проекта):
#   Set-ExecutionPolicy -Scope Process Bypass
#   .\scripts\push-to-github.ps1
# Или с именем репозитория:
#   .\scripts\push-to-github.ps1 -RepoName "subscriptions-tracker-ios"

param(
    [string]$RepoName = "subscriptions-tracker-ios",
    [ValidateSet("public", "private")]
    [string]$Visibility = "public"
)

$ErrorActionPreference = "Stop"
$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

Set-Location -LiteralPath $ProjectRoot
Write-Host "Папка проекта: $ProjectRoot" -ForegroundColor Cyan

function Find-Git {
    $candidates = @(
        "git",
        "$env:ProgramFiles\Git\cmd\git.exe",
        "${env:ProgramFiles(x86)}\Git\cmd\git.exe"
    )
    foreach ($c in $candidates) {
        if (Get-Command $c -ErrorAction SilentlyContinue) { return (Get-Command $c).Source }
    }
    return $null
}

$git = Find-Git
if (-not $git) {
    Write-Host "Git не найден. Установи: winget install Git.Git" -ForegroundColor Red
    Write-Host "После установки перезапусти PowerShell и снова запусти этот скрипт."
    exit 1
}

Write-Host "Git: $git" -ForegroundColor Green

if (-not (Test-Path ".git")) {
    & $git init
    & $git branch -M main
}

& $git add .
$status = & $git status --porcelain
if ($status) {
    & $git commit -m "Subscriptions app: SwiftUI + SwiftData + CI IPA build"
    Write-Host "Коммит создан." -ForegroundColor Green
} else {
    Write-Host "Нет изменений для коммита." -ForegroundColor Yellow
}

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "GitHub CLI (gh) не установлен." -ForegroundColor Yellow
    Write-Host "1) Создай репозиторий на https://github.com/new (имя: $RepoName)"
    Write-Host "2) Выполни:"
    Write-Host "   & '$git' remote add origin https://github.com/<ТВОЙ_ЛОГИН>/$RepoName.git"
    Write-Host "   & '$git' push -u origin main"
    exit 0
}

$ghAuth = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Войди в GitHub CLI: gh auth login" -ForegroundColor Yellow
    exit 1
}

$remotes = & $git remote 2>$null
if ($remotes -notcontains "origin") {
    gh repo create $RepoName --$Visibility --source=. --remote=origin --push
} else {
    & $git push -u origin main
}

Write-Host ""
Write-Host "Готово! Открой Actions на GitHub:" -ForegroundColor Green
Write-Host "https://github.com/$(gh api user -q .login 2>$null)/$RepoName/actions"
Write-Host "Скачай IPA из Artifacts после успешного workflow Build IPA."
