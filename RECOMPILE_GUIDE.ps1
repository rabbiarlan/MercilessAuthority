# ═══════════════════════════════════════════════════════════════════
# MERCILESS AUTHORITY — ps2exe RECOMPILE GUIDE v2.21
# Run every step ONE BY ONE. Never chain commands. Never skip steps.
# Designed as an intentionally strict, high-visibility battery reminder system.
# ───────────────────────────────────────────────────────────────────
# Author  : Rabbi S. Arlan
# Machine : HP ProBook mt22 — Celeron 5205U, 8GB DDR4-2400 RAM, 128GB M.2 SATA SSD
# OS      : Windows 11 25H2 Pro 26200.8328 (dual-booted with Linux Mint XFCE 22.3 Zena)
# ═══════════════════════════════════════════════════════════════════
#
# ── C:\Scripts FILE MANIFEST ─────────────────────────────────────────────
# Every file that belongs in Scripts folder:
#   Archive\                      ← retired scripts folder
#     Archive\Recompile.ps1       ← legacy terminal recompile (retired, kept as reference)
#     Archive\MercyPopup_v3.11_RETIRED.ps1
#   BatteryMercy.ps1              ← main source script (edit this)
#   BatteryMercy_TestRun.ps1      ← test all 3 popup modes safely
#   BootSplash.ps1                ← animated boot splash on logon
#   CLICK_TO_RECOMPILE.vbs        ← double-click to run RecompileSplash
#   LaunchBattery.vbs             ← boot launcher (Task Scheduler only)
#   MercilessAuthority.exe        ← compiled output (never edit directly)
#   RECOMPILE_GUIDE.ps1           ← this file
#   RecompileSplash.ps1           ← animated WinForms recompile UI
#   VisualFX-BestAppearance.ps1   ← forces best visual effects on boot
#
# QUICK RECOMPILE WORKFLOW (after editing BatteryMercy.ps1):
#   Double-click CLICK_TO_RECOMPILE.vbs → animated window does everything.
#
# TESTRUN COMMANDS (add -ExecutionPolicy Bypass — required for unsigned .ps1):
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario low
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario high
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario dead
#   (Deadman's switch scenario will NOT call Stop-Computer — safe to test)
#
# TASK SCHEDULER STATUS CODES — these are NOT errors (normal):
#   0x0        = Last run completed successfully
#   0x41301    = Task is currently running right now
#   0x41303    = Task has not yet run (clears after first logon)
#   0x41304    = No future scheduled runs (one-shot task, not yours)
#   0x41325    = New instance queued/blocked — one already running
#               (harmless here — means logon fired twice, e.g. sleep resume)
#   0x8004130F = No new instance started — "Do not start a new instance"
#               policy active and one is already running; harmless for this setup
#
# TASK SCHEDULER STATUS CODES — these ARE errors (action required):
#   0x1        = Task launched but LaunchBattery.vbs or the exe exited with error
#                FIX: Check all paths inside LaunchBattery.vbs are correct
#   0x2        = File not found — wscript.exe can't locate the .vbs
#                FIX: Verify $PSScriptRoot\LaunchBattery.vbs actually exists
#   0x41302    = Task is disabled
#                FIX: Task Scheduler → right-click task → Enable
#   0x41306    = Task TERMINATED — time limit killed it after 3 days ← DANGEROUS
#                FIX: Task → Properties → Settings tab →
#                     UNTICK "Stop the task if it runs longer than" — CRITICAL
#                     Without this fix BatteryMercy silently stops every 72 hours
#   0x80041315 = Task Engine is shutting down — Windows killed the service
#                FIX: Usually happens during OS updates or rapid reboots.
#                     Manually right-click → Run the task to restore monitor.
#   0x80070001 = Invalid function — malformed action argument
#                FIX: Confirm the task action argument is EXACTLY:
#                     //B "$PSScriptRoot\LaunchBattery.vbs"
#                     (the //B flag must be present and before the path)
#   0x80070002 = System cannot find the file — (Extended) missing dependency
#                or script path in task action is broken
#                FIX: Task → Properties → Actions tab → verify:
#                     Program: wscript.exe
#                     Arguments: //B "$PSScriptRoot\LaunchBattery.vbs"
#                     Verify "$PSScriptRoot\LaunchBattery.vbs" exists AND that the
#                     VBS script points to "$PSScriptRoot\MercilessAuthority.exe" correctly.
#   0x80070003 = Path not found — the entire folder containing the script is missing
#                FIX: Task → Properties → Actions tab → ensure "Start in (optional)"
#                     is set to C:\Scripts (without quotes) and that the
#                     C:\Scripts folder actually exists on your drive.
#   0x80070004 = The system cannot open the file — internal migration/locking error
#                FIX: Usually occurs if the .exe is locked by an existing process
#                     or Antivirus. Kill 'MercilessAuthority.exe' in Task Manager
#                     before recompiling or re-running the task.
#   0x80070005 = Access denied — missing "Run with highest privileges" ← DANGEROUS
#                FIX: Task → Properties → General → tick "Run with highest privileges"
#                     WITHOUT this: Stop-Computer -Force silently does nothing at DEAD
#                     mode — battery dies at 10% with PC still fully on. Catastrophic.
#   0x800700B7 = Already running/Object exists — Global Mutex conflict
#                FIX: A "ghost" instance of MercilessAuthority.exe is hung.
#                     Open Task Manager → Details → Kill 'MercilessAuthority.exe'.
#                     This happens if the script crashes but the Mutex handle
#                     isn't released, preventing the next logon launch.
#   0x8007010B = Directory name invalid — "Start In" field contains quotes
#                FIX: Task → Properties → Actions → Edit. Ensure the "Start in"
#                     box contains C:\Scripts (ABSOLUTELY NO QUOTES allowed here).
#   0x800700C1 = "Not a valid Win32 application"
#                FIX: You compiled as 32-bit on a 64-bit OS.
#                     Ensure you are running "PowerShell 7 (x64)" specifically
#                     when running the Invoke-ps2exe command.
#   0x800704DD = Task won't run — "Run only when user is logged on" is unchecked
#                FIX: Task → Properties → General → tick "Run only when user is logged on"
# ───────────────────────────────────────────────────────────────────


