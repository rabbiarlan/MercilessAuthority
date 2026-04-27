# BatteryMercy_TestRun.ps1
# ─────────────────────────────────────────────────────────────────────
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8246 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ─────────────────────────────────────────────────────────────────────
# STANDALONE TEST v2.21 — simulates ALL three alert scenarios WITHOUT needing real battery %
# Run this AFTER killing MercilessAuthority.exe to test popup + beep directly
# Usage (run in PowerShell 7 as Admin, NOT inside VSCode terminal):
#   Test LOW    popup: pwsh -ExecutionPolicy Bypass -STA -File "$PSScriptRoot\BatteryMercy_TestRun.ps1" -Scenario low
#   Test HIGH   popup: pwsh -ExecutionPolicy Bypass -STA -File "$PSScriptRoot\BatteryMercy_TestRun.ps1" -Scenario high
#   Test DEAD   popup: pwsh -ExecutionPolicy Bypass -STA -File "$PSScriptRoot\BatteryMercy_TestRun.ps1" -Scenario dead
#
# NOTE: DEAD scenario will NOT call Stop-Computer in TestRun — safe to test.
# The countdown will reach zero and the form just closes. No shutdown happens.

param(
    [ValidateSet("low","high","dead")]
    [string]$Scenario = "low"
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public class LockAPI2 {
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool BringWindowToTop(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);
    [DllImport("user32.dll")] public static extern bool UnregisterHotKey(IntPtr hWnd, int id);
    [DllImport("user32.dll")] public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
    public static bool IsTaskManagerForeground() {
        IntPtr hwnd = GetForegroundWindow();
        uint pid = 0;
        GetWindowThreadProcessId(hwnd, out pid);
        try { return Process.GetProcessById((int)pid).ProcessName.ToLower() == "taskmgr"; }
        catch { return false; }
    }
    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);
    [DllImport("user32.dll")] private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);
    [DllImport("user32.dll")] private static extern bool UnhookWindowsHookEx(IntPtr hhk);
    [DllImport("user32.dll")] private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);
    private static IntPtr _hookId = IntPtr.Zero;
    private static LowLevelKeyboardProc _proc;
    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        if (nCode >= 0) {
            int vk = System.Runtime.InteropServices.Marshal.ReadInt32(lParam);
            if (vk == 0x5B || vk == 0x5C) return new IntPtr(1);
        }
        return CallNextHookEx(_hookId, nCode, wParam, lParam);
    }
    public static void InstallWinHook() {
        _proc = HookCallback;
        _hookId = SetWindowsHookEx(13, _proc, IntPtr.Zero, 0);
    }
    public static void UninstallWinHook() {
        if (_hookId != IntPtr.Zero) { UnhookWindowsHookEx(_hookId); _hookId = IntPtr.Zero; }
    }
    public static void StartBeepLow() {
        var t = new System.Threading.Thread(() => {
            try {
                Console.Beep(784, 200); System.Threading.Thread.Sleep(50);
                Console.Beep(698, 200); System.Threading.Thread.Sleep(50);
                Console.Beep(622, 250); System.Threading.Thread.Sleep(50);
                Console.Beep(523, 300); System.Threading.Thread.Sleep(50);
                Console.Beep(440, 850);
            } catch {}
        });
        t.IsBackground = true; t.Start();
    }
    public static void StartBeepHigh() {
        var t = new System.Threading.Thread(() => {
            try {
                Console.Beep(523, 90); System.Threading.Thread.Sleep(20);
                Console.Beep(659, 90); System.Threading.Thread.Sleep(20);
                Console.Beep(784, 90); System.Threading.Thread.Sleep(20);
                Console.Beep(1047, 90); System.Threading.Thread.Sleep(20);
                Console.Beep(1319, 420);
            } catch {}
        });
        t.IsBackground = true; t.Start();
    }
    public static void StartBeepDead() {
        var t = new System.Threading.Thread(() => {
            try {
                Console.Beep(400, 380); System.Threading.Thread.Sleep(90);
                Console.Beep(350, 430); System.Threading.Thread.Sleep(90);
                Console.Beep(300, 480); System.Threading.Thread.Sleep(90);
                Console.Beep(250, 550); System.Threading.Thread.Sleep(90);
                Console.Beep(200, 1300);
            } catch {}
        });
        t.IsBackground = true; t.Start();
    }
}
"@

