# BootSplash.ps1 — MERCILESS AUTHORITY Boot Splash Screen
# ─────────────────────────────────────────────────────────────────────
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8328 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ─────────────────────────────────────────────────────────────────────
# Displays a dramatic fullscreen boot animation while MercilessAuthority.exe initializes.
# Launched silently by LaunchBattery.vbs on every logon. Auto-closes after sequence completes.
# Version 1.0 March 19, 2026 - Born. Smooth progress bar, fake step labels, timer-based.
# Version 2.0 March 19, 2026 - REAL: polls Get-Process MercilessAuthority every 200ms.
#                              Bar advances through real checkpoints as the process actually
#                              starts and stabilizes. No more fake hardcoded timer steps.
#                              ESC + click-anywhere escape added as safety net.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class SplashAPI {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
}
"@

[SplashAPI]::SetProcessDPIAware() | Out-Null

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$sw = [int]$screen.Width
$sh = [int]$screen.Height

function Get-DarkenedWallpaper {
    param([int]$width, [int]$height)
    $paths = @("$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper")
    $slideshowFolder = Join-Path $env:USERPROFILE "OneDrive\Desktop\Important Slideshow Wallpapers"
    if (Test-Path $slideshowFolder) {
        $imgs = Get-ChildItem $slideshowFolder -Include *.jpg,*.jpeg,*.png,*.bmp,*.webp -Recurse -ErrorAction SilentlyContinue
        if ($imgs -and $imgs.Count -gt 0) { $paths += ($imgs | Get-Random).FullName }
    }
    $regWall = (Get-ItemProperty "HKCU:\Control Panel\Desktop" -ErrorAction SilentlyContinue).Wallpaper
    if ($regWall) { $paths += $regWall }
    $src = $null
    foreach ($p in $paths) {
        if ($p -and (Test-Path $p)) {
            try {
                $bytes = [System.IO.File]::ReadAllBytes($p)
                $ms = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
                $src = [System.Drawing.Bitmap]::FromStream($ms)
                break
            } catch {}
        }
    }
    $result = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($result)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    if ($src) { $g.DrawImage($src, 0, 0, $width, $height); $src.Dispose() }
    else { $g.Clear([System.Drawing.Color]::FromArgb(5, 0, 0)) }
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(175, 0, 0, 0))
    $g.FillRectangle($brush, 0, 0, $width, $height)
    $brush.Dispose(); $g.Dispose()
    return $result
}

$wallBmp = Get-DarkenedWallpaper -width $sw -height $sh

$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle       = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition         = [System.Windows.Forms.FormStartPosition]::Manual
$form.Bounds                = $screen
$form.TopMost               = $true
$form.ShowInTaskbar         = $false
$form.BackgroundImage       = $wallBmp
$form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
$form.BackColor             = [System.Drawing.Color]::FromArgb(5, 0, 0)
$form.Opacity               = 0.0

$iconPath = Join-Path $PSScriptRoot "holycleanAPP.ico"
if (Test-Path $iconPath) {
    try { $s = [System.IO.File]::OpenRead($iconPath); $form.Icon = New-Object System.Drawing.Icon($s); $s.Close() } catch {}
}

$tBar = New-Object System.Windows.Forms.Panel
$tBar.BackColor = [System.Drawing.Color]::FromArgb(220, 0, 0)
$tBar.Size      = New-Object System.Drawing.Size($sw, 6)
$tBar.Location  = New-Object System.Drawing.Point(0, 0)
$form.Controls.Add($tBar)

$bBar = New-Object System.Windows.Forms.Panel
$bBar.BackColor = [System.Drawing.Color]::FromArgb(220, 0, 0)
$bBar.Size      = New-Object System.Drawing.Size($sw, 6)
$bBar.Location  = New-Object System.Drawing.Point(0, $sh - 6)
$form.Controls.Add($bBar)

$titleFontSz = [Math]::Max(20, [int]($sh / 35))
$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text      = "MERCILESS AUTHORITY"
$titleLbl.ForeColor = [System.Drawing.Color]::FromArgb(255, 60, 60)
$titleLbl.BackColor = [System.Drawing.Color]::Transparent
$titleLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $titleFontSz, [System.Drawing.FontStyle]::Bold)
$titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$titleLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.8), [int]($sh * 0.12))
$titleLbl.Location  = New-Object System.Drawing.Point([int](($sw - $titleLbl.Width) / 2), [int]($sh * 0.30))
$form.Controls.Add($titleLbl)