# ── CRITICAL FIRST STEP — Navigate to your scripts folder ──────────
# $PSScriptRoot is EMPTY when running commands directly in the terminal.
# You MUST cd to your scripts folder first or paths will break.
# Run this BEFORE anything else:

Set-Location "C:\path\to\your\MercilessAuthority\folder"    # Change to wherever YOUR files are

# Then verify you are in the right place:
Get-ChildItem BatteryMercy.ps1   # Must return the file. If not, check your path.
# ───────────────────────────────────────────────────────────────────
# ── STEP 1 — KILL the running MercilessAuthority.exe ───────────────
# The Global Mutex file-locks the .exe while it runs.
# You CANNOT overwrite it while it's alive. Kill it first.
# Open Task Manager → Details tab → find MercilessAuthority.exe → End Task
# OR run this in PowerShell 7 (pwsh) as Administrator:

Stop-Process -Name "MercilessAuthority" -Force -ErrorAction SilentlyContinue

# Wait 2 seconds after running the above before going to Step 2.
# ───────────────────────────────────────────────────────────────────


# ── STEP 2 — VERIFY ps2exe is installed ────────────────────────────
# Run this in PowerShell 7 (pwsh) as Administrator:

Get-Command ps2exe -ErrorAction SilentlyContinue

# If it returns nothing, install it first:
Install-Module -Name ps2exe -Scope CurrentUser -Force

# ───────────────────────────────────────────────────────────────────


# ── STEP 3 — VERIFY the icon file exists ───────────────────────────
# Run this SEPARATELY:

Test-Path ".\holycleanAPP.ico"