$mode = $Scenario.ToUpper()

if ($mode -eq "LOW") {
    $msg       = "CRITICAL DEPLETION: 35%. FEED THE MACHINE WITH FAITH, SPIRITUAL POWER, STRENGTH, GROWTH, WISDOM AND DISCIPLINE. NOT EGO, LUST, PSYCHOPATHY, MACHIAVELLIANISM MANIPULATION AND IRRESPONSIBILITY."
    $percentStr = "35%"
} elseif ($mode -eq "HIGH") {
    $msg       = "VOLTAGE OVERLOAD: 85%. RELEASE THE POWER FEEDER RIGHT NOW TO SAVE BATTERY LIFE OR ELSE IRREVERSIBLE BATTERY DEGRADATION SUCH AS WEAR AND TEAR HAPPENS LIKE YOU IN LIFE SOON..."
    $percentStr = "85%"
} else {
    $msg       = "DEADMAN's SWITCH ACTIVATED: TERMINATION IMMINENT. PLUG IN RIGHT NOW OR ELSE NO SECOND CHANCE, NO SECOND OPTION AND NO SAVED PROGRESS. THE MACHINE DIES WHEN COMPROMISED, LIKE YOU IN LIFE SOON..."

    $percentStr = "Countdown: 60"
}

[LockAPI2]::SetProcessDPIAware() | Out-Null

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$sw = [int]$screen.Width
$sh = [int]$screen.Height

function Get-DarkenedWallpaper {
    param([int]$width, [int]$height)
    $slideshowFolder = Join-Path $env:USERPROFILE "OneDrive\Desktop\Important Slideshow Wallpapers"
    $wallpaperPaths  = @()
    $wallpaperPaths += "$env:APPDATA\Microsoft\Windows\Themes\TranscodedWallpaper"
    if (Test-Path $slideshowFolder) {
        $imgs = Get-ChildItem $slideshowFolder -Include *.jpg,*.jpeg,*.png,*.bmp,*.webp -Recurse -ErrorAction SilentlyContinue
        if ($imgs -and $imgs.Count -gt 0) { $wallpaperPaths += ($imgs | Get-Random).FullName }
    }
    $regWall = (Get-ItemProperty "HKCU:\Control Panel\Desktop" -ErrorAction SilentlyContinue).Wallpaper
    if ($regWall) { $wallpaperPaths += $regWall }
    $srcBitmap = $null
    foreach ($path in $wallpaperPaths) {
        if ($path -and (Test-Path $path)) {
            try {
                $bytes = [System.IO.File]::ReadAllBytes($path)
                $ms    = New-Object System.IO.MemoryStream($bytes, 0, $bytes.Length)
                $srcBitmap = [System.Drawing.Bitmap]::FromStream($ms)
                break
            } catch {}
        }
    }
    $result = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($result)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    if ($srcBitmap) { $g.DrawImage($srcBitmap, 0, 0, $width, $height); $srcBitmap.Dispose() }
    else             { $g.Clear([System.Drawing.Color]::FromArgb(10, 0, 0)) }
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 0, 0, 0))
    $g.FillRectangle($brush, 0, 0, $width, $height)
    $brush.Dispose(); $g.Dispose()
    return $result
}

$wallpaperBitmap = Get-DarkenedWallpaper -width $sw -height $sh

$form = New-Object System.Windows.Forms.Form
$form.AutoScaleMode         = [System.Windows.Forms.AutoScaleMode]::None
$form.FormBorderStyle       = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition         = [System.Windows.Forms.FormStartPosition]::Manual
$form.Bounds                = $screen
$form.TopMost               = $true
$form.ShowInTaskbar         = $false
$form.KeyPreview            = $true
$form.BackgroundImage       = $wallpaperBitmap
$form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch
$form.BackColor             = [System.Drawing.Color]::FromArgb(10, 0, 0)

