# ============================================================
# DT-16 VIRTUAL MUSEUM 360
# Architecture Diagram Generator
# Course: CSE703073
# ============================================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# PATH CONFIGURATION
# ------------------------------------------------------------

$projectRoot = Split-Path -Parent $PSScriptRoot
$docsPath = Join-Path $projectRoot "docs"
$outputPath = Join-Path $docsPath "architecture.png"

# ------------------------------------------------------------
# CREATE DOCS DIRECTORY
# ------------------------------------------------------------

if (-not (Test-Path $docsPath)) {
    New-Item -ItemType Directory -Path $docsPath -Force | Out-Null
}

# ------------------------------------------------------------
# LOAD SYSTEM.DRAWING
# ------------------------------------------------------------

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Drawing.Drawing2D

# ------------------------------------------------------------
# CANVAS CONFIGURATION
# ------------------------------------------------------------

$width = 1800
$height = 1250

$bitmap = New-Object System.Drawing.Bitmap($width, $height)

$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

$graphics.SmoothingMode =
    [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$graphics.InterpolationMode =
    [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

$graphics.TextRenderingHint =
    [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# ------------------------------------------------------------
# COLORS
# ------------------------------------------------------------

$backgroundColor = [System.Drawing.Color]::White
$titleColor = [System.Drawing.Color]::FromArgb(31, 41, 55)
$textColor = [System.Drawing.Color]::FromArgb(17, 24, 39)
$borderColor = [System.Drawing.Color]::FromArgb(75, 85, 99)

$frontendFill = [System.Drawing.Color]::FromArgb(219, 234, 254)
$backendFill = [System.Drawing.Color]::FromArgb(220, 252, 231)
$databaseFill = [System.Drawing.Color]::FromArgb(254, 249, 195)
$pythonFill = [System.Drawing.Color]::FromArgb(243, 232, 255)
$infraFill = [System.Drawing.Color]::FromArgb(229, 231, 235)
$featureFill = [System.Drawing.Color]::FromArgb(254, 226, 226)

# ------------------------------------------------------------
# BRUSHES
# ------------------------------------------------------------

$backgroundBrush = New-Object System.Drawing.SolidBrush($backgroundColor)
$titleBrush = New-Object System.Drawing.SolidBrush($titleColor)
$textBrush = New-Object System.Drawing.SolidBrush($textColor)

$frontendBrush = New-Object System.Drawing.SolidBrush($frontendFill)
$backendBrush = New-Object System.Drawing.SolidBrush($backendFill)
$databaseBrush = New-Object System.Drawing.SolidBrush($databaseFill)
$pythonBrush = New-Object System.Drawing.SolidBrush($pythonFill)
$infraBrush = New-Object System.Drawing.SolidBrush($infraFill)
$featureBrush = New-Object System.Drawing.SolidBrush($featureFill)

$borderPen = New-Object System.Drawing.Pen($borderColor, 3)
$arrowPen = New-Object System.Drawing.Pen($borderColor, 4)

# ------------------------------------------------------------
# FONTS
# ------------------------------------------------------------

$titleFont = New-Object System.Drawing.Font(
    "Segoe UI",
    28,
    [System.Drawing.FontStyle]::Bold
)

$sectionFont = New-Object System.Drawing.Font(
    "Segoe UI",
    20,
    [System.Drawing.FontStyle]::Bold
)

$boxTitleFont = New-Object System.Drawing.Font(
    "Segoe UI",
    17,
    [System.Drawing.FontStyle]::Bold
)

$bodyFont = New-Object System.Drawing.Font(
    "Segoe UI",
    14,
    [System.Drawing.FontStyle]::Regular
)

$smallFont = New-Object System.Drawing.Font(
    "Segoe UI",
    12,
    [System.Drawing.FontStyle]::Regular
)

# ------------------------------------------------------------
# DRAW BACKGROUND
# ------------------------------------------------------------

$graphics.Clear($backgroundColor)

# ------------------------------------------------------------
# HELPER FUNCTIONS
# ------------------------------------------------------------

function Draw-Box {
    param (
        [System.Drawing.Graphics]$Graphics,
        [int]$X,
        [int]$Y,
        [int]$W,
        [int]$H,
        [System.Drawing.Brush]$Fill,
        [string]$Title,
        [string[]]$Lines
    )

    $rect = New-Object System.Drawing.Rectangle($X, $Y, $W, $H)

    $Graphics.FillRectangle($Fill, $rect)
    $Graphics.DrawRectangle($borderPen, $rect)

    $Graphics.DrawString(
        $Title,
        $boxTitleFont,
        $textBrush,
        ($X + 20),
        ($Y + 15)
    )

    $lineY = $Y + 55

    foreach ($line in $Lines) {

        $Graphics.DrawString(
            $line,
            $bodyFont,
            $textBrush,
            ($X + 20),
            $lineY
        )

        $lineY += 29
    }
}

function Draw-Arrow {
    param (
        [System.Drawing.Graphics]$Graphics,
        [int]$X1,
        [int]$Y1,
        [int]$X2,
        [int]$Y2
    )

    $Graphics.DrawLine(
        $arrowPen,
        $X1,
        $Y1,
        $X2,
        $Y2
    )

    $arrowSize = 10

    if ($X2 -gt $X1) {

        $points = @(
            [System.Drawing.Point]::new($X2, $Y2),
            [System.Drawing.Point]::new(
                ($X2 - $arrowSize),
                ($Y2 - $arrowSize)
            ),
            [System.Drawing.Point]::new(
                ($X2 - $arrowSize),
                ($Y2 + $arrowSize)
            )
        )

        $Graphics.FillPolygon(
            $textBrush,
            $points
        )
    }
    elseif ($X2 -lt $X1) {

        $points = @(
            [System.Drawing.Point]::new($X2, $Y2),
            [System.Drawing.Point]::new(
                ($X2 + $arrowSize),
                ($Y2 - $arrowSize)
            ),
            [System.Drawing.Point]::new(
                ($X2 + $arrowSize),
                ($Y2 + $arrowSize)
            )
        )

        $Graphics.FillPolygon(
            $textBrush,
            $points
        )
    }
    elseif ($Y2 -gt $Y1) {

        $points = @(
            [System.Drawing.Point]::new($X2, $Y2),
            [System.Drawing.Point]::new(
                ($X2 - $arrowSize),
                ($Y2 - $arrowSize)
            ),
            [System.Drawing.Point]::new(
                ($X2 + $arrowSize),
                ($Y2 - $arrowSize)
            )
        )

        $Graphics.FillPolygon(
            $textBrush,
            $points
        )
    }
    else {

        $points = @(
            [System.Drawing.Point]::new($X2, $Y2),
            [System.Drawing.Point]::new(
                ($X2 - $arrowSize),
                ($Y2 + $arrowSize)
            ),
            [System.Drawing.Point]::new(
                ($X2 + $arrowSize),
                ($Y2 + $arrowSize)
            )
        )

        $Graphics.FillPolygon(
            $textBrush,
            $points
        )
    }
}

# ------------------------------------------------------------
# TITLE
# ------------------------------------------------------------

$graphics.DrawString(
    "DT-16 - VIRTUAL MUSEUM AND 360 DEGREE TOUR",
    $titleFont,
    $titleBrush,
    55,
    35
)

$graphics.DrawString(
    "CSE703073 - WEB APPLICATION DEVELOPMENT FOR TOURISM 2",
    $smallFont,
    $textBrush,
    58,
    78
)

# ------------------------------------------------------------
# LAYER 1 - FRONTEND
# ------------------------------------------------------------

$graphics.DrawString(
    "LAYER 1 - PRESENTATION",
    $sectionFont,
    $titleBrush,
    60,
    135
)

Draw-Box `
    -Graphics $graphics `
    -X 60 `
    -Y 180 `
    -W 500 `
    -H 270 `
    -Fill $frontendBrush `
    -Title "Vue 3 + Vite Frontend" `
    -Lines @(
        "Responsive Web Interface",
        "Panorama 360 Viewer",
        "Hotspot Interaction",
        "Free Tour / Guided Tour",
        "Themed Tour Routes",
        "Multilingual Audio",
        "Guestbook",
        "Personal Collection"
    )

Draw-Box `
    -Graphics $graphics `
    -X 650 `
    -Y 180 `
    -W 500 `
    -H 270 `
    -Fill $frontendBrush `
    -Title "Frontend Modules" `
    -Lines @(
        "Home",
        "Museum Spaces",
        "Panorama Viewer",
        "Artifact Information",
        "Tour Routes",
        "Guestbook",
        "Collection",
        "User Account"
    )

Draw-Box `
    -Graphics $graphics `
    -X 1240 `
    -Y 180 `
    -W 500 `
    -H 270 `
    -Fill $frontendBrush `
    -Title "Frontend Communication" `
    -Lines @(
        "REST API Client",
        "Authentication State",
        "Session / Cookie",
        "JSON Data",
        "Loading States",
        "Error Handling",
        "Theme: Light / Dark",
        "Responsive: 3 Screen Sizes"
    )

# ------------------------------------------------------------
# ARROWS FRONTEND
# ------------------------------------------------------------

Draw-Arrow `
    -Graphics $graphics `
    -X1 560 `
    -Y1 315 `
    -X2 650 `
    -Y2 315

Draw-Arrow `
    -Graphics $graphics `
    -X1 1150 `
    -Y1 315 `
    -X2 1240 `
    -Y2 315

# ------------------------------------------------------------
# LAYER 2 - BACKEND
# ------------------------------------------------------------

$graphics.DrawString(
    "LAYER 2 - APPLICATION AND API",
    $sectionFont,
    $titleBrush,
    60,
    505
)

Draw-Box `
    -Graphics $graphics `
    -X 60 `
    -Y 550 `
    -W 500 `
    -H 300 `
    -Fill $backendBrush `
    -Title "Laravel 11 Backend" `
    -Lines @(
        "REST API",
        "Controllers",
        "Services",
        "Models",
        "Middleware",
        "Policies",
        "Validation",
        "Authentication",
        "Authorization"
    )

Draw-Box `
    -Graphics $graphics `
    -X 650 `
    -Y 550 `
    -W 500 `
    -H 300 `
    -Fill $backendBrush `
    -Title "DT-16 Business Logic" `
    -Lines @(
        "Museum Space Management",
        "Panorama Management",
        "Artifact Hotspots",
        "Space Transitions",
        "Audio Narration",
        "Tour Route Management",
        "Guestbook",
        "Personal Collection",
        "Behavior Events"
    )

Draw-Box `
    -Graphics $graphics `
    -X 1240 `
    -Y 550 `
    -W 500 `
    -H 300 `
    -Fill $backendBrush `
    -Title "Security and API Rules" `
    -Lines @(
        "Server-side Access Control",
        "Password Hashing",
        "SQL Injection Protection",
        "XSS Protection",
        "CSRF Protection",
        "Input Validation",
        "URL Parameter Protection",
        "Environment Variables",
        "Application Logging"
    )

# ------------------------------------------------------------
# ARROWS BACKEND
# ------------------------------------------------------------

Draw-Arrow `
    -Graphics $graphics `
    -X1 310 `
    -Y1 450 `
    -X2 310 `
    -Y2 550

Draw-Arrow `
    -Graphics $graphics `
    -X1 900 `
    -Y1 450 `
    -X2 900 `
    -Y2 550

Draw-Arrow `
    -Graphics $graphics `
    -X1 1490 `
    -Y1 450 `
    -X2 1490 `
    -Y2 550

# ------------------------------------------------------------
# LAYER 3 - DATA
# ------------------------------------------------------------

$graphics.DrawString(
    "LAYER 3 - DATA",
    $sectionFont,
    $titleBrush,
    60,
    905
)

Draw-Box `
    -Graphics $graphics `
    -X 60 `
    -Y 950 `
    -W 500 `
    -H 220 `
    -Fill $databaseBrush `
    -Title "MySQL 8 Database" `
    -Lines @(
        "13 Tables",
        "23 Foreign Keys",
        "65 Indexes",
        "54 Seed Records",
        "utf8mb4",
        "InnoDB"
    )

Draw-Box `
    -Graphics $graphics `
    -X 650 `
    -Y 950 `
    -W 500 `
    -H 220 `
    -Fill $pythonBrush `
    -Title "Python 3.12 + FastAPI" `
    -Lines @(
        "Behavior Analytics",
        "Data Processing",
        "Pandas",
        "Scikit-learn",
        "Analytics API",
        "Batch Processing"
    )

Draw-Box `
    -Graphics $graphics `
    -X 1240 `
    -Y 950 `
    -W 500 `
    -H 220 `
    -Fill $infraBrush `
    -Title "Deployment Infrastructure" `
    -Lines @(
        "Nginx",
        "Docker Compose",
        "HTTPS",
        "Environment Configuration",
        "Logs",
        "Database Backup"
    )

# ------------------------------------------------------------
# ARROWS DATA
# ------------------------------------------------------------

Draw-Arrow `
    -Graphics $graphics `
    -X1 310 `
    -Y1 850 `
    -X2 310 `
    -Y2 950

Draw-Arrow `
    -Graphics $graphics `
    -X1 900 `
    -Y1 850 `
    -X2 900 `
    -Y2 950

Draw-Arrow `
    -Graphics $graphics `
    -X1 1490 `
    -Y1 850 `
    -X2 1490 `
    -Y2 950

# ------------------------------------------------------------
# BACKEND TO DATABASE / PYTHON
# ------------------------------------------------------------

Draw-Arrow `
    -Graphics $graphics `
    -X1 560 `
    -Y1 1060 `
    -X2 650 `
    -Y2 1060

Draw-Arrow `
    -Graphics $graphics `
    -X1 1150 `
    -Y1 1060 `
    -X2 1240 `
    -Y2 1060

# ------------------------------------------------------------
# DT-16 CORE FLOW
# ------------------------------------------------------------

$flowY = 1210

$graphics.DrawString(
    "Core flow: Visitor -> Vue 3 -> Laravel API -> MySQL / Python Analytics -> JSON -> Vue 3",
    $smallFont,
    $textBrush,
    60,
    $flowY
)

# ------------------------------------------------------------
# SAVE PNG
# ------------------------------------------------------------

$bitmap.Save(
    $outputPath,
    [System.Drawing.Imaging.ImageFormat]::Png
)

# ------------------------------------------------------------
# CLEANUP
# ------------------------------------------------------------

$graphics.Dispose()
$bitmap.Dispose()

$backgroundBrush.Dispose()
$titleBrush.Dispose()
$textBrush.Dispose()

$frontendBrush.Dispose()
$backendBrush.Dispose()
$databaseBrush.Dispose()
$pythonBrush.Dispose()
$infraBrush.Dispose()
$featureBrush.Dispose()

$borderPen.Dispose()
$arrowPen.Dispose()

$titleFont.Dispose()
$sectionFont.Dispose()
$boxTitleFont.Dispose()
$bodyFont.Dispose()
$smallFont.Dispose()

# ------------------------------------------------------------
# RESULT
# ------------------------------------------------------------

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "DT-16 ARCHITECTURE GENERATOR" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $outputPath) {

    $fileInfo = Get-Item $outputPath

    Write-Host "[PASS] Architecture diagram created." -ForegroundColor Green
    Write-Host ""
    Write-Host "File:" -ForegroundColor Yellow
    Write-Host $fileInfo.FullName
    Write-Host ""
    Write-Host "Size: $($fileInfo.Length) bytes" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "[PASS] Buoc 4 architecture diagram: PASS." -ForegroundColor Green

}
else {

    Write-Host "[FAIL] Architecture diagram was not created." -ForegroundColor Red
    exit 1
}
