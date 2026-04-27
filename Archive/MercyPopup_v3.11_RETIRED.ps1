# MercyPopup.ps1 — "TOTALITARIAN LOCKDOWN" Popup Screen v3.11
# PERSISTENT INTIMIDATING DPRK REGIME PROPAGANDA MERCILESS AUTHORITARIAN DEADLY DISPLAY DIALOGUE
# ─────────────────────────────────────────────────────────────────
# Version 1.0 March 14, 2026     - Basic MessageBox popup born after BatteryMercy.ps1 Version 2.3
#                                                  March 14, 2026
# Version 2.0 March 14, 2026     - Custom WinForms dialog, YES Master~! button,
#                                                  Topmost timer, icon fix, FormClosing guard
# Version 3.0 March 14, 2026     - FULLSCREEN LOCKDOWN: blocks Alt+Tab, Win+D,
#                                                  Win+Tab and all escape routes. KeyDown suppressed.
#                                                  Only YES Master~! can dismiss. Safety escape:
#                                                  Ctrl+Alt+Del → Power Button → Reset (kernel-level).
# Version 3.1 March 15, 2026     - [FIX]: SetProcessDPIAware() so form fills screen at
#                                                  ANY Windows display scale factor (100/125/150%).
#                                                  [FIX]: TableLayoutPanel proportional layout — icon,
#                                                  title, message, button NEVER overlap or go off-screen.
#                                                  [FIX]: Button is bright visible white-on-red.
# Version 3.2 March 15, 2026     - [FIX]: FormClosing now allows CloseReason.TaskManagerClosing,
#                                                  ApplicationExitCall, WindowsShutDown. Previously ALL close
#                                                  signals were cancelled including Task Manager End Task.
# Version 3.3 March 15, 2026     - [FIX]: [int] cast on $sw/$sh (Object[] crash), remove
#                                                  invalid $tbl.AutoScaleMode (TableLayoutPanel has no such
#                                                  property), beep EndInvoke replaced with Stop/Dispose.
# Version 3.4 March 15, 2026     - [FIX]: pre-compute $bBarY=[int]($sh-14) before New-Object
#                                                  System.Drawing.Point call. Inline $sh-14 inside New-Object
#                                                  args gets re-evaluated as Object[] by PS7 type resolver.
# Version 3.5 March 15, 2026     - [FIX]: beep moved into Add_Shown event (fires exactly when
#                                                  form becomes visible, zero gap). Wallpaper background:
#                                                  reads TranscodedWallpaper cache, 50% black overlay.
# Version 3.6 March 15, 2026     - Wallpaper priority: TranscodedWallpaper (current slideshow
#                                                  frame) → random image from slideshow folder → registry key.
#                                                  Slideshow folder: Important Sildeshow Wallpapers on Desktop.
# Version 3.7 March 15, 2026     - [FIX]: wallpaper now uses Form.BackgroundImage (not PictureBox
#                                                  sibling — Transparent controls paint through PARENT not sibling).
#                                                  [FIX]: lockTimer checks GetForegroundWindow — backs off when
#                                                  Taskmgr.exe has focus so End Task actually works.
# Version 3.8 March 15, 2026     - [FIX]: beep now uses System.Threading.Thread with IsBackground=true.
#                                                  Background threads auto-killed on script exit — Console.Beep()
#                                                  blocking Win32 call can never be interrupted by PS Stop()/Dispose(),
#                                                  but background threads die instantly when main thread exits.
#                                                  [FEAT.]: battery % extracted via regex, rendered in separate Label
#                                                  with custom GDI+ Paint glow effect (red multi-layer blur simulation).
# Version 3.9 March 15, 2026     - [FIX]: LockAPI.PlayAlarm() moved into compiled Add-Type C# class.
#                                                  Attempted [ThreadStart][LockAPI]::PlayAlarm delegate cast in PS —
#                                                  MethodInfo not implicitly castable to delegate in PS7 runtime.
#                                                  Script crashed with PSInvalidOperationException: no Runspace.
# Version 3.10 March 15, 2026   - [FIX]: Thread creation fully moved into C# as LockAPI.StartBeep().
#                                                  PS just calls [LockAPI]::StartBeep() — one void method call.
#                                                  C# internally does new Thread(PlayAlarm) { IsBackground=true }.Start().
#                                                  Zero PS delegate casting, zero Runspace dependency, zero crash.
# Version 3.11 March 15, 2026   - [FIX]: Beep removed from MercyPopup entirely. Moved to BatteryMercy.ps1
#                                                  (MercilessAuthority.exe) which is already warm in memory.
#                                                  Beep fires INSTANTLY on threshold detection before pwsh.exe
#                                                  even spawns. True zero-delay alarm — user hears it the same
#                                                  instant the threshold is crossed, not 4s later after cold-start.
# ─────────────────────────────────────────────────────────────────