$iconPath = Join-Path $PSScriptRoot "holycleanAPP.ico"
if (Test-Path $iconPath) {
    try { $s = [System.IO.File]::OpenRead($iconPath); $form.Icon = New-Object System.Drawing.Icon($s); $s.Close() } catch {}
}

$form.Add_Shown({
    $h = $form.Handle
    [LockAPI2]::RegisterHotKey($h,  1, 0x0001, 0x09) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  2, 0x0001, 0x73) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  3, 0x0008, 0x44) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  4, 0x0008, 0x09) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  5, 0x0008, 0x4D) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  6, 0x0008, 0x45) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  7, 0x0008, 0x52) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  8, 0x0001, 0x1B) | Out-Null
    [LockAPI2]::RegisterHotKey($h,  9, 0x0008, 0x4C) | Out-Null
    [LockAPI2]::RegisterHotKey($h, 10, 0x0008, 0x58) | Out-Null
    [LockAPI2]::RegisterHotKey($h, 11, 0x0002, 0x1B) | Out-Null
    [LockAPI2]::InstallWinHook()
    if ($mode -eq "HIGH") { [LockAPI2]::StartBeepHigh() }
    elseif ($mode -eq "DEAD") { [LockAPI2]::StartBeepDead() }
    else { [LockAPI2]::StartBeepLow() }
    $form.Activate()
    $form.BeginInvoke([System.Action]{
        if ($btn -ne $null) { $btn.Focus() }
        if ($mode -eq "DEAD" -and $script:cdPanel -ne $null) { $script:cdPanel.Invalidate() }
    }) | Out-Null
})

$form.Add_KeyDown({
    param($s, $e)
    $ok = @([System.Windows.Forms.Keys]::Return, [System.Windows.Forms.Keys]::Space)
    if ($ok -notcontains $e.KeyCode) { $e.Handled = $true; $e.SuppressKeyPress = $true }
})

$form.Add_FormClosing({
    param($s, $e)
    $safe = @(
        [System.Windows.Forms.CloseReason]::TaskManagerClosing,
        [System.Windows.Forms.CloseReason]::ApplicationExitCall,
        [System.Windows.Forms.CloseReason]::WindowsShutDown
    )
    if ($form.DialogResult -ne [System.Windows.Forms.DialogResult]::OK -and
        $form.DialogResult -ne [System.Windows.Forms.DialogResult]::No -and
        $safe -notcontains $e.CloseReason) {
        $e.Cancel = $true
    }
})

$tBar = New-Object System.Windows.Forms.Panel
$tBar.BackColor = [System.Drawing.Color]::FromArgb(220,0,0)
$tBar.Size      = New-Object System.Drawing.Size([int]$sw, 14)
$tBar.Location  = New-Object System.Drawing.Point(0, 0)
$form.Controls.Add($tBar)

$bBar = New-Object System.Windows.Forms.Panel
$bBar.BackColor = [System.Drawing.Color]::FromArgb(220,0,0)
$bBar.Size      = New-Object System.Drawing.Size([int]$sw, 14)
$bBarY = [int]($sh - 14)
$bBar.Location  = New-Object System.Drawing.Point(0, $bBarY)
$form.Controls.Add($bBar)

$tbl = New-Object System.Windows.Forms.TableLayoutPanel
$tbl.Dock        = [System.Windows.Forms.DockStyle]::Fill
$tbl.BackColor   = [System.Drawing.Color]::Transparent
$tbl.ColumnCount = 3
$tbl.RowCount    = 8
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 20))) | Out-Null
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 60))) | Out-Null
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 20))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent,  6))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent,  2))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 13))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 16))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 22))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 21))) | Out-Null
$form.Controls.Add($tbl)

