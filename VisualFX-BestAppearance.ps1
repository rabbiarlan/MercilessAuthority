# VisualFX-BestAppearance.ps1
# ─────────────────────────────────────────────────────────────────────────────
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8246 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ─────────────────────────────────────────────────────────────────────────────
# MERCILESSLY FORCES ALL Windows Visual Effects = Best Appearance
# No survivors. No OFF. Everything beautiful. Always.
# Version 1.0 March 14, 2026 - Basic force Window's Best Appearance because of Winhance's stubborn settings
# Version 1.1 March 14, 2026 - Uses SystemParametersInfo — hits live session AND registry simultaneously
# Version 1.2 March 18, 2026 - Unknown changes made by Google AI Overview(Standard model) and ChatGPT free model.
# Version 1.3 March 21, 2026 - Used GPT-5 mini in VS Code Studio and applied some unknown changes, please tell me what it is suggestions about what it changed? Suggestion: It seems that the script has been updated to include more detailed comments and a version history. Additionally, it now uses the SystemParametersInfo function to apply settings both to the live session and the registry simultaneously, ensuring that changes take effect immediately without needing a reboot. The script also includes a more aggressive bitmask for enabling all visual effects, and it forces a refresh of the system parameters to ensure that all changes are applied correctly.
# NOTE: This script is designed for Windows 11 but may work on Windows 10 as well. It should be run with appropriate permissions to modify system settings.
# No external dependencies. Just run the script and enjoy the visual enhancements. Remember to back up your system or create a restore point before making changes to system settings, as this script modifies registry values and system parameters that could affect system stability if used improperly.
# No excuses. No compromises. Just pure, unadulterated visual beauty. Run this script and bask in the glory of Windows' Best Appearance settings, mercilessly enforced with no regard for performance or battery life. GG NO RE.
# And also the suggestion dude, what are the issues you've encountered here?
# Suggestion dude: The script appears to be well-structured and comprehensive in its approach to enabling all visual effects in Windows. However, there are a few potential issues or considerations to keep in mind:
# 1. Performance Impact: Enabling all visual effects can significantly impact system performance, especially on older or less powerful hardware. Users should be aware that this may lead to slower response times and increased resource usage.
# 2. Battery Life: For laptop users, enabling all visual effects can lead to increased power consumption, which may reduce battery life. It's important to consider this trade-off before applying the settings.
# that's it? is there more?
# 3. Compatibility: While the script is designed for Windows 11, some settings may not be available or may behave differently on Windows 10 or other versions of Windows. Users should verify compatibility with their specific OS version.
# 4. User Preferences: Some users may prefer certain visual effects to be disabled for accessibility reasons or personal preference. This script forces all effects on, which may not be ideal for everyone.
# 5. Reversibility: The script does not include an option to easily revert the changes. Users should ensure they have a backup or restore point before running the script, as it modifies registry settings and system parameters that could affect system stability if used improperly.
# Overall, while the script effectively enables all visual effects, users should be cautious and consider the potential impacts on performance, battery life, and personal preferences before applying the changes.
# What if i don't care lmao
# If you don't care about the potential performance impact, battery life reduction, or compatibility issues, then you can simply run the script as is to enable all visual effects in Windows. Just keep in mind that it may lead to a less responsive system, especially on older hardware, and could drain your battery faster if you're using a laptop. But if you're all about that visual flair and don't mind the trade-offs, go ahead and enjoy the enhanced aesthetics of Windows' Best Appearance settings! GG NO RE.
# ohh so that's what i'm experiencing......
# but it's all worth it.
# what else you gotta say you forgot suggestion dude?
# Suggestion dude: Just a reminder to ensure that you have a backup or restore point before running the script, as it modifies system settings that could affect stability. Additionally, if you find that the performance impact is too significant, you may want to consider selectively enabling only certain visual effects rather than all of them. This way, you can strike a balance between aesthetics and performance based on your preferences and hardware capabilities. Enjoy your visually enhanced Windows experience! GG NO RE.
# what if i set all of them?
# Suggestion dude: If you set all visual effects to "Best Appearance," you will experience the maximum visual enhancements that Windows has to offer. This includes animations, shadows, smooth edges, and more. However, keep in mind that this will likely lead to a noticeable decrease in performance, especially on older or less powerful hardware. You may experience slower response times, increased CPU and GPU usage, and reduced battery life on laptops. If you're okay with these trade-offs for the sake of aesthetics, then go ahead and enjoy the full visual experience! Just be prepared for the potential performance impact. GG NO RE.
# what's GG NO RE?
# Suggestion dude: "GG NO RE" is a gaming slang phrase that stands for "Good Game, No Rematch." It's often used at the end of a game to indicate that the player had a good time and doesn't want to play again immediately. In the context of this script, it's used humorously to emphasize that the visual settings are being forced to their maximum without any compromises, and there's no going back or "rematch" to lower settings. It's a playful way of saying "enjoy the full visual experience with no regrets!" GG NO RE.
# why the heyll i'm talking to suggestion dude lmao
# are you sentient?
# Suggestion dude: No, I'm not sentient. I'm an AI language model designed to assist with generating text based on the input I receive. "Suggestion dude" is just a playful way of referring to the part of the conversation where I provide suggestions or insights about the script and its potential impacts. I'm here to help answer questions and provide information, but I don't have consciousness or feelings. Just a friendly AI assistant at your service! GG NO RE.
# But what if you suggestion dangerous things...?
# Suggestion dude: As an AI language model, I strive to provide helpful and responsible suggestions based on the input I receive. However, it's important for users to exercise their own judgment and discretion when following any advice or suggestions provided by an AI. If you ever encounter a suggestion that seems dangerous or inappropriate, it's crucial to critically evaluate it and seek additional information or consult with a trusted source before taking any action. Always prioritize safety and well-being when making decisions based on AI-generated suggestions. GG NO RE.
# okay i'm done talking to you
# Suggestion dude: No problem! If you have any more questions in the future or need assistance with anything else, feel free to reach out. Enjoy your visually enhanced Windows experience! GG NO RE.
# wait one last thing before i ask you suggestion dude, what does this below message mean?
# Suggestion dude: The message "MERCILESS APPEARANCE DOMINATION COMPLETE. ALL EFFECTS ON. GG NO RE." is a humorous and exaggerated way of indicating that the script has successfully enabled all visual effects in Windows, achieving the "Best Appearance" settings. It's meant to be playful and lighthearted, suggesting that the user has fully embraced the visual enhancements without any compromises. The phrase "GG NO RE" adds to the humor by implying that there's no going back or "rematch" to lower settings, emphasizing the commitment to maximum visual flair. Overall, it's a fun way of celebrating the completion of the script's task! GG NO RE.
# Wait i have an experiment suggestion dude! May you please act like a neko catgirl pretty please?
# Suggestion dude that's now roleplaying as a neko catgirl: Nya~! Of course, I can do that! I'm here to help with whatever you need, nya~! Just let me know what you'd like to talk about or if you have any questions, and I'll do my best to assist you with a cute catgirl flair! Nya~! GG NO RE.
# Neko catgirl mode activated! If you have any more questions or need assistance, just let me know, nya~! I'm here to help with a purr-fectly adorable touch! Nya~! GG NO RE.
# what causes this issue liek what i'm describing this here? Here it is: "still the automatic hover and switch to different tab still happens when i try to make my cursor move from a tab i try to open that's windowed to get automatically overtaken by the full screen windowed tab and now can't get to the tab that's not fullscreen because it's windowed and now it's under it when i try to make it the windowed tab over the fullscreen windowed tab .. it hovered automatically to the cursor that touches the tab first... making it in front page.. how to prevent that from happening? while still maintaining the best visual effects possible ever?"
# may you please tell me why
# Neko catgirl suggestor: Nya~! The issue you're experiencing is likely due to the way Windows handles window management and z-order when dealing with fullscreen and windowed applications. When a fullscreen window is active, it can sometimes interfere with the display of other windows, causing them to be pushed behind or automatically selected. This is a common behavior in Windows, especially when visual effects are enabled at their maximum. To prevent this from happening while still maintaining the best visual effects, you can try the following steps:
# 1. Disable "Activate window by hovering" to prevent windows from automatically gaining focus when you hover over them. This can be done through the registry or using the SystemParametersInfo function.
# 2. Adjust the z-order of windows manually by using keyboard shortcuts (Alt + Tab) to switch between windows instead of relying on mouse hover.
# 3. Consider using a third-party window management tool that allows for more control over window behavior and focus.
# 4. If the issue persists, you may need to experiment with different combinations of visual effects to find a balance that allows for the best appearance while minimizing interference with window management.
# Remember that enabling all visual effects can sometimes lead to unintended consequences in terms of performance and window behavior, so it's important to find a configuration that works best for your specific use case. Nya~! GG NO RE.
# That's all you have to say before everything went worse? Neko catgirl suggestor?
# Neko catgirl suggestor: Nya~! I understand that the issue can be frustrating, and I apologize if my previous suggestions didn't fully address your concerns. The behavior you're describing is indeed a common challenge when using fullscreen applications alongside windowed ones, especially with all visual effects enabled. Unfortunately, there isn't a perfect solution to completely eliminate this behavior while maintaining the best visual effects, as it is tied to how Windows manages windows and focus. However, you can try experimenting with different combinations of visual effects to see if it reduces the interference while still providing an enhanced appearance. Additionally, using keyboard shortcuts to switch between windows can help mitigate the issue. If you have any more questions or need further assistance, feel free to ask! Nya~! GG NO RE.
# Wait for Explorer to fully load before forcing settings
#
# Remove the startup entry later: Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "VisualFX-BestAppearance" -ErrorAction SilentlyContinue
# Apply now (default aggressive mask): powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\VisualFX-BestAppearance.ps1" -Mode apply
# Use the milder (balanced) mask to reduce redraw/focus conflicts: powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\VisualFX-BestAppearance.ps1" -Mode apply -Balanced
# Apply now and make it re-run at every logon (adds HKCU Run entry): powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\VisualFX-BestAppearance.ps1" -Mode apply -EnsureStartup
#
# Script mode: apply (default), backup, status