$subFontSz = [Math]::Max(10, [int]($sh / 72))
$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text      = "TOTALITARIAN BATTERY MONITOR — NO MERCY, NO REMORSE"
$subLbl.ForeColor = [System.Drawing.Color]::FromArgb(180, 180, 180)
$subLbl.BackColor = [System.Drawing.Color]::Transparent
$subLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $subFontSz, [System.Drawing.FontStyle]::Regular)
$subLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$subLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.8), [int]($sh * 0.06))
$subLbl.Location  = New-Object System.Drawing.Point([int](($sw - $subLbl.Width) / 2), [int]($sh * 0.42))
$form.Controls.Add($subLbl)

$stepFontSz = [Math]::Max(9, [int]($sh / 80))
$stepLbl = New-Object System.Windows.Forms.Label
$stepLbl.Text      = "Launching..."
$stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$stepLbl.BackColor = [System.Drawing.Color]::Transparent
$stepLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $stepFontSz, [System.Drawing.FontStyle]::Regular)
$stepLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$stepLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.6), [int]($sh * 0.05))
$stepLbl.Location  = New-Object System.Drawing.Point([int](($sw - $stepLbl.Width) / 2), [int]($sh * 0.565))
$form.Controls.Add($stepLbl)

$barW = [int]($sw * 0.50)
$barH = [int]([Math]::Max(6, $sh * 0.008))
$barX = [int](($sw - $barW) / 2)
$barY = [int]($sh * 0.62)

$barTrack = New-Object System.Windows.Forms.Panel
$barTrack.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$barTrack.Size      = New-Object System.Drawing.Size($barW, $barH)
$barTrack.Location  = New-Object System.Drawing.Point($barX, $barY)
$form.Controls.Add($barTrack)

$barFill = New-Object System.Windows.Forms.Panel
$barFill.BackColor = [System.Drawing.Color]::FromArgb(220, 0, 0)
$barFill.Size      = New-Object System.Drawing.Size(0, $barH)
$barFill.Location  = New-Object System.Drawing.Point(0, 0)
$barTrack.Controls.Add($barFill)

$verLbl = New-Object System.Windows.Forms.Label
$verLbl.Text      = "v2.21 — Rabbi S. Arlan"
$verLbl.ForeColor = [System.Drawing.Color]::FromArgb(90, 90, 90)
$verLbl.BackColor = [System.Drawing.Color]::Transparent
$verLbl.Font      = New-Object System.Drawing.Font("Segoe UI", [Math]::Max(8, [int]($sh/90)), [System.Drawing.FontStyle]::Regular)
$verLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$verLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.4), 30)
$verLbl.Location  = New-Object System.Drawing.Point([int](($sw - $verLbl.Width) / 2), [int]($sh * 0.67))
$form.Controls.Add($verLbl)

# ── REAL PROCESS POLLING STATE ────────────────────────────────────
# Real checkpoints based on what we can actually observe externally:
# 1. exe not yet found in process list      → 0-25%   "Waiting for process..."
# 2. exe found, process just started        → 25-55%  "MercilessAuthority loaded..."
# 3. exe stable for 300ms                   → 55-80%  "Battery API initialized..."
# 4. exe stable for 800ms (mutex + WinForms ready) → 80-100% "MERCILESS AUTHORITY IS WATCHING."
# 5. fade out

$script:phase      = 0       # 0=fade-in, 1=polling, 2=fade-out
$script:opacity    = 0.0
$script:barCurrent = 0.0
$script:barTarget  = 8.0     # start slightly filled
$script:pollStep   = 0       # 0=waiting, 1=found, 2=stable1, 3=stable2, 4=done
$script:stableCount = 0
$script:maxWait    = 0        # safety timeout counter (max ~15 seconds)

$animTimer = New-Object System.Windows.Forms.Timer
$animTimer.Interval = 16

