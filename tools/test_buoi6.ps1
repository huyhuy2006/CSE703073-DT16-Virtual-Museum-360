$ErrorActionPreference = "Stop"

$projectRoot = "C:\CSE703073\DT16-Virtual-Museum-360"
$backendPath = Join-Path $projectRoot "backend"
$frontendPath = Join-Path $projectRoot "frontend"

Set-Location $projectRoot

$pass = 0
$fail = 0
$warn = 0

function Pass([string]$message) {
    $script:pass++
    Write-Host "[PASS] $message" -ForegroundColor Green
}

function Fail([string]$message) {
    $script:fail++
    Write-Host "[FAIL] $message" -ForegroundColor Red
}

function Warn([string]$message) {
    $script:warn++
    Write-Host "[WARN] $message" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " CSE703073 - DT-16 VIRTUAL MUSEUM 360" -ForegroundColor Cyan
Write-Host " BUOI 6 - BACKEND AUTH API TEST" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "[1] PROJECT" -ForegroundColor Yellow

if ((Get-Location).Path -eq $projectRoot) {
    Pass "Project root dung."
}
else {
    Fail "Project root sai."
}

Write-Host ""
Write-Host "[2] BRANCH" -ForegroundColor Yellow

$branch = git branch --show-current

if ($branch -eq "feature/buoi6-backend-auth-api") {
    Pass "Branch dung: $branch"
}
else {
    Fail "Branch hien tai: $branch"
}

Write-Host ""
Write-Host "[3] GIT STATUS" -ForegroundColor Yellow

$status = git --no-pager status --short

if ([string]::IsNullOrWhiteSpace($status)) {
    Pass "Working tree clean."
}
else {
    Warn "Working tree dang co thay doi:"
    $status
}

Write-Host ""
Write-Host "[4] BACKEND" -ForegroundColor Yellow

if (Test-Path (Join-Path $backendPath "artisan")) {
    Pass "Laravel backend ton tai."
}
else {
    Fail "Khong tim thay backend/artisan."
    exit 1
}

Write-Host ""
Write-Host "[5] LARAVEL VERSION" -ForegroundColor Yellow

Set-Location $backendPath

$laravelVersion = php artisan --version

if ($laravelVersion -match "Laravel Framework 11\.") {
    Pass $laravelVersion
}
else {
    Fail "Khong phai Laravel 11: $laravelVersion"
}

Write-Host ""
Write-Host "[6] SANCTUM" -ForegroundColor Yellow

$sanctum = composer show laravel/sanctum --format=json 2>$null |
    ConvertFrom-Json

if ($sanctum.name -eq "laravel/sanctum" -and
    $sanctum.versions -match "4\.") {
    Pass "Sanctum 4.x."
}
else {
    Fail "Khong xac nhan duoc Sanctum 4.x."
}

Write-Host ""
Write-Host "[7] ROUTES API" -ForegroundColor Yellow

$routeList = php artisan route:list --path=api/v1

$requiredRoutes = @(
    "api/v1/health",
    "api/v1/auth/login",
    "api/v1/auth/me",
    "api/v1/auth/logout",
    "api/v1/spaces",
    "api/v1/tours",
    "api/v1/collections",
    "api/v1/guestbook",
    "api/v1/admin/check"
)

foreach ($route in $requiredRoutes) {
    if ($routeList -match [regex]::Escape($route)) {
        Pass "Route ton tai: $route"
    }
    else {
        Fail "Thieu route: $route"
    }
}

Write-Host ""
Write-Host "[8] DATABASE CONNECTION" -ForegroundColor Yellow

$dbTest = php artisan tinker --execute="DB::connection()->getPdo(); echo 'DATABASE CONNECTION PASS';"

if ($dbTest -match "DATABASE CONNECTION PASS") {
    Pass "Laravel ket noi MySQL."
}
else {
    Fail "Laravel khong ket noi duoc MySQL."
}

Write-Host ""
Write-Host "[9] USERS TABLE" -ForegroundColor Yellow

$userCount = php artisan tinker --execute="echo DB::table('users')->count();"

if ([int]$userCount -ge 1) {
    Pass "users table doc duoc. Count=$userCount"
}
else {
    Fail "users table rong hoac khong doc duoc."
}

Write-Host ""
Write-Host "[10] PUBLIC HEALTH API" -ForegroundColor Yellow

Set-Location $projectRoot

try {
    $health = Invoke-RestMethod `
        -Uri "http://127.0.0.1:8000/api/v1/health" `
        -Method Get `
        -Headers @{
            Accept = "application/json"
        }

    if ($health.status -eq "ok") {
        Pass "Health API PASS."
    }
    else {
        Fail "Health API khong tra status=ok."
    }
}
catch {
    Fail "Khong goi duoc Health API. Hay chay php artisan serve --port=8000."
}

Write-Host ""
Write-Host "[11] PUBLIC SPACES API" -ForegroundColor Yellow

try {
    $spaces = Invoke-RestMethod `
        -Uri "http://127.0.0.1:8000/api/v1/spaces" `
        -Method Get `
        -Headers @{
            Accept = "application/json"
        }

    if ($null -ne $spaces.data) {
        Pass "Spaces API PASS."
    }
    else {
        Fail "Spaces API khong co data."
    }
}
catch {
    Fail "Khong goi duoc Spaces API."
}

Write-Host ""
Write-Host "[12] PROTECTED ADMIN API WITHOUT LOGIN" -ForegroundColor Yellow

try {
    Invoke-WebRequest `
        -Uri "http://127.0.0.1:8000/api/v1/admin/check" `
        -Method Get `
        -Headers @{
            Accept = "application/json"
        } `
        -UseBasicParsing `
        -ErrorAction Stop | Out-Null

    Fail "Admin API khong duoc chan khi chua dang nhap."
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__

    if ($statusCode -eq 401) {
        Pass "Admin API tra 401 khi chua dang nhap."
    }
    else {
        Warn "Admin API tra HTTP $statusCode thay vi 401."
    }
}

Write-Host ""
Write-Host "[13] ENV SECURITY" -ForegroundColor Yellow

$forbiddenEnv = Get-ChildItem $projectRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -eq ".env" -or
        $_.Name -eq ".env.local" -or
        $_.Name -eq ".env.development" -or
        $_.Name -eq ".env.production" -or
        $_.Name -eq ".env.test"
    }

$forbiddenEnvNonBackend = $forbiddenEnv |
    Where-Object {
        $_.FullName -ne (Join-Path $backendPath ".env")
    }

if ($forbiddenEnvNonBackend.Count -eq 0) {
    Pass "Khong co ENV bi cam ngoai backend/.env local."
}
else {
    Fail "Phat hien ENV bi cam:"
    $forbiddenEnvNonBackend.FullName
}

Write-Host ""
Write-Host "[14] FRONTEND BUILD" -ForegroundColor Yellow

Set-Location $frontendPath

npm run build

if ($LASTEXITCODE -eq 0) {
    Pass "Frontend build PASS."
}
else {
    Fail "Frontend build FAIL."
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " BUOI 6 TEST RESULT" -ForegroundColor Cyan
Write-Host " PASS : $pass" -ForegroundColor Green
Write-Host " FAIL : $fail" -ForegroundColor Red
Write-Host " WARN : $warn" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

if ($fail -gt 0) {
    exit 1
}

exit 0