$iconSz = [Math]::Max(56, [int]($sh * 0.082))
$pic = New-Object System.Windows.Forms.PictureBox
$pic.Size      = New-Object System.Drawing.Size($iconSz, $iconSz)
$pic.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$pic.BackColor = [System.Drawing.Color]::Transparent
$pic.Anchor    = [System.Windows.Forms.AnchorStyles]::None

if ($mode -eq "HIGH") {
    $ckBmp = New-Object System.Drawing.Bitmap($iconSz, $iconSz)
    $ckG   = [System.Drawing.Graphics]::FromImage($ckBmp)
    $ckG.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $ckG.Clear([System.Drawing.Color]::Transparent)
    $ckPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 210, 60), [float]([int]($iconSz / 7)))
    $ckPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $ckPen.EndCap   = [System.Drawing.Drawing2D.LineCap]::Round
    $ckPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $pts = [System.Drawing.PointF[]]@(
        (New-Object System.Drawing.PointF([float]($iconSz * 0.18), [float]($iconSz * 0.52))),
        (New-Object System.Drawing.PointF([float]($iconSz * 0.42), [float]($iconSz * 0.78))),
        (New-Object System.Drawing.PointF([float]($iconSz * 0.82), [float]($iconSz * 0.22)))
    )
    $ckG.DrawLines($ckPen, $pts)
    $ckPen.Dispose(); $ckG.Dispose()
    $pic.Image = $ckBmp
} elseif ($mode -eq "DEAD") {
    $pic.Image = [System.Drawing.SystemIcons]::Error.ToBitmap()
} else {
    $pic.Image = [System.Drawing.SystemIcons]::Warning.ToBitmap()
}
$picShadow = New-Object System.Windows.Forms.Panel
$picShadow.Size        = New-Object System.Drawing.Size($iconSz, $iconSz)
$picShadow.BackColor   = [System.Drawing.Color]::FromArgb(90, 0, 0, 0)
$picShadow.Location    = New-Object System.Drawing.Point(5, 5)
$picShadow.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$picShadow.Anchor      = [System.Windows.Forms.AnchorStyles]::None
$picShadow.Enabled     = $false

$pic.Location = New-Object System.Drawing.Point(0, 0)

$picContainer = New-Object System.Windows.Forms.Panel
$picContainer.Size      = New-Object System.Drawing.Size(($iconSz + 10), ($iconSz + 10))
$picContainer.BackColor = [System.Drawing.Color]::Transparent
$picContainer.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$picContainer.Margin    = New-Object System.Windows.Forms.Padding(0, 14, 0, 0)
$picContainer.Controls.Add($picShadow)
$picContainer.Controls.Add($pic)
$pic.BringToFront()
$tbl.Controls.Add($picContainer, 1, 1)

$tFontSz = [Math]::Max(16, [int]($sh / 46))
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text      = "!!! NO MERCY AND NO REMORSE ON LAPTOP BATTERY, INITIATE SYSTEM PROTOCOL CRITICAL OVERRIDE !!!"
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 70, 70)
$titleLabel.BackColor = [System.Drawing.Color]::Transparent
$titleLabel.Font      = New-Object System.Drawing.Font("Segoe UI", $tFontSz, [System.Drawing.FontStyle]::Bold)
$titleLabel.Dock      = [System.Windows.Forms.DockStyle]::Fill
$titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$titleLabel.ForeColor = [System.Drawing.Color]::Transparent
$titleLabel.UseCompatibleTextRendering = $true
$titleLabel.Add_Paint({
    param($s2, $e2)
    $g2 = $e2.Graphics
    $g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    try {
        $ptF2 = $s2.PointToScreen([System.Drawing.Point]::Empty)
        $ptC2 = $form.PointToClient($ptF2)
        $srcR2 = New-Object System.Drawing.Rectangle([Math]::Max(0,$ptC2.X), [Math]::Max(0,$ptC2.Y), $s2.Width, $s2.Height)
        $dstR2 = New-Object System.Drawing.Rectangle(0, 0, $s2.Width, $s2.Height)
        $g2.DrawImage($wallpaperBitmap, $dstR2, $srcR2, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {}
    $sf2 = New-Object System.Drawing.StringFormat
    $sf2.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf2.LineAlignment = [System.Drawing.StringAlignment]::Center
    $shBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 0, 0, 0))
    foreach ($sdOff in @(5, 4, 3)) {
        $g2.DrawString($s2.Text, $s2.Font, $shBrush, (New-Object System.Drawing.RectangleF($sdOff, $sdOff, $s2.Width, $s2.Height)), $sf2)
    }
    $shBrush.Dispose()
    $mainBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 70, 70))
    $g2.DrawString($s2.Text, $s2.Font, $mainBrush2, (New-Object System.Drawing.RectangleF(0, 0, $s2.Width, $s2.Height)), $sf2)
    $mainBrush2.Dispose(); $sf2.Dispose()
})
$tbl.Controls.Add($titleLabel, 1, 2)