param([string]$msg)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type -TypeDefinition @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
public class LockAPI {
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
    // Beep melody — runs on background thread, no PS Runspace needed
    private static void PlayAlarm() {
        try {
            Console.Beep(880,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(660,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(880,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(660,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(1100, 600);
        } catch {}
    }
    // Called from PS — thread creation fully inside C#, zero delegate casting in PS
    public static void StartBeep() {
        System.Threading.Thread t = new System.Threading.Thread(PlayAlarm);
        t.IsBackground = true;
        t.Start();
    }
}
"@

[LockAPI]::SetProcessDPIAware() | Out-Null

# ── SCREEN SIZE (true physical pixels post-DPI-aware) ───────────
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$sw = [int]$screen.Width
$sh = [int]$screen.Height

# ── EXTRACT PERCENTAGE from message for glow label ─────────────
# Matches "34%" or "85%" anywhere in the message string.
# If found → shown in large glowing red label separately.
# If not found (e.g. TERMINATION IMMINENT) → percentStr is empty.
$percentStr = ""
if ($msg -match '(\d+%)') { $percentStr = $matches[1] }

# ── WALLPAPER BACKGROUND ────────────────────────────────────────
function Get-DarkenedWallpaper {
    param([int]$width, [int]$height)
    $slideshowFolder = "C:\Users\Administrator\OneDrive\Desktop\Important Sildeshow Wallpapers"
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

# ── FORM ────────────────────────────────────────────────────────
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

$iconPath = "C:\Users\Administrator\OneDrive\Desktop\Useless Stuff\holycleanAPP.ico"
if (Test-Path $iconPath) {
    try { $s = [System.IO.File]::OpenRead($iconPath); $form.Icon = New-Object System.Drawing.Icon($s); $s.Close() } catch {}
}

# ── HOTKEYS + BEEP on Shown ─────────────────────────────────────
$form.Add_Shown({
    $h = $form.Handle
    [LockAPI]::RegisterHotKey($h,  1, 0x0001, 0x09) | Out-Null
    [LockAPI]::RegisterHotKey($h,  2, 0x0001, 0x73) | Out-Null
    [LockAPI]::RegisterHotKey($h,  3, 0x0008, 0x44) | Out-Null
    [LockAPI]::RegisterHotKey($h,  4, 0x0008, 0x09) | Out-Null
    [LockAPI]::RegisterHotKey($h,  5, 0x0008, 0x4D) | Out-Null
    [LockAPI]::RegisterHotKey($h,  6, 0x0008, 0x45) | Out-Null
    [LockAPI]::RegisterHotKey($h,  7, 0x0008, 0x52) | Out-Null
    [LockAPI]::RegisterHotKey($h,  8, 0x0001, 0x1B) | Out-Null
    [LockAPI]::RegisterHotKey($h,  9, 0x0008, 0x4C) | Out-Null
    [LockAPI]::RegisterHotKey($h, 10, 0x0008, 0x58) | Out-Null
    $form.Activate(); $btn.Focus()

    # Beep removed from MercyPopup v3.11 — now fires in MercilessAuthority.exe
    # (BatteryMercy) the instant threshold is detected, before pwsh.exe spawns.
    # True zero-delay: already-warm exe beeps immediately, popup loads in parallel.
})

# ── KEYBOARD LOCKOUT ────────────────────────────────────────────
$form.Add_KeyDown({
    param($s, $e)
    $ok = @([System.Windows.Forms.Keys]::Return, [System.Windows.Forms.Keys]::Space)
    if ($ok -notcontains $e.KeyCode) { $e.Handled = $true; $e.SuppressKeyPress = $true }
})

# ── CLOSE GUARD ─────────────────────────────────────────────────
$form.Add_FormClosing({
    param($s, $e)
    $safe = @(
        [System.Windows.Forms.CloseReason]::TaskManagerClosing,
        [System.Windows.Forms.CloseReason]::ApplicationExitCall,
        [System.Windows.Forms.CloseReason]::WindowsShutDown
    )
    if ($form.DialogResult -ne [System.Windows.Forms.DialogResult]::OK -and $safe -notcontains $e.CloseReason) {
        $e.Cancel = $true
    }
})

# ── RED BORDER STRIPES ──────────────────────────────────────────
$tBar = New-Object System.Windows.Forms.Panel
$tBar.BackColor = [System.Drawing.Color]::FromArgb(220,0,0)
$tBar.Size      = New-Object System.Drawing.Size([int]$sw, 14)
$tBar.Location  = New-Object System.Drawing.Point(0, 0)
$form.Controls.Add($tBar)

$bBarY = [int]($sh - 14)
$bBar = New-Object System.Windows.Forms.Panel
$bBar.BackColor = [System.Drawing.Color]::FromArgb(220,0,0)
$bBar.Size      = New-Object System.Drawing.Size([int]$sw, 14)
$bBar.Location  = New-Object System.Drawing.Point(0, $bBarY)
$form.Controls.Add($bBar)

# ── TABLE LAYOUT ────────────────────────────────────────────────
# Rows: spacer | icon | title | divider | percent | message | button | spacer
$tbl = New-Object System.Windows.Forms.TableLayoutPanel
$tbl.Dock        = [System.Windows.Forms.DockStyle]::Fill
$tbl.BackColor   = [System.Drawing.Color]::Transparent
$tbl.ColumnCount = 3
$tbl.RowCount    = 8
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 20))) | Out-Null
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 60))) | Out-Null
$tbl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 20))) | Out-Null
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent,  8))) | Out-Null  # 0 spacer
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 12))) | Out-Null  # 1 icon
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 10))) | Out-Null  # 2 title
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent,  2))) | Out-Null  # 3 divider
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 14))) | Out-Null  # 4 percent glow
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 16))) | Out-Null  # 5 message
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 18))) | Out-Null  # 6 button
$tbl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 20))) | Out-Null  # 7 spacer
$form.Controls.Add($tbl)

