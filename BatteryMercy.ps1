# ═══════════════════════════════════════════════════════════════════
# BatteryMercy.ps1 — "TOTALITARIAN AUTHORITARIAN" Battery Monitor v2.21
# ───────────────────────────────────────────────────────────────────
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8246 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ═══════════════════════════════════════════════════════════════════
# WHAT IT DOES:
#   Monitors laptop battery % every 5 seconds via kernel32 GetSystemPowerStatus()
#   P/Invoke (exact taskbar accuracy — no WMI lag). On threshold breach, fires a
#   fullscreen unclosable WinForms popup with wallpaper background, melodic beep,
#   red gradient glow text, animated YES button, and drop-shadows on all elements.
#
#   Three alert modes:
#     LOW    (≤35%, unplugged, per-% drop)  — sad descending beep, yellow warning icon
#     HIGH   (≥85%, plugged in, per-% rise) — ascending major beep, green checkmark icon
#     DEAD   (≤10%, unplugged)              — ominous descending beep, red X icon,
#                                             60-second double-buffered countdown,
#                                             Stop-Computer -Force if still unplugged
#
# ─ Architecture: ───────────────────────────────────────────────────────
#     • Global Mutex (Global\BatteryMercyTotalitarian) — bulletproof single instance
#     • Popup runs inside MercilessAuthority.exe via PS Runspace on STA thread
#     • Beep fires exactly on Add_Shown — zero gap between sight and sound
#     • Win key blocked via WH_KEYBOARD_LL low-level hook
#     • All hotkeys (Alt+Tab, Ctrl+Esc, etc.) blocked via RegisterHotKey
#     • Task Manager retains focus-steal ability as emergency escape
#     • TableLayoutPanel layout — DPI-proof at 150% scaling on 1080p IPS
#     • Wallpaper slice repaint on all custom-rendered labels — no GDI ghost text
#     • DEAD countdown: double-buffered Panel via SetStyle reflection —
#       WM_ERASEBKGND suppressed, zero flicker, cached bg bitmap, 1s ticks
#
# COMPILED OUTPUT : $PSScriptRoot\MercilessAuthority.exe (ps2exe v0.5.0.33)
# TASK SCHEDULER  : MercilessBatteryMonitor → runs LaunchBattery.vbs at logon
# TESTRUN         : BatteryMercy_TestRun.ps1 (safe — no Stop-Computer)
# ═══════════════════════════════════════════════════════════════════
#
# ─ CHANGELOG ──────────────────────────────────────────────────────────
# Version 1.0 February 16, 2026 - Born in raw Windows PowerShell 5.1. Basic battery
#                                 watcher using Win32_Battery WMI query. Simple
#                                 MessageBox popup. No mutex, no duplicate prevention.
#                                 Ran visibly in a PS window like a noob lmao.
# Version 2.0 February 18, 2026 - Full revamp. Custom popup dialog replacing MessageBox.
#                                 Added threshold logic for both low (35%) and high (85%).
# Version 2.1 February 19, 2026 - RAM optimization. Added partial duplicate prevention
#                                 via WMI process query (later replaced by mutex).
#                                 Reduced memory churn in polling loop.
# Version 2.2 March 14, 2026    - Global Mutex lock (Global\BatteryMercyTotalitarian)
#                                 — bulletproof single-instance enforcement. Icon fix.
#                                 Scope guard for vars. catch/continue safety net.
# Version 2.3 March 14, 2026    - CRITICAL: replaced Win32_Battery WMI with kernel32
#                                 GetSystemPowerStatus() P/Invoke — exact taskbar %.
#                                 "YES, Master~!" button born.
# Version 2.4 March 15, 2026    - Polling interval slashed: 30s → 10s.
# Version 2.5 March 15, 2026    - Polling interval slashed again: 10s → 5s.
# Version 2.6 March 15, 2026      Compiled to .exe via ps2exe for clean startup.
#                                 MercyPopup.ps1 spawned via pwsh.exe PS7 STA.
#                                 Another full revamp from Popup message to Fullscreen.
#                                 FIRST EVER REAL POPUP FIRED at 35% Actually.
# Version 2.7 March 15, 2026    - Beep moved into BatteryMercy.exe (warm process).
#                                 Fired before pwsh.exe spawn. Still async, not
#                                 truly synced — popup cold-start gap remained.
# Version 2.8 March 15, 2026    - TRUE ZERO-DELAY SYNC: eliminated pwsh.exe spawn
#                                 entirely. Popup now runs inside THIS process via
#                                 PS Runspace on a new STA thread. Beep + popup
#                                 both launch from the same warm exe simultaneously.
#                                 No cold-start, no process gap, no async mismatch.
#                                 MercyPopup.ps1 kept for standalone manual testing.
# Version 2.9 March 16, 2026    - TRULY INSTANTANEOUS BEEP: moved beep fire INTO
#                                 Add_Shown event — beep now triggers the exact
#                                 millisecond the form becomes visible on screen.
#                                 Zero gap between sight and sound. Removed
#                                 StartBeep() from Show-Merciless-Message.
#                                 IRON CURTAIN UPGRADE: Win key (LWin/RWin)
#                                 now blocked via WH_KEYBOARD_LL low-level hook.
#                                 Ctrl+Esc (Start menu) blocked via RegisterHotKey.
#                                 No escape routes remain except "YES, Master~!" lmao.
# Version 2.10 March 17, 2026   - Blind irreversible changes i made which causes error
#                                 because now Using this in VSCode Studio than in Notepad...
#                                 or i assume is because of VScode powershell extension.
#                                 Got frustrated in this moment lmao i resort to AI
#                                 that sometimes can't really help like ChatGPT free tier...
# Version 2.11 March 19, 2026   - THREE distinct melodic beeps via LockAPI2 C# thread
#                                 methods: LOW (sad descending minor), HIGH (energetic
#                                 ascending major), DEADMAN (suspenseful ominous low).
#                                 DEADMAN popup: 60-second countdown replaces % glow;
#                                 auto-closes form at zero then triggers Stop-Computer.
#                                 HIGH popup icon: GDI+ drawn green checkmark replaces
#                                 Win7 yellow warning sign. DEAD popup: SystemIcons.Error.
#                                 Hand cursor on YES button. FormClosing now allows
#                                 DialogResult.No so countdown auto-close is not blocked.
#                                 Removed GC.Collect()/WaitForPendingFinalizers() from
#                                 main polling loop — these were hammering the Celeron
#                                 5205U every 5s causing File Explorer lag and taskbar
#                                 icon hover flicker. Message prefixes LOW:/HIGH:/DEADMAN:
#                                 route each popup to the correct mode. LaunchBattery.vbs
#                                 bug fixed: now always relaunches after killing old instance.
# Version 2.12 March 19, 2026   - CRITICAL STRUCT BUG FIXED: BatteryAPI.SYSTEM_POWER_STATUS
#                                 had two fake fields (BatteryLifeFlag + BatteryLifeRemaining)
#                                 that don't exist in the real Windows API. These shifted
#                                 BatteryLifePercent to wrong memory offset — always returned
#                                 0xFF (255) instead of real battery %. Since 255 > 35 and
#                                 255 never changed, LOW/HIGH/DEADMAN popups NEVER fired.
#                                 Fixed by removing the two nonexistent fields from struct.
# Version 2.13 March 19, 2026   - BUTTON ANIMATION FIX: $hoverTarget, $normalTop, $currentTop,
#                                 $targetTop all changed to $script: scope. WinForms event
#                                 handler closures (Add_Tick, Add_MouseEnter, Add_MouseLeave,
#                                 Add_MouseDown, Add_MouseUp) run in child scopes and couldn't
#                                 read/write the outer animation state variables — float hover,
#                                 shrink on click and shadow movement all silently did nothing.
#                                 $script: scope makes all closures share the same state.
# Version 2.14 March 19, 2026   - CRITICAL LOCKOUT FIX: Controls.Add order was WRONG.
#                                 WinForms renders first-added controls ON TOP. Shadow was
#                                 added before button → shadow sat on TOP of "YES~" button →
#                                 ALL clicks intercepted by shadow → button unreachable →
#                                 every lockout incident caused by this since v2.6. Fixed by
#                                 adding button first, shadow second, then BringToFront().
#                                 Added shadow.Enabled=false as second defense layer.
#                                 Hover glow: BackColor brightens + border lightens on enter.
#                                 Button glow paint: soft red glow drawn around button edges.
# Version 2.15 March 19, 2026   - 5 melodic notes per beep: LOW adds A4(440Hz) descent,
#                                 HIGH adds E6(1319Hz) triumphant peak, DEAD adds 200Hz
#                                 deep ominous final note. All 5-note sequences complete.
#                                 BLACK→RED gradient glow on % label: 5 layers transitioning
#                                 from near-black outer to bright red inner — ominous deadly
#                                 battery drain effect. Shadow Paint overlays on title and
#                                 message labels. PictureBox drop shadow panel. Button row
#                                 percentage increased 18→22 for uncrowded "YES~" button space.
#                                 Button wider (sw*0.28) and taller (sh*0.092) with smaller
#                                 font (sh/68) so text breathes freely inside button bounds.
# Version 2.16 March 20, 2026   - GHOST TEXT ELIMINATED: wallpaper bitmap slice repainted
#                                 at start of titleLabel and message label Paint handlers
#                                 via PointToScreen/PointToClient coordinate mapping —
#                                 completely obliterates default GDI ghost before custom
#                                 shadow+text renders. UseCompatibleTextRendering approach
#                                 alone was insufficient — base Label OnPaint still leaked
#                                 through in some GDI render paths at 150% DPI.
#                                 BUTTON HOVER CLIP FIXED: btnContainer height increased
#                                 from +12px to +40px; normalTop set to 14px; hoverTarget
#                                 set to 2px — button floats up 12px on hover and never
#                                 clips at the container top boundary.
#                                 SMOOTH CLICK ANIMATION: $script:currentScale /
#                                 $script:targetScale lerped at 0.3 rate in animTimer tick
#                                 (15ms interval) — shrink and restore are now fluid instead
#                                 of instant snap. MouseDown sets targetScale=0.92 + bright
#                                 color; MouseUp restores to 1.0 + hover color. Direct
#                                 Width/Height assignment removed from MouseDown/MouseUp.
# Version 2.17 March 20, 2026   - DEAD COUNTDOWN FLICKER ELIMINATED: percentLabel
#                                 BackColor changed from Transparent to Black — opaque
#                                 BackColor stops WinForms cascading repaint up to Form
#                                 on every Text change, preventing full-screen flicker.
#                                 Wallpaper-slice repaint added to percentLabel Paint
#                                 handler (same pattern as titleLabel/msgLabel) so visual
#                                 appearance is identical to transparent. Manual
#                                 Invalidate() call removed from countdown tick — Text
#                                 assignment alone triggers repaint now cleanly.
#                                 COUNTDOWN TEXT FORMAT: "60" → "Countdown: 60" for DEAD
#                                 mode. Smaller font (sh/40) used for DEAD countdown since
#                                 "Countdown: X" is wider than a bare number. LOW/HIGH
#                                 modes keep the large glow number unchanged. Paint handler
#                                 branches on text.StartsWith("Countdown:") to route
#                                 shadow-style vs glow-style rendering automatically.
#                                 ICON CLIP FIXED (final): iconSz reduced from sh*0.10
#                                 to sh*0.082 — fits cleanly within 10% row height with
#                                 margin headroom. No clipping on any edge at any DPI.
# Version 2.18 March 20, 2026   - COUNTDOWN GRADIENT RESTORED: removed the Countdown:*
#                                 branch that was routing to plain shadow render — now
#                                 all percentLabel text (both % numbers and Countdown: X)
#                                 goes through the full 5-layer black→dark red→bright red
#                                 gradient glow. Visual parity fully restored between
#                                 LOW/HIGH % and DEAD countdown display.
#                                 DEADMAN message updated to full declaration text.
# Version 2.19 March 20, 2026   - COUNTDOWN FLICKER ELIMINATED PERMANENTLY: root cause
#                                 was Label.Text= firing WM_ERASEBKGND → BackColor fill
#                                 flash BEFORE Paint runs — no amount of wallpaper-slice
#                                 repaint in Paint can fix this on a standard Label.
#                                 Fix: DEAD mode now uses a double-buffered Panel via
#                                 SetStyle reflection (AllPaintingInWmPaint + Optimized
#                                 DoubleBuffer + UserPaint) — WM_ERASEBKGND suppressed
#                                 entirely, all frames rendered to back buffer and blitted
#                                 atomically. percentLabel hidden (Visible=false) in DEAD
#                                 mode. $script:cdNum holds the current number — only
#                                 Invalidate() called on tick, never .Text= assignment.
#                                 BG wallpaper slice cached to $script:cdBgSlice Bitmap
#                                 on first Paint (layout finalized by then) and reused
#                                 every frame — no per-frame DrawImage from full wallpaper.
#                                 Timer interval changed 500ms → 1000ms (exact 1s ticks).
#                                 cdBgSlice Bitmap disposed on form close.
# Version 2.20 March 20, 2026   - PS7 SETSTYLE FIX: reflection Invoke with enum -bor
#                                 in @() array threw "op_BitwiseOr not found" in PS7.
#                                 Fixed by casting each ControlStyles flag to [int],
#                                 OR-ing as integers, then casting back to ControlStyles
#                                 before passing to Invoke — PS7 compatible.
#                                 COUNTDOWN FIRST-FRAME FIX: bg slice PointToScreen
#                                 coords are wrong before layout finalizes (first Paint
#                                 fires too early). Added cdPanel.Invalidate() inside
#                                 BeginInvoke in Add_Shown — runs after message queue
#                                 drains and layout is fully settled, guaranteeing first
#                                 visible Paint has correct wallpaper slice coords.
#                                 BUTTON CLICK SNAP: asymmetric lerp rate — shrink uses
#                                 0.85 (instant snap down in ~2 ticks/30ms), restore uses
#                                 0.3 (smooth elastic bounce back). Press feels snappy,
#                                 release feels fluid. Previously both directions used 0.3.
# Version 2.21 April 27, 2026   - Finally released to GitHub repo and fixed every single file
#                                 path directories for other laptops too instead of mine!
# Version 2.22 April idk, 2026  - Animation button when on hover or on click will be fixed soon
#                                 maybe i guess since i find it kinda blocky, blurry or strange i guess.
#                                 It'll be soon.
# Version 3.0 Unknown date 2026 - Final tweaks. Code cleanup. Comment polish. Version bump to 3.0.
#                                 Only in the future however...
# ─────────────────────────────────────────────────────────────────

