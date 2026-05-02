# RecompileSplash.ps1 — MERCILESS AUTHORITY Fullscreen Recompile Animation
# ═══════════════════════════════════════════════════════════════════
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8328 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ═══════════════════════════════════════════════════════════════════
# Full-screen animated recompile sequence. Copies BootSplash structure exactly.
# Real ps2exe compile runs in background Runspace. Step label + bar update live.
# Fades in → runs steps → shows result → click anywhere or 5s auto-close → fades out.
# Version 1.0 March 19, 2026 - Windowed (broken, replaced)
# Version 2.0 March 19, 2026 - Rebuilt fullscreen using BootSplash structure. Real compile. Live steps.
# Version 2.1 March 19, 2026 - Now tried Windsurf which is a completely legitimate copy of VSCode Studio
#                              promising better AI... (i hope so lol..)
#                              And now blud's frustated and stressed as i gave him scenarios like defeating cancer
#                              or rejecting the cute loli anime catgirl demon succubus' sex offer
#                              while literally fixing everything that the terminal spew out errors
#                              This is what it legitimately actually said: "I'm tired of this shi lmao"(why did the autocomplete said that)
# Version 2.2 March 20, 2026 - Windsurf introduced duplicate Add-Type for RcState inside worker @'...'@
#                              causing "type already exists" conflict. Runspace shares same AppDomain
#                              as main session so outer RcState is already visible to worker.
#                              Removed inner Add-Type entirely. try/finally guarantees Done=true always.
#                              ESC + click-anywhere escape at any phase — no more lockouts ever.
#                              Removed this fraking bloatware and rollback to VSCode Studio.
# ─────────────────────────────────────────────────────────────────────

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

try {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Collections.Concurrent;
public class RcSplashAPI {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
}
public class RcState {
    public static ConcurrentQueue<string[]> Queue = new ConcurrentQueue<string[]>();
    public static volatile bool Done    = false;
    public static volatile bool Success = false;
    public static volatile int  Pct     = 0;
}
"@
} catch { }

[RcSplashAPI]::SetProcessDPIAware() | Out-Null

$scriptPath = "$PSScriptRoot\BatteryMercy.ps1"
$outputPath = "$PSScriptRoot\MercilessAuthority.exe"
$iconPath = Join-Path $PSScriptRoot "holycleanAPP.ico"

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
                $ms    = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
                $src   = [System.Drawing.Bitmap]::FromStream($ms)
                break
            } catch {}
        }
    }
    $result = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($result)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    if ($src) { $g.DrawImage($src, 0, 0, $width, $height); $src.Dispose() }
    else      { $g.Clear([System.Drawing.Color]::FromArgb(5, 0, 0)) }
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(185, 0, 0, 0))
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
$bBarY = [int]($sh - 6)
$bBar.Location  = New-Object System.Drawing.Point(0, $bBarY)
$form.Controls.Add($bBar)

$titleFontSz = [Math]::Max(20, [int]($sh / 35))
$titleLbl = New-Object System.Windows.Forms.Label
$titleLbl.Text      = "MERCILESS AUTHORITY"
$titleLbl.ForeColor = [System.Drawing.Color]::FromArgb(255, 60, 60)
$titleLbl.BackColor = [System.Drawing.Color]::Transparent
$titleLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $titleFontSz, [System.Drawing.FontStyle]::Bold)
$titleLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$titleLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.8), [int]($sh * 0.12))
$titleLbl.Location  = New-Object System.Drawing.Point([int](($sw - $titleLbl.Width) / 2), [int]($sh * 0.28))
$form.Controls.Add($titleLbl)

$subFontSz = [Math]::Max(10, [int]($sh / 72))
$subLbl = New-Object System.Windows.Forms.Label
$subLbl.Text      = "RECOMPILE SEQUENCE INITIATED"
$subLbl.ForeColor = [System.Drawing.Color]::FromArgb(160, 160, 160)
$subLbl.BackColor = [System.Drawing.Color]::Transparent
$subLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $subFontSz, [System.Drawing.FontStyle]::Regular)
$subLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$subLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.8), [int]($sh * 0.06))
$subLbl.Location  = New-Object System.Drawing.Point([int](($sw - $subLbl.Width) / 2), [int]($sh * 0.40))
$form.Controls.Add($subLbl)

$stepFontSz = [Math]::Max(9, [int]($sh / 75))
$stepLbl = New-Object System.Windows.Forms.Label
$stepLbl.Text      = "Initializing..."
$stepLbl.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
$stepLbl.BackColor = [System.Drawing.Color]::Transparent
$stepLbl.Font      = New-Object System.Drawing.Font("Segoe UI", $stepFontSz, [System.Drawing.FontStyle]::Regular)
$stepLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$stepLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.7), [int]($sh * 0.06))
$stepLbl.Location  = New-Object System.Drawing.Point([int](($sw - $stepLbl.Width) / 2), [int]($sh * 0.535))
$form.Controls.Add($stepLbl)