# ── ROW 1: WARNING ICON ─────────────────────────────────────────
$iconSz = [Math]::Max(64, [int]($sh * 0.10))
$pic = New-Object System.Windows.Forms.PictureBox
$pic.Image     = [System.Drawing.SystemIcons]::Warning.ToBitmap()
$pic.Size      = New-Object System.Drawing.Size($iconSz, $iconSz)
$pic.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
$pic.BackColor = [System.Drawing.Color]::Transparent
$pic.Anchor    = [System.Windows.Forms.AnchorStyles]::None
$tbl.Controls.Add($pic, 1, 1)

# ── ROW 2: TITLE ────────────────────────────────────────────────
$tFontSz = [Math]::Max(16, [int]($sh / 46))
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text      = "!! BATTERY MERCY  --  SYSTEM OVERRIDE !!"
$titleLabel.ForeColor = [System.Drawing.Color]::FromArgb(255, 70, 70)
$titleLabel.BackColor = [System.Drawing.Color]::Transparent
$titleLabel.Font      = New-Object System.Drawing.Font("Segoe UI", $tFontSz, [System.Drawing.FontStyle]::Bold)
$titleLabel.Dock      = [System.Windows.Forms.DockStyle]::Fill
$titleLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$tbl.Controls.Add($titleLabel, 1, 2)