# Must return True. If False, the icon path is wrong — check spelling.
# ───────────────────────────────────────────────────────────────────


# ── STEP 4 — VERIFY the source script exists ───────────────────────

Test-Path ".\BatteryMercy.ps1"

# Must return True.
# ───────────────────────────────────────────────────────────────────


# ── STEP 5 — THE COMPILE COMMAND ───────────────────────────────────
# Run this ALONE in PowerShell 7 (pwsh) as Administrator.
# Do NOT chain it with && or ; to anything else.
# Copy-paste this entire block as-is:

Invoke-ps2exe `
    -inputFile   ".\BatteryMercy.ps1" `
    -outputFile  ".\MercilessAuthority.exe" `
    -iconFile    ".\holycleanAPP.ico" `
    -title       "MERCILESS AUTHORITY" `
    -description "Totalitarian Battery Monitor — No Mercy, No Remorse" `
    -product     "BatteryMercy System" `
    -company     "Rabbi S. Arlan" `
    -copyright   "2026 Rabbi S. Arlan. All rights reserved." `
    -version     "2.21.0.0" `
    -noConsole `
    -noOutput `
    -noError

#Or in this way when you copypaste it, it returns as reversed upside-down order:

Invoke-ps2exe -inputFile ".\BatteryMercy.ps1" -outputFile ".\MercilessAuthority.exe" -iconFile ".\holycleanAPP.ico" -title "MERCILESS AUTHORITY" -description "Totalitarian Battery Monitor - No Mercy, No Remorse" -product "BatteryMercy System" -company "Rabbi S. Arlan" -copyright "2026 Rabbi S. Arlan. All rights reserved." -version "2.21.0.0" -noConsole -noOutput -noError

# WHAT EACH FLAG DOES:
# -title       → "Description" column in Task Manager (Details tab) — shows "MERCILESS AUTHORITY"
# -description → File Description in Properties → Details tab
# -product     → Product Name in Properties → Details tab
# -company     → Company Name in Properties → Details tab
# -copyright   → Copyright in Properties → Details tab
# -version     → File Version shown in Properties → Details tab (must be X.X.X.X format)
# -noConsole   → No black CMD/console window ever appears
# -noOutput    → Suppresses Write-Host stdout from appearing
# -noError     → Suppresses error stream output
# -iconFile    → The .ico file baked into the .exe so it shows your cute icon everywhere
#
# NOTE: -sta flag is intentionally EXCLUDED.
# ps2exe v0.5.0.33's -sta is unreliable and was confirmed broken.
# STA threading is already handled correctly inside BatteryMercy.ps1
# via the Runspace ApartmentState = STA approach. Don't add -sta.
#
# Focus Alert Mode temporarily keeps the warning in the foreground until acknowledged.
# ───────────────────────────────────────────────────────────────────


# ── STEP 6 — VERIFY the .exe was created ───────────────────────────

Test-Path ".\MercilessAuthority.exe"

# Must return True. If False, go back and check Step 5 for red error text.
# ───────────────────────────────────────────────────────────────────


# ── STEP 7 — BITDEFENDER EXCLUSION (do this before test run!) ──────
# MercilessAuthority.exe uses WH_KEYBOARD_LL low-level keyboard hook,
# SetWindowsHookEx, global window focus stealing, and Stop-Computer -Force.
# Bitdefender Free flags ALL of these as malware behavior — silently
# quarantines the .exe with ZERO popup warning. You'd never know why it stopped.
# The fix: exclude the entire C:\Scripts folder so every recompile is
# automatically covered without re-adding exclusions each time.
#
# GUI ONLY — Bitdefender Free has no PowerShell cmdlets:
#   Bitdefender → Protection → Antivirus → Settings → Exclusions
#   → Add Exclusion → type:  C:\Scripts  → Confirm
#
# Do this ONCE. Never need to redo after future recompiles.
#
# Some security software may flag behavior such as keyboard hooks or fullscreen focus control.
# Review the source code and create exceptions only if you fully trust and understand the program.
# ───────────────────────────────────────────────────────────────────


