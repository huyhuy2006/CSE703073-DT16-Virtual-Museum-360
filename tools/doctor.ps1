# =========================================================
# CSE703073 - DT-16
# tools/doctor.ps1
#
# Kiem chung moi truong phat trien tren Windows PowerShell.
#
# Yeu cau tham chieu:
# Git >= 2.40
# PHP >= 8.2
# Composer >= 2.7
# MySQL >= 8.0
# Node >= 20
# Python >= 3.11
# Docker >= 24
#
# =========================================================

$checks = @(
    @{ n = "git";      c = "git --version";      r = "Git >= 2.40" },
    @{ n = "php";      c = "php -v";             r = "PHP >= 8.2" },
    @{ n = "composer"; c = "composer --version"; r = "Composer >= 2.7" },
    @{ n = "mysql";    c = "mysql --version";    r = "MySQL >= 8.0" },
    @{ n = "node";     c = "node -v";            r = "Node >= 20" },
    @{ n = "python";   c = "python --version";   r = "Python >= 3.11" },
    @{ n = "docker";   c = "docker --version";   r = "Docker >= 24" }
)

Write-Host ""
Write-Host "========================================================="
Write-Host " CSE703073 - KIEM CHUNG MOI TRUONG"
Write-Host " DE TAI: DT-16 - BAO TANG AO VA TOUR 360 DO"
Write-Host "========================================================="
Write-Host ""

foreach ($k in $checks) {

    $exe = $k.c.Split(" ")[0]

    if (Get-Command $exe -ErrorAction SilentlyContinue) {

        $v = (Invoke-Expression $k.c 2>&1 |
            Select-Object -First 1)

        Write-Host (
            " [OK]     {0,-10} {1}" -f $k.n, $v
        )

    }
    else {

        Write-Host (
            " [THIEU]  {0,-10} can: {1}" -f $k.n, $k.r
        ) -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "-- PHP extensions --"

if (Get-Command php -ErrorAction SilentlyContinue) {

    $phpModules = php -m 2>$null

    $requiredExtensions = @(
        "pdo_mysql",
        "mbstring",
        "openssl",
        "fileinfo",
        "curl",
        "zip",
        "intl",
        "gd"
    )

    foreach ($extension in $requiredExtensions) {

        if ($phpModules -contains $extension) {

            Write-Host " [OK]     $extension"

        }
        else {

            Write-Host (
                " [THIEU]  {0} - bat trong php.ini" -f $extension
            ) -ForegroundColor Yellow
        }
    }

}
else {

    Write-Host " [THIEU]  PHP chua duoc cai dat" `
        -ForegroundColor Yellow
}

Write-Host ""
Write-Host "-- Node / npm --"

if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host (" [OK]     node       {0}" -f (node -v))
}
else {
    Write-Host " [THIEU]  node" -ForegroundColor Yellow
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Host (" [OK]     npm        {0}" -f (npm -v))
}
else {
    Write-Host " [THIEU]  npm" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "-- Git identity --"

$userName = git config user.name
$userEmail = git config user.email

Write-Host (
    " user.name  : {0}" -f $userName
)

Write-Host (
    " user.email : {0}" -f $userEmail
)

Write-Host ""
Write-Host "-- Project location --"

Write-Host (
    " current path: {0}" -f (Get-Location)
)

Write-Host ""
Write-Host "========================================================="
Write-Host " KIEM TRA HOAN TAT"
Write-Host "========================================================="
Write-Host ""