$barW = [int]($sw * 0.50)
$barH = [int]([Math]::Max(6, $sh * 0.009))
$barX = [int](($sw - $barW) / 2)
$barY = [int]($sh * 0.615)

$barTrack = New-Object System.Windows.Forms.Panel
$barTrack.BackColor = [System.Drawing.Color]::FromArgb(40, 20, 20)
$barTrack.Size      = New-Object System.Drawing.Size($barW, $barH)
$barTrack.Location  = New-Object System.Drawing.Point($barX, $barY)
$form.Controls.Add($barTrack)

$barFill = New-Object System.Windows.Forms.Panel
$barFill.BackColor = [System.Drawing.Color]::FromArgb(220, 0, 0)
$barFill.Size      = New-Object System.Drawing.Size(0, $barH)
$barFill.Location  = New-Object System.Drawing.Point(0, 0)
$barTrack.Controls.Add($barFill)

$pctLbl = New-Object System.Windows.Forms.Label
$pctLbl.Text      = "0%"
$pctLbl.ForeColor = [System.Drawing.Color]::FromArgb(90, 90, 90)
$pctLbl.BackColor = [System.Drawing.Color]::Transparent
$pctLbl.Font      = New-Object System.Drawing.Font("Segoe UI", [Math]::Max(8, [int]($sh/90)))
$pctLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$pctLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.4), 26)
$pctLbl.Location  = New-Object System.Drawing.Point([int](($sw - $pctLbl.Width) / 2), [int]($sh * 0.648))
$form.Controls.Add($pctLbl)

$verLbl = New-Object System.Windows.Forms.Label
$verLbl.Text      = "v2.21 — Rabbi S. Arlan"
$verLbl.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$verLbl.BackColor = [System.Drawing.Color]::Transparent
$verLbl.Font      = New-Object System.Drawing.Font("Segoe UI", [Math]::Max(8, [int]($sh/90)))
$verLbl.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$verLbl.Size      = New-Object System.Drawing.Size([int]($sw * 0.4), 26)
$verLbl.Location  = New-Object System.Drawing.Point([int](($sw - $verLbl.Width) / 2), [int]($sh * 0.70))
$form.Controls.Add($verLbl)

$script:phase      = 0
$script:opacity    = 0.0
$script:barCurrent = 0.0
$script:barTarget  = 0
$script:holdWait   = 0

# ── WORKER — NO Add-Type inside here.
# RcState defined in outer session. Runspace shares same AppDomain — type is directly accessible.
$workerScript = [scriptblock]::Create(@'
    param($scriptPath, $outputPath, $iconPath)
    function Q {
        param($text, $color = "white", $pct = -1)
        [RcState]::Queue.Enqueue([string[]]@($text, $color))
        if ($pct -ge 0) { [RcState]::Pct = $pct }
    }
    try {
        Q "Terminating running instance..." "white" 8
        Stop-Process -Name "MercilessAuthority" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 700
        Q "Instance cleared." "green" 18
        Q "Checking ps2exe..." "white" 22
        if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
            Q "Installing ps2exe..." "yellow"
            Install-Module -Name ps2exe -Scope CurrentUser -Force
            if (-not (Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue)) {
                Q "FAILED: ps2exe install failed." "red" 100
                [RcState]::Success = $false; [RcState]::Done = $true; return
            }
        }
        Q "ps2exe ready." "green" 30
        Q "Verifying source files..." "white" 34
        if (-not (Test-Path $scriptPath)) {
            Q "FAILED: BatteryMercy.ps1 not found." "red" 100
            [RcState]::Success = $false; [RcState]::Done = $true; return
        }
        $useIcon = $iconPath
        if (-not (Test-Path $iconPath)) { Q "Icon not found — compiling without icon." "yellow"; $useIcon = $null }
        else { Q "All source files verified." "green" 42 }
        Q "Compiling... this takes a moment." "white" 45
        $params = @{
            inputFile   = $scriptPath
            outputFile  = $outputPath
            title       = "MERCILESS AUTHORITY"
            description = "Totalitarian Battery Monitor — No Mercy, No Remorse"
            product     = "BatteryMercy System"
            company     = "Rabbi S. Arlan"
            copyright   = "2026 Rabbi S. Arlan. All rights reserved."
            version     = "2.21.0.0"
            noConsole   = $true
            noOutput    = $true
            noError     = $true
        }
        if ($useIcon) { $params.iconFile = $useIcon }
        try {
            Invoke-ps2exe @params
            Q "Compile done." "green" 78
        } catch {
            Q "COMPILE ERROR: $_" "red" 100
            [RcState]::Success = $false; [RcState]::Done = $true; return
        }
        Q "Verifying output..." "white" 82
        if (-not (Test-Path $outputPath)) {
            Q "FAILED: .exe was not created." "red" 100
            [RcState]::Success = $false; [RcState]::Done = $true; return
        }
        $kb = [math]::Round((Get-Item $outputPath).Length / 1KB)
        Q "Fresh .exe confirmed — ${kb}KB." "green" 90
        Q "Starting MERCILESS AUTHORITY..." "white" 94
        Start-Process $outputPath
        Start-Sleep -Milliseconds 800
        Q "MERCILESS AUTHORITY IS WATCHING." "green" 100
        [RcState]::Success = $true
    } catch {
        Q "UNHANDLED ERROR: $_" "red" 100
        [RcState]::Success = $false
    } finally {
        [RcState]::Done = $true
    }