$div = New-Object System.Windows.Forms.Panel
$div.BackColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
$div.Height    = 3
$div.Dock      = [System.Windows.Forms.DockStyle]::None
$div.Anchor    = [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$tbl.Controls.Add($div, 1, 3)

$pFontSz = [Math]::Max(28, [int]($sh / 28))
$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.Text      = $percentStr
$percentLabel.BackColor = [System.Drawing.Color]::Black
$percentLabel.Font      = New-Object System.Drawing.Font("Segoe UI", $pFontSz, [System.Drawing.FontStyle]::Bold)
$percentLabel.Dock      = [System.Windows.Forms.DockStyle]::Fill
$percentLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$percentLabel.UseCompatibleTextRendering = $true
$percentLabel.Add_Paint({
    param($sender, $e)
    if ([string]::IsNullOrEmpty($sender.Text)) { return }
    $g  = $e.Graphics
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    try {
        $ptFp = $sender.PointToScreen([System.Drawing.Point]::Empty)
        $ptCp = $form.PointToClient($ptFp)
        $srcRp = New-Object System.Drawing.Rectangle([Math]::Max(0,$ptCp.X), [Math]::Max(0,$ptCp.Y), $sender.Width, $sender.Height)
        $dstRp = New-Object System.Drawing.Rectangle(0, 0, $sender.Width, $sender.Height)
        $g.DrawImage($wallpaperBitmap, $dstRp, $srcRp, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {}
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $sender.Width, $sender.Height)
    foreach ($gd in @(@(5,18,40,0,0),@(4,30,100,0,0),@(3,55,170,5,5),@(2,90,220,15,15),@(1,130,255,30,30))) {
        $off = $gd[0]; $alpha = $gd[1]; $cr = $gd[2]; $cg2 = $gd[3]; $cb = $gd[4]
        $gb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, $cr, $cg2, $cb))
        for ($dx=-$off; $dx -le $off; $dx++) {
            for ($dy=-$off; $dy -le $off; $dy++) {
                $g.DrawString($sender.Text, $sender.Font, $gb, (New-Object System.Drawing.RectangleF($dx, $dy, $sender.Width, $sender.Height)), $sf)
            }
        }
        $gb.Dispose()
    }
    $mb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 70, 70))
    $g.DrawString($sender.Text, $sender.Font, $mb, $rect, $sf)
    $mb.Dispose(); $sf.Dispose()
})

if ($mode -eq "DEAD") { $percentLabel.Visible = $false }
$tbl.Controls.Add($percentLabel, 1, 4)