# ── MUTEX SINGLE INSTANCE LOCK ─────────────────────────────────
$mutexName = "Global\BatteryMercyTotalitarian"
$mutex = New-Object System.Threading.Mutex($false, $mutexName)
if (-not $mutex.WaitOne(0)) {
    $mutex.Close()
    exit
}

# ── KERNEL32 BATTERY API + INSTANT BEEP ────────────────────────
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class BatteryAPI {
    [StructLayout(LayoutKind.Sequential)]
    public struct SYSTEM_POWER_STATUS {
        public byte ACLineStatus;
        public byte BatteryFlag;
        public byte BatteryLifePercent;
        public byte SystemStatusFlag;
        public uint BatteryLifeTime;
        public uint BatteryFullLifeTime;
        public uint Reserved1;
    }
    [DllImport("kernel32.dll")]
    public static extern bool GetSystemPowerStatus(out SYSTEM_POWER_STATUS s);
    public static SYSTEM_POWER_STATUS Get() {
        SYSTEM_POWER_STATUS s;
        GetSystemPowerStatus(out s);
        return s;
    }
    private static void PlayAlarm() {
        try {
            Console.Beep(880,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(660,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(880,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(660,  150); System.Threading.Thread.Sleep(60);
            Console.Beep(1100, 600);
        } catch {}
    }
    public static void StartBeep() {
        System.Threading.Thread t = new System.Threading.Thread(PlayAlarm);
        t.IsBackground = true;
        t.Start();
    }
}
"@

# ── INLINE POPUP SCRIPT (runs inside THIS process via Runspace) ─
# No pwsh.exe spawn. No cold-start. Beep and popup both fire from
# the same warm MercilessAuthority.exe process simultaneously.
$popupScript = {
    param([string]$msg)

    # ── MODE EXTRACTION — strip prefix, route to correct mode ──
    $mode = "LOW"
    if ($msg -match '^DEADMAN:') { $mode = "DEAD"; $msg = $msg -replace '^DEADMAN:','' }
    elseif ($msg -match '^HIGH:') { $mode = "HIGH"; $msg = $msg -replace '^HIGH:','' }
    elseif ($msg -match '^LOW:')  { $mode = "LOW";  $msg = $msg -replace '^LOW:','' }

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
    // ── MELODIC BEEPS — three distinct tones per mode ──────────
    public static void StartBeepLow() {
        // Sad descending minor — "plug in now" warning
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
        // Energetic ascending major — "unplug now" celebration
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
        // Suspenseful ominous descending — "machine dies" dread
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

    [LockAPI2]::SetProcessDPIAware() | Out-Null

    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $sw = [int]$screen.Width
    $sh = [int]$screen.Height

    $percentStr = ""
    if ($msg -match '(\d+%)') { $percentStr = $matches[1] }

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

    $iconPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "holycleanAPP.ico"
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
        # Block Win key (LWin/RWin) via low-level keyboard hook
        [LockAPI2]::InstallWinHook()
        # INSTANTANEOUS MELODIC BEEP — fires the exact moment form becomes visible
        # Mode-routed: LOW = sad descending, HIGH = energetic ascending, DEAD = ominous
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
        # Allow OK (YES button) and No (DEADMAN countdown auto-close)
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

    $bBarY = [int]($sh - 14)
    $bBar = New-Object System.Windows.Forms.Panel
    $bBar.BackColor = [System.Drawing.Color]::FromArgb(220,0,0)
    $bBar.Size      = New-Object System.Drawing.Size([int]$sw, 14)
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

    # ── MODE-BASED ICON ────────────────────────────────────────
    # HIGH  → GDI+ green checkmark (positive: unplug charger)
    # DEAD  → System Error icon red X (terminal: machine dies)
    # LOW   → System Warning icon yellow ! (default: plug in)
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
        $sf2.Alignment = [System.Drawing.StringAlignment]::Center
        $sf2.LineAlignment = [System.Drawing.StringAlignment]::Center
        $shBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 0, 0, 0))
        $shRect = New-Object System.Drawing.RectangleF(3, 3, $s2.Width, $s2.Height)
        $g2.DrawString($s2.Text, $s2.Font, $shBrush, $shRect, $sf2)
        $shBrush.Dispose()
        $mainBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 70, 70))
        $mainRect2 = New-Object System.Drawing.RectangleF(0, 0, $s2.Width, $s2.Height)
        $g2.DrawString($s2.Text, $s2.Font, $mainBrush2, $mainRect2, $sf2)
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
        # Black → dark red → bright red gradient glow (outer=near black, inner=bright red)
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

    # ── DEADMAN COUNTDOWN — double-buffered Panel, cached bg, script-scoped number ──
    # WM_ERASEBKGND suppressed via SetStyle reflection → zero flash, zero flicker.
    # Only $script:cdNum changes each tick → Invalidate() redraws to back buffer atomically.
    $cdTimer = $null
    if ($mode -eq "DEAD") {
        $script:cdNum      = 60
        $script:cdBgCached = $false
        $script:cdBgSlice  = $null
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
        $sf3.Alignment = [System.Drawing.StringAlignment]::Center
        $sf3.LineAlignment = [System.Drawing.StringAlignment]::Center
        $shBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 0, 0, 0))
        $shRect3 = New-Object System.Drawing.RectangleF(2, 2, $s3.Width, $s3.Height)
        $g3.DrawString($s3.Text, $s3.Font, $shBrush3, $shRect3, $sf3)
        $shBrush3.Dispose()
        $mainBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $mainRect3 = New-Object System.Drawing.RectangleF(0, 0, $s3.Width, $s3.Height)
        $g3.DrawString($s3.Text, $s3.Font, $mainBrush3, $mainRect3, $sf3)
        $mainBrush3.Dispose(); $sf3.Dispose()
    })
    $tbl.Controls.Add($label, 1, 5)

    $bFontSz = [Math]::Max(11, [int]($sh / 68))
    $btnH    = [Math]::Max(62, [int]($sh * 0.092))
    $btnW    = [Math]::Max(280, [int]($sw * 0.28))

    # Primary button
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
        $glowAlpha = 35
        $glowColor = [System.Drawing.Color]::FromArgb($glowAlpha, 255, 100, 100)
        $glowBrush = New-Object System.Drawing.SolidBrush($glowColor)
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

    # Container + shadow to enable drop-shadow & smooth animations
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

    # center button inside the container
    $btn.Left = [int](($btnContainer.Width - $btn.Width) / 2)
    $btn.Top  = 14

    $shadow.Enabled = $false
    $btnContainer.Controls.Add($btn)
    $btnContainer.Controls.Add($shadow)
    $btn.BringToFront()
    $tbl.Controls.Add($btnContainer, 1, 6)

    # --- Button animation state & timer (smooth float on hover, smooth scale on click)
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
        # smooth shrink + brighten on click
        $script:targetScale = 0.92
        $btn.BackColor = [System.Drawing.Color]::FromArgb(255, 100, 100)
    })

    $btn.Add_MouseUp({
        # smooth restore
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
}

# ── SHOW FUNCTION — popup fires from THIS process, beep fires inside Add_Shown ─
function Show-Merciless-Message($msg) {
    $log = Join-Path $env:TEMP "BatteryMercy_error.log"
    try {
        $rs = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
        $rs.ApartmentState = [System.Threading.ApartmentState]::STA
        $rs.ThreadOptions  = [System.Management.Automation.Runspaces.PSThreadOptions]::ReuseThread
        $rs.Open()

        $ps = [System.Management.Automation.PowerShell]::Create()
        $ps.Runspace = $rs
        $ps.AddScript($popupScript.ToString()) | Out-Null
        $ps.AddArgument($msg) | Out-Null

        try {
            [void]$ps.Invoke()   # blocks until YES clicked — monitoring loop pauses correctly
        } catch {
            $err = $_.Exception.ToString()
            Add-Content -Path $log -Value ("[{0}] Invoke error: {1}" -f (Get-Date), $err)
        }
    } catch {
        $err = $_.Exception.ToString()
        Add-Content -Path $log -Value ("[{0}] Runspace error: {1}" -f (Get-Date), $err)
    } finally {
        try { $ps.Dispose() } catch {}
        try { $rs.Close(); $rs.Dispose() } catch {}
    }
}

# ── INITIAL STATE ───────────────────────────────────────────────
$initPS      = [BatteryAPI]::Get()
$lastPercent = [int]$initPS.BatteryLifePercent

try {
    while ($true) {
        try {
            $powerStatus = [BatteryAPI]::Get()
            $percent = [int]$powerStatus.BatteryLifePercent
            $acLine  = [int]$powerStatus.ACLineStatus

            # DEADMAN'S SWITCH — 10% (countdown is INSIDE the popup)
            # Show-Merciless-Message blocks until YES clicked OR 60s countdown hits zero.
            # After form closes, check AC status — still unplugged = Stop-Computer fires.
            if ($acLine -eq 0 -and $percent -le 10) {
                Show-Merciless-Message "DEADMAN'S SWITCH ACTIVATED: TERMINATION IMMINENT. PLUG IN RIGHT NOW OR ELSE NO SECOND CHANCE, NO SECOND OPTION AND NO SAVED PROGRESS. THE MACHINE DIES WHEN COMPROMISED, LIKE YOU IN LIFE SOON..."
                $checkPS = [BatteryAPI]::Get()
                if ([int]$checkPS.ACLineStatus -eq 0) { Stop-Computer -Force }
            }

            # LOW BATTERY — every percent drop by 1% at and or below 35%
            if ($acLine -eq 0 -and $percent -le 35 -and $percent -lt $lastPercent) {
                Show-Merciless-Message "LOW:CRITICAL DEPLETION: $percent%. FEED THE MACHINE WITH FAITH, SPIRITUAL POWER, STRENGTH, GROWTH, WISDOM AND DISCIPLINE. NOT EGO, LUST, PSYCHOPATHY, MACHIAVELLIANISM MANIPULATION AND IRRESPONSIBILITY."
            }

            # HIGH BATTERY — every percent rise by 1% at and or above 85%
            if ($acLine -eq 1 -and $percent -ge 85 -and $percent -gt $lastPercent) {
                Show-Merciless-Message "HIGH:VOLTAGE OVERLOAD: $percent%. RELEASE THE POWER FEEDER RIGHT NOW TO SAVE BATTERY LIFE OR ELSE IRREVERSIBLE BATTERY DEGRADATION SUCH AS WEAR AND TEAR HAPPENS LIKE YOU IN LIFE SOON..."
                $lastPercent = $percent
            }

            $lastPercent = $percent

        } catch {
            Start-Sleep -Seconds 5
            continue
        }

        Start-Sleep -Seconds 5
    }
} finally {
    $mutex.ReleaseMutex()
    $mutex.Close()
}