$animTimer.Add_Tick({
    # ── PHASE 0: Fade in ─────────────────────────────────────────
    if ($script:phase -eq 0) {
        $script:opacity += 0.045
        if ($script:opacity -ge 1.0) { $script:opacity = 1.0; $script:phase = 1 }
        $form.Opacity = $script:opacity
        return
    }

    # ── PHASE 1: Real process polling ────────────────────────────
    if ($script:phase -eq 1) {
        # Smooth bar interpolation always running
        $barDelta = $script:barTarget - $script:barCurrent
        if ([Math]::Abs($barDelta) -lt 0.3) { $script:barCurrent = $script:barTarget }
        else { $script:barCurrent += $barDelta * 0.08 }
        $newW = [Math]::Max(0, [Math]::Min($barW, [int]$script:barCurrent))
        $barFill.Width = $newW

        # Poll process every ~200ms (every 12 ticks at 16ms)
        $script:maxWait++

        # Safety timeout at ~15 seconds — something went wrong, just close
        if ($script:maxWait -ge 940) {
            $script:barTarget  = $barW
            $script:barCurrent = $barW
            $barFill.Width     = $barW
            $stepLbl.Text      = "MERCILESS AUTHORITY IS WATCHING."
            $stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(80, 220, 80)
            $script:phase = 2
            return
        }

        if ($script:maxWait % 12 -ne 0) { return }

        # Real checkpoint logic
        $proc = Get-Process -Name "MercilessAuthority" -ErrorAction SilentlyContinue

        if ($script:pollStep -eq 0) {
            # Waiting for process to appear
            $stepLbl.Text      = "Waiting for MERCILESS AUTHORITY..."
            $stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
            $script:barTarget  = [int]($barW * 0.20)
            if ($proc) {
                $script:pollStep = 1
                $script:stableCount = 0
            }

        } elseif ($script:pollStep -eq 1) {
            # Process found — confirm it's alive
            $stepLbl.Text      = "MercilessAuthority.exe loaded..."
            $stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
            $script:barTarget  = [int]($barW * 0.45)
            if ($proc) {
                $script:stableCount++
                if ($script:stableCount -ge 2) {  # ~400ms stable
                    $script:pollStep = 2
                    $script:stableCount = 0
                }
            } else {
                $script:pollStep = 0  # lost it, wait again
            }

        } elseif ($script:pollStep -eq 2) {
            # Stable — battery API + mutex acquired by now
            $stepLbl.Text      = "Battery API initialized. Mutex acquired..."
            $stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
            $script:barTarget  = [int]($barW * 0.75)
            if ($proc) {
                $script:stableCount++
                if ($script:stableCount -ge 4) {  # ~800ms stable
                    $script:pollStep = 3
                    $script:stableCount = 0
                }
            } else {
                $script:pollStep = 0
            }

        } elseif ($script:pollStep -eq 3) {
            # Fully initialized
            $stepLbl.Text      = "MERCILESS AUTHORITY IS WATCHING."
            $stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(80, 220, 80)
            $script:barTarget  = $barW
            $script:pollStep   = 4

        } elseif ($script:pollStep -eq 4) {
            # Bar finished → wait for it to reach 100% then fade out
            if ([Math]::Abs($script:barCurrent - $barW) -lt 2) {
                $script:stableCount++
                if ($script:stableCount -ge 4) {  # hold for ~800ms then fade
                    $script:phase = 2
                }
            }
        }
        return
    }

    # ── PHASE 2: Fade out ─────────────────────────────────────────
    if ($script:phase -eq 2) {
        $script:opacity -= 0.055
        if ($script:opacity -le 0.0) {
            $script:opacity = 0.0
            $animTimer.Stop()
            $form.Close()
        }
        $form.Opacity = $script:opacity
    }
})

# ESC or click = instant close (safety escape)
$form.Add_Click({ $script:phase = 2 })
$form.KeyPreview = $true
$form.Add_KeyDown({
    param($s, $e)
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) { $script:phase = 2 }
})

$form.Add_Shown({
    [SplashAPI]::SetWindowPos($form.Handle, [SplashAPI]::HWND_TOPMOST, 0, 0, 0, 0, 0x0003) | Out-Null
    $animTimer.Start()
})

$form.ShowDialog() | Out-Null
try { $animTimer.Stop(); $animTimer.Dispose() } catch {}
$wallBmp.Dispose()
$form.Dispose()
