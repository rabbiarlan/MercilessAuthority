# Recompile.ps1 — MERCILESS AUTHORITY Auto-Recompile Script
# Author: Rabbi S. Arlan
# Run this in PowerShell 7 (pwsh) as Administrator.
# Does everything in the RECOMPILE_GUIDE automatically. One run. Done.
# ─────────────────────────────────────────────────────────────────

$scriptPath = "C:\Scripts\BatteryMercy.ps1"
$outputPath = "C:\Scripts\MercilessAuthority.exe"
$iconPath   = "C:\Users\Administrator\OneDrive\Desktop\Useless Stuff\holycleanAPP.ico"

Write-Host ""
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Red
Write-Host "     MERCILESS AUTHORITY — AUTO RECOMPILE INITIATED  " -ForegroundColor Red
Write-Host "  Made by Rabbi S. Arlan — March 19, 2026            " -ForegroundColor Red
Write-Host "═════════════════════════════════════════════════════" -ForegroundColor Red
Write-Host ""

# ── STEP 1: Kill running instance ──────────────────────────────
Write-Host "[1/6] Killing MercilessAuthority.exe..." -ForegroundColor Yellow
Stop-Process -Name "MercilessAuthority" -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 700
Write-Host "      Done." -ForegroundColor Green

# ── STEP 2: Verify ps2exe ──────────────────────────────────────
Write-Host "[2/6] Checking ps2exe..." -ForegroundColor Yellow
if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
    Write-Host "      ps2exe not found. Installing..." -ForegroundColor Cyan
    Install-Module -Name ps2exe -Scope CurrentUser -Force
    if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
        Write-Host "      FAILED: ps2exe install failed. Aborting." -ForegroundColor Red
        exit 1
    }
}
Write-Host "      ps2exe ready." -ForegroundColor Green

# ── STEP 3: Verify source files ───────────────────────────────
Write-Host "[3/6] Verifying source files..." -ForegroundColor Yellow
if (-not (Test-Path $scriptPath)) {
    Write-Host "      FAILED: BatteryMercy.ps1 not found at $scriptPath" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $iconPath)) {
    Write-Host "      WARNING: Icon not found — compiling without icon." -ForegroundColor DarkYellow
    $iconPath = $null
}
Write-Host "      All files verified." -ForegroundColor Green

# ── STEP 4: Compile ────────────────────────────────────────────
Write-Host "[4/6] Compiling..." -ForegroundColor Yellow
$compileParams = @{
    inputFile   = $scriptPath
    outputFile  = $outputPath
    title       = "MERCILESS AUTHORITY"
    description = "Totalitarian Battery Monitor - No Mercy, No Remorse"
    product     = "BatteryMercy System"
    company     = "Rabbi S. Arlan"
    copyright   = "2026 Rabbi S. Arlan. All rights reserved."
    version     = "2.13.0.0"
    noConsole   = $true
    noOutput    = $true
    noError     = $true
}
if ($iconPath) { $compileParams.iconFile = $iconPath }

try {
    Invoke-ps2exe @compileParams
} catch {
    Write-Host "      COMPILE ERROR: $_" -ForegroundColor Red
    exit 1
}

# ── STEP 5: Verify output ──────────────────────────────────────
Write-Host "[5/6] Verifying output..." -ForegroundColor Yellow
if (-not (Test-Path $outputPath)) {
    Write-Host "      FAILED: MercilessAuthority.exe was not created." -ForegroundColor Red
    exit 1
}
$age = (Get-Date) - (Get-Item $outputPath).LastWriteTime
if ($age.TotalSeconds -gt 60) {
    Write-Host "      WARNING: .exe exists but timestamp looks old. Compile may have silently failed." -ForegroundColor DarkYellow
} else {
    Write-Host "      Fresh .exe confirmed." -ForegroundColor Green
}

# ── STEP 6: Relaunch ───────────────────────────────────────────
Write-Host "[6/6] Launching fresh MercilessAuthority.exe..." -ForegroundColor Yellow
Start-Process $outputPath
Start-Sleep -Milliseconds 800

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "   RECOMPILE COMPLETE. MERCILESS AUTHORITY LIVES.  " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Verify in Task Manager → Details tab → Description: MERCILESS AUTHORITY" -ForegroundColor Cyan
Write-Host ""