$cdTimer = $null
if ($mode -eq "DEAD") {
    $script:cdNum       = 60
    $script:cdBgCached  = $false
    $script:cdBgSlice   = $null
    $cdFont = New-Object System.Drawing.Font("Segoe UI", [Math]::Max(20, [int]($sh / 40)), [System.Drawing.FontStyle]::Bold)

    $script:cdPanel = New-Object System.Windows.Forms.Panel
    $script:cdPanel.Dock      = [System.Windows.Forms.DockStyle]::Fill
    $script:cdPanel.BackColor = [System.Drawing.Color]::Black

    $setStyle = $script:cdPanel.GetType().GetMethod(
        "SetStyle",
        [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Instance)
    $styleFlags = [int][System.Windows.Forms.ControlStyles]::AllPaintingInWmPaint -bor
                  [int][System.Windows.Forms.ControlStyles]::OptimizedDoubleBuffer -bor
                  [int][System.Windows.Forms.ControlStyles]::UserPaint
    $setStyle.Invoke($script:cdPanel, @([System.Windows.Forms.ControlStyles]$styleFlags, $true))

    $script:cdPanel.Add_Paint({
        param($sender, $e)
        $g = $e.Graphics
        $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
        if (-not $script:cdBgCached) {
            try {
                $ptF = $sender.PointToScreen([System.Drawing.Point]::Empty)
                $ptC = $form.PointToClient($ptF)
                $srcR = New-Object System.Drawing.Rectangle([Math]::Max(0,$ptC.X), [Math]::Max(0,$ptC.Y), $sender.Width, $sender.Height)
                $script:cdBgSlice = New-Object System.Drawing.Bitmap($sender.Width, $sender.Height)
                $bgG = [System.Drawing.Graphics]::FromImage($script:cdBgSlice)
                $bgG.DrawImage($wallpaperBitmap, (New-Object System.Drawing.Rectangle(0,0,$sender.Width,$sender.Height)), $srcR, [System.Drawing.GraphicsUnit]::Pixel)
                $bgG.Dispose()
                $script:cdBgCached = $true
            } catch {}
        }
        if ($script:cdBgSlice) { $g.DrawImage($script:cdBgSlice, 0, 0) }
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment     = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = New-Object System.Drawing.RectangleF(0, 0, $sender.Width, $sender.Height)
        $txt = "Countdown: $script:cdNum"
        foreach ($gd in @(@(5,18,40,0,0),@(4,30,100,0,0),@(3,55,170,5,5),@(2,90,220,15,15),@(1,130,255,30,30))) {
            $off=$gd[0]; $al=$gd[1]; $cr=$gd[2]; $cg=$gd[3]; $cb=$gd[4]
            $gb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($al,$cr,$cg,$cb))
            for ($dx=-$off; $dx -le $off; $dx++) {
                for ($dy=-$off; $dy -le $off; $dy++) {
                    $g.DrawString($txt, $cdFont, $gb, (New-Object System.Drawing.RectangleF($dx,$dy,$sender.Width,$sender.Height)), $sf)
                }
            }
            $gb.Dispose()
        }
        $mb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,70,70))
        $g.DrawString($txt, $cdFont, $mb, $rect, $sf)
        $mb.Dispose(); $sf.Dispose()
    })
    $tbl.Controls.Add($script:cdPanel, 1, 4)

    $deadEndTime = [DateTime]::Now.AddSeconds(60)
    $cdTimer = New-Object System.Windows.Forms.Timer
    $cdTimer.Interval = 1000
    $cdTimer.Add_Tick({
        $rem = [int][Math]::Ceiling(($deadEndTime - [DateTime]::Now).TotalSeconds)
        if ($rem -le 0) {
            $cdTimer.Stop()
            $form.DialogResult = [System.Windows.Forms.DialogResult]::No
            $form.Close()
        } else {
            if ($script:cdNum -ne $rem) {
                $script:cdNum = $rem
                $script:cdPanel.Invalidate()
            }
        }
    })
    $cdTimer.Start()
}