# ── STEP 8 — TEST RUN (manual, not via Task Scheduler yet) ─────────
# Run this SEPARATELY to confirm it launches with no errors:

Start-Process ".\MercilessAuthority.exe"

# Then check Task Manager → Details tab.
# You should see:   MercilessAuthority.exe | MERCILESS AUTHORITY
# Under the "Description" column in Details tab.
#
# To test all 3 popup modes manually (run each separately in pwsh as Admin):
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario low
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario high
#   pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario dead
# NOTE: Deadman's switch scenario will NOT call Stop-Computer in TestRun — safe.
# ───────────────────────────────────────────────────────────────────


# ── STEP 9 — CONFIRM Task Scheduler is still set up ────────────────
# Your Task Scheduler already runs LaunchBattery.vbs on logon.
# LaunchBattery.vbs kills + relaunches MercilessAuthority.exe automatically.
# So after recompile you DON'T need to touch Task Scheduler at all.
#
# But to verify it's still there, run:

Get-ScheduledTask | Where-Object { $_.TaskName -like "*Battery*" -or $_.TaskName -like "*Launch*" -or $_.TaskName -like "*Mercy*" }

# Should return your logon task. If it returns nothing, re-register it:
# (Only if missing — don't run this if the task already exists)
#
# $action  = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "//B ""$PSScriptRoot\LaunchBattery.vbs"""
# $trigger = New-ScheduledTaskTrigger -AtLogOn
# $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0
# Register-ScheduledTask -TaskName "MercilessBatteryMonitor" -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force
# ───────────────────────────────────────────────────────────────────


# ── STEP 10 — VERIFY Task Scheduler "Run with highest privileges" ───
# WITHOUT this: Stop-Computer -Force inside the deadman's switch has no
# Admin rights and silently fails. Countdown hits zero → nothing happens.
# Battery dies at 10% with the PC still fully on. Catastrophic.
#
# GUI ONLY — must be verified in Task Scheduler:
#   Task Scheduler → find MercilessBatteryMonitor → Right-click → Properties
#   → General tab → Security options:
#     ✅ "Run with highest privileges" — MUST be checked
#     ✅ "Run only when user is logged on"
#   → Settings tab:
#     ❌ UNTICK "Stop the task if it runs longer than"
#        Windows defaults this to 3 days — silently kills LaunchBattery.vbs
#        after 72 hours and BatteryMercy stops running forever.
#     ✅ "If the task is already running, then the following rule applies:"
#        Set to: "Do not start a new instance"
#        (LaunchBattery.vbs already kills and cleanly relaunches the exe
#        at every logon — a new instance mid-session is never needed and
#        would fight the Global Mutex, causing a dirty hung state.
#        This matches your confirmed setting: MultipleInstances=IgnoreNew)
#   → Configure for: Windows 10 (works fine on Win11, don't change)
#
# NOTE: Designed for low-latency alerts
#       Reliable single-instance enforcement using mutex
#       Possible fast popup response timing
# ───────────────────────────────────────────────────────────────────