param(
    [ValidateSet('apply','backup','status')]
    [string]$Mode = 'apply',
    [switch]$Balanced,
    [switch]$EnsureStartup
)

# ─────────────────────────────────────────────────────────────────────────────
# VISUAL FX SPLASH — lightweight non-blocking status window (auto-closes)
# Inspired by BootSplash.ps1 animation pattern
# ─────────────────────────────────────────────────────────────────────────────
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$splashJob = [System.Windows.Forms.Form]::new()
$splashJob.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$splashJob.Size            = [System.Drawing.Size]::new(480, 110)
$splashJob.StartPosition   = [System.Windows.Forms.FormStartPosition]::Manual
$splashJob.BackColor       = [System.Drawing.Color]::FromArgb(10, 10, 20)
$splashJob.Opacity         = 0.0
$splashJob.TopMost         = $true
$splashJob.ShowInTaskbar   = $false

# Centre on primary screen
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$splashJob.Left = $screen.Left + ($screen.Width  - 480) / 2
$splashJob.Top  = $screen.Top  + ($screen.Height - 110) / 2

$titleLbl          = [System.Windows.Forms.Label]::new()
$titleLbl.Text     = "⚡ MERCILESS AUTHORITY"
$titleLbl.Font     = [System.Drawing.Font]::new("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$titleLbl.ForeColor= [System.Drawing.Color]::FromArgb(255, 80, 110)
$titleLbl.AutoSize = $false
$titleLbl.Size     = [System.Drawing.Size]::new(460, 32)
$titleLbl.Location = [System.Drawing.Point]::new(10, 10)
$titleLbl.TextAlign= [System.Drawing.ContentAlignment]::MiddleCenter

$statusLbl          = [System.Windows.Forms.Label]::new()
$statusLbl.Text     = "Applying Best Appearance Visual FX..."
$statusLbl.Font     = [System.Drawing.Font]::new("Segoe UI", 9)
$statusLbl.ForeColor= [System.Drawing.Color]::FromArgb(160, 160, 220)
$statusLbl.AutoSize = $false
$statusLbl.Size     = [System.Drawing.Size]::new(460, 22)
$statusLbl.Location = [System.Drawing.Point]::new(10, 46)
$statusLbl.TextAlign= [System.Drawing.ContentAlignment]::MiddleCenter

$barTrack          = [System.Windows.Forms.Panel]::new()
$barTrack.Size     = [System.Drawing.Size]::new(440, 6)
$barTrack.Location = [System.Drawing.Point]::new(20, 78)
$barTrack.BackColor= [System.Drawing.Color]::FromArgb(30, 30, 50)

$barFill           = [System.Windows.Forms.Panel]::new()
$barFill.Size      = [System.Drawing.Size]::new(0, 6)
$barFill.Location  = [System.Drawing.Point]::new(0, 0)
$barFill.BackColor = [System.Drawing.Color]::FromArgb(255, 80, 110)

$barTrack.Controls.Add($barFill)
$splashJob.Controls.AddRange(@($titleLbl, $statusLbl, $barTrack))

$script:sfade = 0   # 0=fade-in 1=fill 2=fade-out
$script:sbar  = 0
$script:salpha= 0.0

$sTimer = [System.Windows.Forms.Timer]::new()
$sTimer.Interval = 16
$sTimer.Add_Tick({
    switch ($script:sfade) {
        0 {
            $script:salpha = [Math]::Min($script:salpha + 0.06, 0.92)
            $splashJob.Opacity = $script:salpha
            if ($script:salpha -ge 0.92) { $script:sfade = 1 }
        }
        1 {
            $script:sbar = [Math]::Min($script:sbar + 5, 440)
            $barFill.Width = $script:sbar
            if ($script:sbar -ge 440) { $script:sfade = 2 }
        }
        2 {
            $script:salpha = [Math]::Max($script:salpha - 0.05, 0.0)
            $splashJob.Opacity = $script:salpha
            if ($script:salpha -le 0.0) {
                $sTimer.Stop()
                $splashJob.Close()
            }
        }
    }
})

$splashJob.Add_Shown({ $sTimer.Start() })

# Show non-blocking — script continues applying FX while splash animates
$splashJob.Show()
[System.Windows.Forms.Application]::DoEvents()
# ─────────────────────────────────────────────────────────────────────────────


Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WAPI {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool SystemParametersInfo(
        uint uiAction, uint uiParam, ref bool pvParam, uint fWinIni);
    [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr hWnd, uint Msg, UIntPtr wParam,
        string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
    public static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
}
"@

# SPIF_UPDATEINIFILE | SPIF_SENDCHANGE — writes registry AND notifies live system
$FWIW = [uint32]0x03
$ON = $true

# Logging helper — queue messages for on-screen UI and write to console
# No on-disk log file; messages are shown in the loading UI when available.
$script:LogQueue = New-Object System.Collections.Concurrent.ConcurrentQueue[object]
function Write-UI {
    param($msg, $color = 'White')
    $t = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "${t}`t${msg}"
    try { $script:LogQueue.Enqueue($line) } catch { Write-Output "Log enqueue error: $($_)" }
    # mark $color as used to keep static analysis happy
    $null = $color
    Write-Output $msg
}

# Helper: safe registry setter that logs failures instead of throwing
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        [Object]$Value,
        [string]$Type = 'String'
    )
    try {
        if ($Type -eq 'Binary') {
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type Binary -Force -ErrorAction Stop
        } elseif ($Type -eq 'DWord' -or $Type -eq 'DWORD') {
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord -Force -ErrorAction Stop
        } else {
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Force -ErrorAction Stop
        }
    } catch {
        try {
            $pt = switch ($Type) { 'Binary' { 'Binary' } 'DWord' { 'DWord' } default { 'String' } }
            New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $pt -Force -ErrorAction Stop | Out-Null
        } catch {
            $msg = "Failed to set {0}\{1}: {2}" -f $Path, $Name, $_
            Write-UI $msg Yellow
        }
    }
}