$mFontSz = [Math]::Max(11, [int]($sh / 60))
$label = New-Object System.Windows.Forms.Label
$label.Text      = $msg
$label.ForeColor = [System.Drawing.Color]::White
$label.BackColor = [System.Drawing.Color]::Transparent
$label.Font      = New-Object System.Drawing.Font("Segoe UI", $mFontSz, [System.Drawing.FontStyle]::Bold)
$label.Dock      = [System.Windows.Forms.DockStyle]::Fill
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$label.ForeColor = [System.Drawing.Color]::Transparent
$label.UseCompatibleTextRendering = $true
$label.Add_Paint({
    param($s3, $e3)
    $g3 = $e3.Graphics
    $g3.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    try {
        $ptF3 = $s3.PointToScreen([System.Drawing.Point]::Empty)
        $ptC3 = $form.PointToClient($ptF3)
        $srcR3 = New-Object System.Drawing.Rectangle([Math]::Max(0,$ptC3.X), [Math]::Max(0,$ptC3.Y), $s3.Width, $s3.Height)
        $dstR3 = New-Object System.Drawing.Rectangle(0, 0, $s3.Width, $s3.Height)
        $g3.DrawImage($wallpaperBitmap, $dstR3, $srcR3, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {}
    $sf3 = New-Object System.Drawing.StringFormat
    $sf3.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf3.LineAlignment = [System.Drawing.StringAlignment]::Center
    $shBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(210, 0, 0, 0))
    foreach ($sdOff3 in @(5, 4, 3)) {
        $g3.DrawString($s3.Text, $s3.Font, $shBrush3, (New-Object System.Drawing.RectangleF($sdOff3, $sdOff3, $s3.Width, $s3.Height)), $sf3)
    }
    $shBrush3.Dispose()
    $mainBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g3.DrawString($s3.Text, $s3.Font, $mainBrush3, (New-Object System.Drawing.RectangleF(0, 0, $s3.Width, $s3.Height)), $sf3)
    $mainBrush3.Dispose(); $sf3.Dispose()
})
$tbl.Controls.Add($label, 1, 5)

$bFontSz = [Math]::Max(11, [int]($sh / 68))
$btnH    = [Math]::Max(62, [int]($sh * 0.092))
$btnW    = [Math]::Max(280, [int]($sw * 0.28))

$btn = New-Object System.Windows.Forms.Button
$btn.Text      = "  YES pwease, Master~!  "
$btn.Size      = New-Object System.Drawing.Size($btnW, $btnH)
$btn.Font      = New-Object System.Drawing.Font("Segoe UI", $bFontSz, [System.Drawing.FontStyle]::Bold)
$btn.BackColor = [System.Drawing.Color]::FromArgb(210, 20, 20)
$btn.ForeColor = [System.Drawing.Color]::White
$btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 130, 130)
$btn.FlatAppearance.BorderSize  = 3
$btn.Anchor       = [System.Windows.Forms.AnchorStyles]::None
$btn.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btn.UseVisualStyleBackColor = $false
$btn.Add_Paint({
    param($s, $e)
    $g = $e.Graphics
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $glowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 255, 100, 100))
    for ($i = 4; $i -ge 1; $i--) {
        $rX = [int](-$i); $rY = [int](-$i)
        $rW = [int]($s.Width + $i * 2); $rH = [int]($s.Height + $i * 2)
        $rect = New-Object System.Drawing.Rectangle($rX, $rY, $rW, $rH)
        $g.FillRectangle($glowBrush, $rect)
    }
    $glowBrush.Dispose()
})
$btn.Cursor       = [System.Windows.Forms.Cursors]::Hand
$form.AcceptButton = $btn

$btnContainer = New-Object System.Windows.Forms.Panel
$btnContW = [int]($btnW + 12)
$btnContH = [int]($btnH + 40)
$btnContainer.Size = New-Object System.Drawing.Size($btnContW, $btnContH)
$btnContainer.BackColor = [System.Drawing.Color]::Transparent
$btnContainer.Anchor = [System.Windows.Forms.AnchorStyles]::None

$shadow = New-Object System.Windows.Forms.Panel
$shadow.Size = New-Object System.Drawing.Size($btnW, $btnH)
$shadow.Location = New-Object System.Drawing.Point(6, 6)
$shadow.BackColor = [System.Drawing.Color]::FromArgb(120, 0, 0, 0)
$shadow.BorderStyle = [System.Windows.Forms.BorderStyle]::None
$shadow.Anchor = [System.Windows.Forms.AnchorStyles]::None
$shadow.Enabled = $false