# ── COMMON ERRORS AND FIXES ─────────────────────────────────────────
#
# ERROR: "The process cannot access the file because it is being used"
# FIX:   Step 1 failed. Kill MercilessAuthority.exe in Task Manager first.
#
# ERROR: "Cannot find module ps2exe" or "Invoke-ps2exe not found"
# FIX:   Run: Install-Module -Name ps2exe -Scope CurrentUser -Force
#        Then close and reopen PowerShell 7 as Admin.
#
# ERROR: Icon-related warning but compile still succeeds
# FIX:   Ignore it — it's a non-fatal warning. Verify with Test-Path first.
#
# ERROR: Red errors about Add-Type or C# syntax
# FIX:   The script itself has a bug. Do NOT recompile broken scripts.
#        Fix BatteryMercy.ps1 first, test it in PowerShell 7 directly:
#        pwsh -ExecutionPolicy Bypass -File "$PSScriptRoot\BatteryMercy.ps1"
#
# ERROR: "version is not in the correct format"
# FIX:   Version must be exactly X.X.X.X — four numbers. "2.21" won't work.
#        Use "2.21.0.0" exactly as written above.
#
# ERROR: Code: 800A0401 from Script C:\Scripts\CLICK_TO_RECOMPILE.vbs
# FIX:   The code might've added or written something else
#        internally in the source code that made it not work.
#        Try to check the original code vs your current setup
#        while following the error guidelines given.
#
# ERROR: Keyboard is laggy or Win-Key remains blocked after a crash
# FIX:   The Low-Level Hook wasn't unhooked properly on crash.
#        BatteryMercy.ps1 already calls [LockAPI2]::UninstallWinHook()
#        in its cleanup section — but a hard crash bypasses cleanup.
#        Simply restart Explorer.exe in Task Manager (File → Run → explorer.exe)
#        or reboot. The hook dies with the process on reboot automatically.
#
# ERROR: Task shows 0x0 but nothing happens (Script won't start)
# FIX:   Windows Update may have reset your Execution Policy.
#        Run this as Admin: Set-ExecutionPolicy RemoteSigned -Force
#        (RemoteSigned allows local unsigned scripts like BatteryMercy.ps1
#        while still blocking unsigned scripts downloaded from the internet.
#        Never use Unrestricted — it disables ALL script security checks.)
#
# ERROR: "Icon file not found" even though you see it on Desktop
# FIX:   OneDrive "un-downloaded" the icon. Right-click the .ico file
#        and select "Always keep on this device" before recompiling.
#
# ERROR: Memory usage is too low (< 5.0 MB) in Task Manager
# FIX:   The PowerShell engine inside the .exe has crashed or failed to
#        initialize the Runspace. This is a "Zombie Process."
#        Kill 'MercilessAuthority.exe' and check BatteryMercy.ps1 for
#        syntax errors by running the .ps1 directly in pwsh first.
#        or double-click the CLICK_TO_RECOMPILE.vbs file to recompile.
#        But if it works after the popup message but it stays like <5.0MB
#        afterwards then it is perfectly fine and can run automatically normally.
#
# ERROR: If this is possible you ended up with this type of error...
# FIX:   Do not use ps2exe.core, instead only use the standard ps2exe.
#        I was too late and ended up building with the standard legacy ps2exe
#        without knowing there is a fully-fledged modern ps2exe.core full support
#        with Windows PowerShell 7.1+ scripts — But don't worry,
#        it fully supports this currently and working properly in standard ps2exe
#
# ───────────────────────────────────────────────────────────────────


# ── WHERE TASK MANAGER SHOWS YOUR METADATA ─────────────────────────
#
# Task Manager → Processes tab → "Name" column:
#   Shows the raw exe filename: MercilessAuthority.exe
#   (Windows uses the file name here, not the title — this is normal)
#
# Task Manager → Details tab → "Description" column:
#   Shows your -title value: MERCILESS AUTHORITY  ← THIS IS THE ONE
#
# File Explorer → Right-click MERCILESS AUTHORITY or MercilessAuthority.exe → Properties → Details tab:
#   File description : Totalitarian Battery Monitor - No Mercy, No Remorse
#   Product name     : BatteryMercy System
#   Company          : Rabbi S. Arlan
#   File version     : 2.21.0.0
#   Copyright        : 2026 Rabbi S. Arlan. All rights reserved.
#
# Task Manager → Processes tab → "Memory" column:
#   HEALTHY  : ~24.0 MB to 50.0 MB (indicates active PS Runspace/WinForms or something like that)
#   CRITICAL : < 5.0 MB (indicates a "Zombie" crash — kill and restart or not if it perfectly runs fine after popup message)
# ───────────────────────────────────────────────────────────────────