# ── ROW 3: DIVIDER ──────────────────────────────────────────────
$div = New-Object System.Windows.Forms.Panel
$div.BackColor = [System.Drawing.Color]::FromArgb(200, 0, 0)
$div.Height    = 3
$div.Dock      = [System.Windows.Forms.DockStyle]::None
$div.Anchor    = [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Top
$tbl.Controls.Add($div, 1, 3)

# ── ROW 4: GLOWING RED PERCENTAGE ───────────────────────────────
# Custom Paint event draws glow by rendering the text multiple times
# in decreasing-alpha red at increasing pixel offsets, then the crisp
# main text on top. Simulates a GPU bloom/glow without DirectX.
$pFontSz = [Math]::Max(28, [int]($sh / 28))
$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.Text      = $percentStr   # e.g. "34%" or "" if no % in message
$percentLabel.BackColor = [System.Drawing.Color]::Transparent
$percentLabel.Font      = New-Object System.Drawing.Font("Segoe UI", $pFontSz, [System.Drawing.FontStyle]::Bold)
$percentLabel.Dock      = [System.Windows.Forms.DockStyle]::Fill
$percentLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$percentLabel.Add_Paint({
    param($sender, $e)
    if ([string]::IsNullOrEmpty($sender.Text)) { return }

    $g   = $e.Graphics
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
    $sf  = New-Object System.Drawing.StringFormat
    $sf.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF(0, 0, $sender.Width, $sender.Height)

    # Glow layers: offset=4 (faintest) down to offset=1 (brightest near text)
    $glowData = @(
        @(4, 18),   # offset=4, alpha=18  — wide outer glow
        @(3, 35),   # offset=3, alpha=35
        @(2, 60),   # offset=2, alpha=60
        @(1, 100)   # offset=1, alpha=100 — tight inner glow
    )
    foreach ($gd in $glowData) {
        $off   = $gd[0]
        $alpha = $gd[1]
        $glowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($alpha, 255, 30, 30))
        for ($dx = -$off; $dx -le $off; $dx++) {
            for ($dy = -$off; $dy -le $off; $dy++) {
                $gr = New-Object System.Drawing.RectangleF($dx, $dy, $sender.Width, $sender.Height)
                $g.DrawString($sender.Text, $sender.Font, $glowBrush, $gr, $sf)
            }
        }
        $glowBrush.Dispose()
    }
    # Crisp main text on top
    $mainBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 65, 65))
    $g.DrawString($sender.Text, $sender.Font, $mainBrush, $rect, $sf)
    $mainBrush.Dispose()
    $sf.Dispose()
})
$tbl.Controls.Add($percentLabel, 1, 4)

# ── ROW 5: MESSAGE ──────────────────────────────────────────────
$mFontSz = [Math]::Max(11, [int]($sh / 60))
$label = New-Object System.Windows.Forms.Label
$label.Text      = $msg
$label.ForeColor = [System.Drawing.Color]::White
$label.BackColor = [System.Drawing.Color]::Transparent
$label.Font      = New-Object System.Drawing.Font("Segoe UI", $mFontSz, [System.Drawing.FontStyle]::Bold)
$label.Dock      = [System.Windows.Forms.DockStyle]::Fill
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$tbl.Controls.Add($label, 1, 5)

# ── ROW 6: YES MASTER BUTTON ────────────────────────────────────
$bFontSz = [Math]::Max(12, [int]($sh / 55))
$btnH    = [Math]::Max(50, [int]($sh * 0.075))
$btnW    = [Math]::Max(200, [int]($sw * 0.20))
$btn = New-Object System.Windows.Forms.Button
$btn.Text      = "  YES, Master~!  "
$btn.Size      = New-Object System.Drawing.Size($btnW, $btnH)
$btn.Font      = New-Object System.Drawing.Font("Segoe UI", $bFontSz, [System.Drawing.FontStyle]::Bold)
$btn.BackColor = [System.Drawing.Color]::FromArgb(210, 20, 20)
$btn.ForeColor = [System.Drawing.Color]::White
$btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btn.FlatAppearance.BorderColor = [System.Drawing.Color]::FromArgb(255, 130, 130)
$btn.FlatAppearance.BorderSize  = 3
$btn.Anchor       = [System.Windows.Forms.AnchorStyles]::None
$btn.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $btn
$tbl.Controls.Add($btn, 1, 6)

# ── TOPMOST + FOCUS LOCK (Task Manager immune) ──────────────────
$lockTimer = New-Object System.Windows.Forms.Timer
$lockTimer.Interval = 150
$lockTimer.Add_Tick({
    if ([LockAPI]::IsTaskManagerForeground()) { return }
    [LockAPI]::SetWindowPos($form.Handle, [LockAPI]::HWND_TOPMOST, 0, 0, 0, 0, 0x0003) | Out-Null
    [LockAPI]::SetForegroundWindow($form.Handle) | Out-Null
    [LockAPI]::BringWindowToTop($form.Handle) | Out-Null
    $form.Activate()
    if (-not $btn.Focused) { $btn.Focus() }
})
$lockTimer.Start()

$form.ShowDialog() | Out-Null

# ── CLEANUP ─────────────────────────────────────────────────────
# beeperThread is IsBackground=true — already dead the instant ShowDialog returned.
# No EndInvoke, no Stop(), no blocking. Zero delay on exit.
try { for ($i=1; $i -le 10; $i++) { [LockAPI]::UnregisterHotKey($form.Handle, $i) | Out-Null } } catch {}
$lockTimer.Stop(); $lockTimer.Dispose()
$wallpaperBitmap.Dispose()
$form.Dispose()