$btn.Left = [int](($btnContainer.Width - $btn.Width) / 2)
$btn.Top  = 14
$btnContainer.Controls.Add($btn)
$btnContainer.Controls.Add($shadow)
$btn.BringToFront()
$tbl.Controls.Add($btnContainer, 1, 6)

$script:hoverTarget  = 2
$script:normalTop    = 14
$script:currentTop   = 14.0
$script:targetTop    = 14.0
$script:currentScale = 1.0
$script:targetScale  = 1.0

$animTimer = New-Object System.Windows.Forms.Timer
$animTimer.Interval = 15
$animTimer.Add_Tick({
    $topDelta = $script:targetTop - $script:currentTop
    if ([math]::Abs($topDelta) -lt 0.5) { $script:currentTop = $script:targetTop }
    else { $script:currentTop = $script:currentTop + ($topDelta * 0.25) }

    $scaleDelta = $script:targetScale - $script:currentScale
    if ([math]::Abs($scaleDelta) -lt 0.003) { $script:currentScale = $script:targetScale }
    else {
        $scaleRate = if ($scaleDelta -lt 0) { 0.85 } else { 0.3 }
        $script:currentScale = $script:currentScale + ($scaleDelta * $scaleRate)
    }
    $newW = [int]($btnW * $script:currentScale)
    $newH = [int]($btnH * $script:currentScale)
    if ($btn.Width  -ne $newW) { $btn.Width  = $newW }
    if ($btn.Height -ne $newH) { $btn.Height = $newH }

    $btn.Top  = [int]$script:currentTop
    $btn.Left = [int](($btnContainer.Width - $btn.Width) / 2)
    $shadow.Top  = [int]($script:currentTop + 6)
    $shadow.Left = [int]($btn.Left + 6)
})
$animTimer.Start()

$btn.Add_MouseEnter({
    $script:targetTop = $script:hoverTarget
    $btn.BackColor = [System.Drawing.Color]::FromArgb(240, 50, 50)
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 180, 180)
})
$btn.Add_MouseLeave({
    $script:targetTop = $script:normalTop
    $btn.BackColor = [System.Drawing.Color]::FromArgb(210, 20, 20)
    $btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 130, 130)
})
$btn.Add_MouseDown({
    $script:targetScale = 0.92
    $btn.BackColor = [System.Drawing.Color]::FromArgb(255, 100, 100)
})
$btn.Add_MouseUp({
    $script:targetScale = 1.0
    $btn.BackColor = [System.Drawing.Color]::FromArgb(240, 50, 50)
})

$lockTimer = New-Object System.Windows.Forms.Timer
$lockTimer.Interval = 150
$lockTimer.Add_Tick({
    if ([LockAPI2]::IsTaskManagerForeground()) { return }
    [LockAPI2]::SetWindowPos($form.Handle, [LockAPI2]::HWND_TOPMOST, 0, 0, 0, 0, 0x0003) | Out-Null
    [LockAPI2]::SetForegroundWindow($form.Handle) | Out-Null
    [LockAPI2]::BringWindowToTop($form.Handle) | Out-Null
    $form.Activate()
    if (-not $btn.Focused) { $btn.Focus() }
})
$lockTimer.Start()

$form.ShowDialog() | Out-Null

try { for ($i=1; $i -le 11; $i++) { [LockAPI2]::UnregisterHotKey($form.Handle, $i) | Out-Null } } catch {}
[LockAPI2]::UninstallWinHook()
$lockTimer.Stop(); $lockTimer.Dispose()
try { if ($animTimer) { $animTimer.Stop(); $animTimer.Dispose() } } catch {}
try { if ($cdTimer)   { $cdTimer.Stop();   $cdTimer.Dispose()   } } catch {}
try { if ($script:cdBgSlice) { $script:cdBgSlice.Dispose() } } catch {}
$wallpaperBitmap.Dispose()
$form.Dispose()