'@)

$pollTimer = New-Object System.Windows.Forms.Timer
$pollTimer.Interval = 16

$pollTimer.Add_Tick({
    if ($script:phase -eq 0) {
        $script:opacity += 0.045
        if ($script:opacity -ge 1.0) { $script:opacity = 1.0; $script:phase = 1 }
        $form.Opacity = $script:opacity
        return
    }
    if ($script:phase -eq 1) {
        $msg = $null
        while ([RcState]::Queue.TryDequeue([ref]$msg)) {
            $stepLbl.Text = $msg[0]
            $stepLbl.ForeColor = switch ($msg[1]) {
                "green"  { [System.Drawing.Color]::FromArgb(80, 220, 80) }
                "yellow" { [System.Drawing.Color]::FromArgb(255, 200, 60) }
                "red"    { [System.Drawing.Color]::FromArgb(255, 70, 70) }
                default  { [System.Drawing.Color]::FromArgb(200, 200, 200) }
            }
        }
        $script:barTarget = [int](($barW * [RcState]::Pct) / 100)
        $delta = $script:barTarget - $script:barCurrent
        if ([Math]::Abs($delta) -lt 0.5) { $script:barCurrent = $script:barTarget }
        else { $script:barCurrent += $delta * 0.12 }
        $newW = [Math]::Max(0, [Math]::Min($barW, [int]$script:barCurrent))
        $barFill.Width = $newW
        $pctLbl.Text   = "$([RcState]::Pct)%"
        if ([RcState]::Done -and [Math]::Abs($script:barCurrent - $script:barTarget) -lt 1) {
            if ([RcState]::Success) {
                $barFill.BackColor = [System.Drawing.Color]::FromArgb(60, 200, 60)
                $subLbl.Text      = "RECOMPILE COMPLETE. GOD IS GOOD! :D"
                $subLbl.ForeColor = [System.Drawing.Color]::FromArgb(80, 220, 80)
            } else {
                $subLbl.Text      = "RECOMPILE FAILED — see BatteryMercy_error.log"
                $subLbl.ForeColor = [System.Drawing.Color]::FromArgb(255, 70, 70)
            }
            $pctLbl.Text      = "Click anywhere, press ESC to close or wait for this screen to fade..."
            $pctLbl.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 120)
            $script:phase = 2
        }
        return
    }
    if ($script:phase -eq 2) {
        $script:holdWait++
        if ($script:holdWait -ge 312) { $script:phase = 3 }
        return
    }
    if ($script:phase -eq 3) {
        $script:opacity -= 0.055
        if ($script:opacity -le 0.0) {
            $script:opacity = 0.0
            $pollTimer.Stop()
            $form.Close()
        }
        $form.Opacity = $script:opacity
    }
})

$form.Add_Click({ $script:phase = 3 })
$form.KeyPreview = $true
$form.Add_KeyDown({
    param($s, $e)
    if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Escape) { $script:phase = 3 }
})

$form.Add_Shown({
    [RcSplashAPI]::SetWindowPos($form.Handle, [RcSplashAPI]::HWND_TOPMOST, 0, 0, 0, 0, 0x0003) | Out-Null
    $pollTimer.Start()
    $rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
    $rs.Open()
    $ps = [System.Management.Automation.PowerShell]::Create()
    $ps.Runspace = $rs
    $ps.AddScript($workerScript) | Out-Null
    $ps.AddArgument($scriptPath) | Out-Null
    $ps.AddArgument($outputPath) | Out-Null
    $ps.AddArgument($iconPath)   | Out-Null
    $ps.BeginInvoke() | Out-Null
})

$form.ShowDialog() | Out-Null
try { $pollTimer.Stop(); $pollTimer.Dispose() } catch {}
$wallBmp.Dispose()
$form.Dispose()