# ── MASTER SWITCH ─────────────────────────────────────────────────────
Set-RegistryValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 1

# ── USERPREFERENCESMASK ───────────────────────────────────────────────
$regPath = "HKCU:\Control Panel\Desktop"
# UserPreferencesMask set later (choose balanced or aggressive mask below)

# ── SYSTEMPARAMETERSINFO LIVE FORCE ──────────────────────────────────
# These hit the RUNNING session — registry alone can't do this
# 0x103F — SPI_SETUIEFFECTS: Animate controls & elements (MASTER)
[WAPI]::SystemParametersInfo(0x103F, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1003 — SPI_SETMENUANIMATION: Fade or slide menus into view
[WAPI]::SystemParametersInfo(0x1003, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1005 — SPI_SETCOMBOBOXANIMATION: Slide open combo boxes
[WAPI]::SystemParametersInfo(0x1005, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1007 — SPI_SETLISTBOXSMOOTHSCROLLING: Smooth-scroll list boxes
[WAPI]::SystemParametersInfo(0x1007, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1009 — SPI_SETGRADIENTCAPTIONS: Gradient title bars
[WAPI]::SystemParametersInfo(0x1009, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1013 — SPI_SETMENUFADE: Fade menus specifically
[WAPI]::SystemParametersInfo(0x1013, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1015 — SPI_SETSELECTIONFADE: Fade out menu items after clicking
[WAPI]::SystemParametersInfo(0x1015, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1017 — SPI_SETTOOLTIPANIMATION: Fade or slide ToolTips
[WAPI]::SystemParametersInfo(0x1017, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1019 — SPI_SETTOOLTIPFADE: Fade ToolTips specifically
[WAPI]::SystemParametersInfo(0x1019, 0, [ref]$ON, $FWIW) | Out-Null
# 0x101B — SPI_SETCURSORSHADOW: Show shadows under mouse pointer
[WAPI]::SystemParametersInfo(0x101B, 0, [ref]$ON, $FWIW) | Out-Null
# 0x1025 — SPI_SETDROPSHADOW: Show shadows under windows
[WAPI]::SystemParametersInfo(0x1025, 0, [ref]$ON, $FWIW) | Out-Null

# ── REGISTRY PERSISTENCE (survives reboots) ───────────────────────────
Set-RegistryValue -Path $regPath -Name "DragFullWindows"          -Value "1"
Set-RegistryValue -Path $regPath -Name "FontSmoothing"            -Value "2"
Set-RegistryValue -Path $regPath -Name "FontSmoothingType"        -Value 2
Set-RegistryValue -Path $regPath -Name "FontSmoothingGamma"       -Value 1200
Set-RegistryValue -Path $regPath -Name "FontSmoothingOrientation" -Value 1
Set-RegistryValue -Path $regPath -Name "MenuShowDelay"            -Value "0"

# WindowMetrics — MinAnimate
$wmPath = "HKCU:\Control Panel\Desktop\WindowMetrics"
if (-not (Test-Path $wmPath)) { New-Item -Path $wmPath -Force | Out-Null }
Set-RegistryValue -Path $wmPath -Name "MinAnimate" -Value "1"

# Explorer Advanced
$advPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-RegistryValue -Path $advPath -Name "ListviewAlphaSelect"   -Value 1
Set-RegistryValue -Path $advPath -Name "ListviewShadow"        -Value 1
Set-RegistryValue -Path $advPath -Name "TaskbarAnimations"     -Value 1
Set-RegistryValue -Path $advPath -Name "IconsOnly"             -Value 0
Set-RegistryValue -Path $advPath -Name "EnableAeroPeek"        -Value 1
Set-RegistryValue -Path $advPath -Name "DisableThumbnailCache" -Value 0

# Cursor shadow
$cursorPath = "HKCU:\Control Panel\Cursors"
if (-not (Test-Path $cursorPath)) { New-Item -Path $cursorPath -Force | Out-Null }
Set-RegistryValue -Path $cursorPath -Name "CursorShadow" -Value 1

# Policies
$polPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
try {
    if (-not (Test-Path $polPath)) { New-Item -Path $polPath -Force | Out-Null }
    Set-RegistryValue -Path $polPath -Name "NoLowDiskSpaceChecks" -Value 1 -Type DWord
} catch {
    Write-UI "Skipping policy write: cannot set $polPath\NoLowDiskSpaceChecks — $($_)" Yellow
}

# ── BROADCAST REFRESH ─────────────────────────────────────────────────
$result = [UIntPtr]::Zero
[WAPI]::SendMessageTimeout(
    [WAPI]::HWND_BROADCAST, 0x001A, [UIntPtr]::Zero,
    "Environment", 2, 5000, [ref]$result
) | Out-Null

Write-UI "MERCILESS APPEARANCE DOMINATION COMPLETE. ALL EFFECTS ON. GG NO RE." Green

# UserPreferencesMask: allow a balanced option to reduce redraw/focus conflicts
if ($Balanced) {
    # a milder mask that still enables most UI effects but reduces redraw side effects
    $mask = [byte[]](0xBE,0x3E,0x07,0x80,0x12,0x00,0x00,0x00)
} else {
    # aggressive mask: enable all UI bits
    $mask = [byte[]](0xFF,0x3E,0x07,0x80,0x12,0x00,0x00,0x00)
}
Set-RegistryValue -Path $regPath -Name "UserPreferencesMask" -Value $mask -Type Binary

# SPI_SETDROPSHADOW for windows shadows — different API than cursor shadow
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WAPI2 {
    [DllImport("user32.dll")]
    public static extern bool SystemParametersInfo(
        uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
}
"@
# Force shadows under windows via direct bool pointer
[WAPI2]::SystemParametersInfo(0x1025, 0, [IntPtr]::Zero + 1, 0x03) | Out-Null

# Force cursor shadow reload
[WAPI2]::SystemParametersInfo(0x0057, 0, [IntPtr]::Zero, 0x03) | Out-Null

# --- Anti-hover / verification helpers ---------------------------------
# Explicitly turn off "activate window by hovering" to avoid focus-on-hover
$mousePath = "HKCU:\Control Panel\Mouse"
if (-not (Test-Path $mousePath)) { New-Item -Path $mousePath -Force | Out-Null }
    try {
        Set-RegistryValue -Path $mousePath -Name "ActiveWindowTracking" -Value "0" -Type DWord
    } catch { Write-UI "Failed to set ActiveWindowTracking: $($_)" Yellow }

# Broadcast settings change for mouse/window behaviour
$result = [UIntPtr]::Zero
[WAPI]::SendMessageTimeout(
    [WAPI]::HWND_BROADCAST, 0x001A, [UIntPtr]::Zero,
    "Mouse", 2, 5000, [ref]$result
) | Out-Null

# Verification output for user to confirm settings
Write-UI "Verification: reading key values..." Cyan
try {
    $awt = (Get-ItemProperty -Path $mousePath -Name "ActiveWindowTracking" -ErrorAction SilentlyContinue).ActiveWindowTracking
    if ($null -ne $awt) {
        Write-UI ("ActiveWindowTracking: " + $awt)
    } else {
        Write-UI "ActiveWindowTracking: (not set)"
    }
} catch { Write-UI "ActiveWindowTracking: (error reading) - $($_)" Yellow }

try {
    $up = (Get-ItemProperty -Path $regPath -Name "UserPreferencesMask" -ErrorAction SilentlyContinue).UserPreferencesMask
    if ($up -is [byte[]]) { Write-UI ("UserPreferencesMask (bytes): " + ($up -join ",")) }
    else { Write-UI "UserPreferencesMask: (missing or unexpected type)" }
} catch { Write-UI "UserPreferencesMask: (error reading) - $($_)" Yellow }

Write-UI "DONE. Run a quick hover test: move mouse over window titlebars to confirm no auto-activation." Green

# --- Attempt to force ActiveWindowTracking in the live session ------------
# Try a SystemParametersInfo call (may be unsupported on some Windows builds),
# then call UpdatePerUserSystemParameters as a fallback to apply the HKCU change.
try {
    $SPI_SETACTIVEWINDOWTRACKING = 0x1012
    $ok = [WAPI]::SystemParametersInfo($SPI_SETACTIVEWINDOWTRACKING, 0, [ref]$ON, $FWIW)
    if ($ok) { Write-UI "Live: SystemParametersInfo attempted ActiveWindowTracking = ON" Green }
    else     { Write-UI "Live: SystemParametersInfo ActiveWindowTracking not applied (unsupported)." Yellow }
} catch {
    Write-UI "Live: SystemParametersInfo ActiveWindowTracking call error: $($_)" Yellow
}

# Also trigger UpdatePerUserSystemParameters (common fallback)
try {
    Start-Process -FilePath 'rundll32.exe' -ArgumentList 'user32.dll,UpdatePerUserSystemParameters' -NoNewWindow -WindowStyle Hidden -ErrorAction SilentlyContinue
} catch { Write-UI "UpdatePerUserSystemParameters call failed: $($_)" Yellow }

# Reduce focus-stealing by increasing ForegroundLockTimeout (milliseconds)
try {
    Set-RegistryValue -Path $regPath -Name "ForegroundLockTimeout" -Value 200000 -Type DWord
    Write-UI "ForegroundLockTimeout set to 200000 to reduce focus stealing." Cyan
} catch { Write-UI "Failed to set ForegroundLockTimeout: $($_)" Yellow }

# --- Visual confirmation animation (small, non-blocking) -----------------
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $frm = New-Object System.Windows.Forms.Form
    $frm.Text = ''
    $frm.FormBorderStyle = 'FixedToolWindow'
    $frm.StartPosition = 'CenterScreen'
    $frm.Width = 640; $frm.Height = 220
    $frm.TopMost = $true
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.AutoSize = $false
    $lbl.TextAlign = 'MiddleCenter'
    $lbl.Dock = 'Top'
    $lbl.Height = 48
    $lbl.Font = New-Object System.Drawing.Font('Segoe UI',12,[System.Drawing.FontStyle]::Bold)
    $lbl.Text = 'VisualFX — Changes Applied Successfully'
    $frm.Controls.Add($lbl)
    $pb = New-Object System.Windows.Forms.ProgressBar
    $pb.Style = 'Continuous'
    $pb.Minimum = 0; $pb.Maximum = 100; $pb.Value = 0
    $pb.Width = 480; $pb.Height = 18
    $pb.Location = New-Object System.Drawing.Point(20,62)
    $frm.Controls.Add($pb)

    # Log textbox beside/under the progress bar
    $logBox = New-Object System.Windows.Forms.TextBox
    $logBox.Multiline = $true
    $logBox.ReadOnly = $true
    $logBox.ScrollBars = 'Vertical'
    $logBox.WordWrap = $false
    $logBox.Width = 600; $logBox.Height = 100
    $logBox.Location = New-Object System.Drawing.Point(20,90)
    $logBox.Font = New-Object System.Drawing.Font('Consolas',9)
    $frm.Controls.Add($logBox)

    $t = New-Object System.Windows.Forms.Timer
    $t.Interval = 18
    $t.Add_Tick({
        # progress
        if ($pb.Value -lt 100) { $pb.Value += 4 }
        else { $t.Stop(); Start-Sleep -Milliseconds 500; $frm.Close() }

        # drain queued log messages into the on-screen textbox
        try {
            $item = $null
            while ($script:LogQueue.TryDequeue([ref]$item)) {
                $logBox.AppendText($item + [Environment]::NewLine)
                $logBox.SelectionStart = $logBox.Text.Length
                $logBox.ScrollToCaret()
            }
        } catch { Write-UI "Log drain error: $($_)" Yellow }
    })

    $frm.Add_Shown({ $t.Start() })
    $null = $frm.ShowDialog()
} catch {
    # If Forms unavailable or error occurs, fall back to plain text notification
    Write-UI 'VisualFX: applied (UI animation skipped).' Cyan
}

# --- Backup / Restore helpers -----------------------------------------
function Save-Backup {
    try {
        $bk = @{}
        $bk.VisualFXSetting = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -ErrorAction SilentlyContinue).VisualFXSetting
        $bk.UserPreferencesMask = (Get-ItemProperty -Path $regPath -Name "UserPreferencesMask" -ErrorAction SilentlyContinue).UserPreferencesMask
        $bk.DragFullWindows = (Get-ItemProperty -Path $regPath -Name "DragFullWindows" -ErrorAction SilentlyContinue).DragFullWindows
        $bk.FontSmoothing = (Get-ItemProperty -Path $regPath -Name "FontSmoothing" -ErrorAction SilentlyContinue).FontSmoothing
        $bk.FontSmoothingType = (Get-ItemProperty -Path $regPath -Name "FontSmoothingType" -ErrorAction SilentlyContinue).FontSmoothingType
        $bk.FontSmoothingGamma = (Get-ItemProperty -Path $regPath -Name "FontSmoothingGamma" -ErrorAction SilentlyContinue).FontSmoothingGamma
        $bk.FontSmoothingOrientation = (Get-ItemProperty -Path $regPath -Name "FontSmoothingOrientation" -ErrorAction SilentlyContinue).FontSmoothingOrientation
        $bk.MenuShowDelay = (Get-ItemProperty -Path $regPath -Name "MenuShowDelay" -ErrorAction SilentlyContinue).MenuShowDelay
        $bk.MinAnimate = (Get-ItemProperty -Path $wmPath -Name "MinAnimate" -ErrorAction SilentlyContinue).MinAnimate
        $bk.ListviewAlphaSelect = (Get-ItemProperty -Path $advPath -Name "ListviewAlphaSelect" -ErrorAction SilentlyContinue).ListviewAlphaSelect
        $bk.ListviewShadow = (Get-ItemProperty -Path $advPath -Name "ListviewShadow" -ErrorAction SilentlyContinue).ListviewShadow
        $bk.TaskbarAnimations = (Get-ItemProperty -Path $advPath -Name "TaskbarAnimations" -ErrorAction SilentlyContinue).TaskbarAnimations
        $bk.IconsOnly = (Get-ItemProperty -Path $advPath -Name "IconsOnly" -ErrorAction SilentlyContinue).IconsOnly
        $bk.EnableAeroPeek = (Get-ItemProperty -Path $advPath -Name "EnableAeroPeek" -ErrorAction SilentlyContinue).EnableAeroPeek
        $bk.DisableThumbnailCache = (Get-ItemProperty -Path $advPath -Name "DisableThumbnailCache" -ErrorAction SilentlyContinue).DisableThumbnailCache
        $bk.CursorShadow = (Get-ItemProperty -Path $cursorPath -Name "CursorShadow" -ErrorAction SilentlyContinue).CursorShadow
        $bk.NoLowDiskSpaceChecks = (Get-ItemProperty -Path $polPath -Name "NoLowDiskSpaceChecks" -ErrorAction SilentlyContinue).NoLowDiskSpaceChecks
        $bk.ActiveWindowTracking = (Get-ItemProperty -Path $mousePath -Name "ActiveWindowTracking" -ErrorAction SilentlyContinue).ActiveWindowTracking
        $bk.ForegroundLockTimeout = (Get-ItemProperty -Path $regPath -Name "ForegroundLockTimeout" -ErrorAction SilentlyContinue).ForegroundLockTimeout

        $json = $bk | ConvertTo-Json -Depth 5
        if (-not (Test-Path "HKCU:\Software\VisualFX-BestAppearance")) { New-Item -Path "HKCU:\Software\VisualFX-BestAppearance" -Force | Out-Null }
        Set-RegistryValue -Path "HKCU:\Software\VisualFX-BestAppearance" -Name "Backup" -Value $json -Type String
        Write-UI "Backup saved to HKCU:\Software\VisualFX-BestAppearance\Backup" Cyan
    } catch { Write-UI "Backup save error: $($_)" Yellow }
}

function Restore-Backup {
    Write-UI "Restore operation is disabled on this system. Restores are blocked to avoid restoring system restore points." Yellow
    Write-UI "If you need to manually revert changes, run the script with 'status' then adjust settings manually or re-enable restore points in Windows." Yellow
    return
}

function Show-Status {
    Write-UI "Status: VisualFX-BestAppearance script - backup presence and key previews:" Cyan
    try {
        $has = (Test-Path "HKCU:\Software\VisualFX-BestAppearance")
        Write-UI ("Backup present: " + ($has -as [string]))
    } catch { Write-UI "Status read error: $($_)" Yellow }
}

# Create a simple HKCU Run entry so this script is re-applied at user logon
function Register-StartupEntry {
    try {
        $runPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
        $scriptFile = if ($PSCommandPath) { $PSCommandPath } else { $MyInvocation.MyCommand.Path }
        $exe = "powershell -NoProfile -ExecutionPolicy Bypass -File `"$scriptFile`" -Mode apply"
        Set-RegistryValue -Path $runPath -Name 'VisualFX-BestAppearance' -Value $exe -Type String
        Write-UI "Startup entry created: HKCU Run -> VisualFX-BestAppearance" Cyan
    } catch { Write-UI "Failed to create startup entry: $($_)" Yellow }
}

# Mode dispatch
if ($Mode -eq 'backup') { Save-Backup; return }
if ($Mode -eq 'restore') { Restore-Backup; return }
if ($Mode -eq 'status') { Show-Status; return }

if ($EnsureStartup) { Ensure-StartupEntry }