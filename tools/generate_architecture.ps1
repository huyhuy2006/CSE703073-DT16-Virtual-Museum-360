$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$docsPath = Join-Path $projectRoot "docs"
$outputPath = Join-Path $docsPath "architecture.png"

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "DT-16 - ARCHITECTURE CHECK" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

if (-not (Test-Path $docsPath)) {
    New-Item -ItemType Directory -Path $docsPath -Force | Out-Null
}

if (Test-Path $outputPath) {
    Write-Host "[PASS] architecture.png da ton tai." -ForegroundColor Green
    Write-Host "Path : $outputPath" -ForegroundColor Gray
}
else {
    Write-Host "[FAIL] Khong tim thay architecture.png." -ForegroundColor Red
    Write-Host "Hay tao architecture.png tu Mermaid theo kien truc DT-16." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Kiem tra kich thuoc file..." -ForegroundColor Cyan

$fileInfo = Get-Item $outputPath

if ($fileInfo.Length -gt 0) {
    Write-Host "[PASS] architecture.png co du lieu." -ForegroundColor Green
    Write-Host ("Size : {0} bytes" -f $fileInfo.Length) -ForegroundColor Gray
}
else {
    Write-Host "[FAIL] architecture.png rong." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==============================================" -ForegroundColor Green
Write-Host "ARCHITECTURE CHECK: PASS" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green