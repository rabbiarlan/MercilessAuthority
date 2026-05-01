# ⚡ MercilessAuthority ⚡ — Totalitarian Battery Monitor   
## *💚🔋✅ No mercy. No remorse. No dead batteries. 🚫🪫❌*   
### *The Most Merciless Totalitarian Authoritarian Fullscreen Battery Monitor I've ever made for fun!*   
#### *Only for Windows Laptops that has functioning batteries!*

**“This tool is apparently a Super high-attention very aggressive strict focus  
mode notifier battery percentage-management alert system that's intentionally  
very intrusive by design — actively interrupts and reinforces awareness of battery  
status to prevent missed low-power situations. It does not support in any other  
forms of operating systems or in any other forms of legacy operating systems.  
Only in Windows 10 and in Windows 11. Use only if you understand its behavior.”**

> Built by the Author: **Rabbi S. Arlan**; a 16 years old Computer Science & Engineering enthusiast from the Philippines 🇵🇭  
> God first, before technology. — Matthew 6:33  
> From **v1.0** (basic popup MessageBox) to **v2.21** (fullscreen lockout with kernel32 P/Invoke) — built entirely from scratch.

---

# ⚠️READ THIS FIRST BEFORE USE AT YOUR OWN RISK —Why It Looks Like Malware‼️ *(But It Isn't)*

This app blocks `Alt+Tab`, the `Win key`, `Ctrl+Esc`, and many others till it goes fullscreen unclosable once it activates.

It forces you to click on the Red button that says: **“YES pwease, Master~!”** *(I'm sorry if you have to go through this bro...🙏)*

**That's intentional. Making you suffer while manually maintaining your battery duration and health drastically.**

### Here's why:

If your laptop **dies at approximately less than 10%** because of that single literal tiny toast notification was very easy to ignore, you will lose most certainly almost have unsaved work and the effects are prone to be irreversible. MercilessAuthority App fixes this issue and makes the alert **VERY VERY IMPOSSIBLE TO IGNORE** with also a mode to a literal **60 second countdown** if you try to deplete your battery to **ZERO** — you must literally acknowledge it like acknowledging God before you can continue!   
Task Manager always remains accessible as an emergency escape. *(If that's possible for you, but from my experience, i tried `Ctrl+Alt+Del` after it initiated, welp it didn't work, then this keyboard shortcut is also included in the blocked lists too)*

The source code is *fully publicly explicitly open.* You can read every single line one by one line by line precisely carefully before running anything in some systems or in yours.

**This is not malware.**  
It is a very aggressively opinionated battery management software that I have created just for fun.

So expect getting this reaction from yourself: *“Why is this app literally controlling my system like this?”* — You probably.

**“Totalitarian battery monitor inspired by The North Korean's Totalitarian Authoritarian Control.”**

---

## 🔋 So, What It Does and Do?

Monitors your laptop battery every 5 seconds using Windows kernel32 `GetSystemPowerStatus()` — the same API your taskbar uses, zero WMI lag or inaccuracy.

Three alert modes:

| Mode | Trigger | What Happens |
|---|---|---|
| **LOW** | ≤35%,unplugged, per-% drop | Fullscreen popup, sad descending minor beeps, yellow warning icon |
| **HIGH** | ≥85%, plugged in, per-% rise | Fullscreen popup, happy ascending major beeps, green checkmark icon |
| **DEAD** | ≤10%, unplugged | **60-second countdown popup**, ominous creepy beeps, force shutdown if still unplugged after countdown |

---

## 🛠️ Advanced Technical Architecture

For the developers or some curious geeks like me who want to know what's actually happening under the hood:

- **kernel32 P/Invoke** — reads `GetSystemPowerStatus()` directly, not WMI. Exact taskbar accuracy.
- **Global Mutex** (`Global\BatteryMercyTotalitarian`) — bulletproof single-instance enforcement
- **PS Runspace on STA thread** — popup runs inside the same process, zero cold-start delay
- **WH_KEYBOARD_LL low-level hook** — blocks Win key at kernel input level
- **RegisterHotKey** — blocks Alt+Tab, Ctrl+Esc, and other escape routes
- **Double-buffered Panel** with `WM_ERASEBKGND` suppressed — zero-flicker DEAD countdown
- **TableLayoutPanel** — DPI-proof at 150% scaling on 1080p displays
- **Wallpaper slice repaint** on all custom labels — no GDI ghost text artifacts
- **Beep fires on `Add_Shown`** — exact millisecond the form becomes visible, zero audio gap
- **And many more others** — that isn't included here!

---

## 📋 Requirements and ✅ Compatibility

- PowerShell 7.5.4+ (`pwsh.exe`) — [Download here (PowerShell 7.5.4+)](https://github.com/PowerShell/PowerShell/releases)

| | |
|---|---|
| **OS** | Windows 10 / 11 (`64-bit`) |
| **Architecture** | x64 primary. ARM64 via Windows emulation layer. |
| **Runtime** | None required — MercilessAuthority.exe is self-contained |
| **PowerShell** | Only needed if recompiling from source (`PS 7.5.4+`) |
| **Recompile tool** | Standard ps2exe v0.5.0.33 by MScholtes (`not ps2exe.core`) |
| **Device** | A laptop with a battery (obviously💀🥀🥶🙏) Or if you're in a mobile phone running Windows *"dayumnn that's impressive!"* |

> ### **Notes:**  
> Windows Defender may flag this on first run due to keyboard hooks   
> and force-shutdown behaviour. This is a very false positive. Source code is fully   
> open for you to read — try reading `BatteryMercy.ps1` and `RECOMPILE_GUIDE.ps1`  
> carefully to clarify and quadruple verify exactly what it runs.  
> And if you have any kind of AV software, add this to exclusions to  
> further prevent from not working properly. *(Or not if you don't want to)*  
> 👉 And also no silent background persistence — all behavior is user-visible at runtime.

To **recompile** from source only, download the given files from this repository and this:
- Standard PS2EXE (`not PS2EXE.Core`) — [ps2exe v0.5.0.33 by MScholtes](https://github.com/MScholtes/PS2EXE)

Then open **Windows PowerShell 7.5.4+ as `Administrator`** and run this  
**CRITICAL STEP** by typing `Set-Location "C:\path\to\MercilessBattery"` first in order to work or else error.

After that, copy this:
```pwsh
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
```

Or this if returns reversed:
```pwsh
Invoke-ps2exe -inputFile ".\BatteryMercy.ps1" -outputFile ".\MercilessAuthority.exe" -iconFile ".\holycleanAPP.ico" -title "MERCILESS AUTHORITY" -description "Totalitarian Battery Monitor — No Mercy, No Remorse" -product "BatteryMercy System" -company "Rabbi S. Arlan" -copyright "2026 Rabbi S. Arlan. All rights reserved." -version "2.21.0.0" -noConsole -noOutput -noError
```

But there's already a `CLICK_TO_RECOMPILE.ps1` script!  
You just have to run it and enjoy than doing all that complicated steps!

> The pre-built `.exe` works on any Windows 10/11 machine.  
> No PowerShell. No .NET install. No dependencies. Just run it.

---

## 🛑️ BEFORE YOU RUN THIS — ✋️ READ THIS EXPECTATION CLEARLY

### This program WILL:
- Take over your entire screen during important battery events when you reach
  > ≤35%,unplugged, per-% drop  
  > ≥85%, plugged in, per-% rise reaching critical levels  
  > Below 10%
- Block normal navigation shortcuts temporarily
- Force you to acknowledge every single warnings manually
- Interrupt what you're doing if battery becomes severely critical
- And force you to click on the Red button that exactly says **"YES pwease, Master~!"**

This program will NOT:
- Harm your saved files or delete data
- Install itself into system folders silently
- Run in background without visible UI
- Collect or send any user personal data
- Do anything worrying or concerning.

👉 If you are expecting a *very normal battery indicator app* — **this is NOT it or NOT for YOU.**  
👉 If you are okay with **Super Aggressive Interruptive Totalitarian-Based design**  
then proceed to the next section on how to install and how to use it.

---

## 🚀 Installation and ✍️ How-To-Use it

1. Download or clone this entire repository
2. Place all files in the **same folder** *(e.g. `C:\MercilessBattery\` or anywhere you want)*
3. Place `holycleanAPP.ico` in the same folder if it's not included.
4. Right-click or Double-click `CLICK_TO_RECOMPILE.vbs` → Run — this compiles `MercilessAuthority.exe`
5. Search up `Task Scheduler` in Startup Menu or in Search Bar in Taskbar
6. Set up Task Scheduler to run `LaunchBattery.vbs` at logon:
   - Open Task Scheduler → Create Basic Task
   - Trigger: At log on
   - Action: Start a program → `wscript.exe`
   - Arguments: `"C:\path\to\LaunchBattery.vbs"`

Or just double-click `LaunchBattery.vbs` to run it manually right now.

> If UI appears too small on some certain displays like 4K displays:  right-click  "MercilessAuthority.exe" → Properties → Compatibility →
> Change high DPI settings → Override high DPI scaling behaviour → Application

---

## 🚪️🏃️ EMERGENCY EXITS ON HOW TO STOP THIS

If you ever get stuck or want to immediately stop `MercilessAuthority.exe` as an emergency:

### Option 1 — Task Manager (Recommended, *if it works*)
1. Press `Ctrl + Shift + Esc`
2. Find **MERCILESS AUTHORITY** (or search `MercilessAuthority.exe`)
3. Click **End Task** or Right-Click it and press **End the process**

### Option 2 — Secure Screen *(if it still works)*
1. Press `Ctrl + Alt + Delete`
2. Open **Task Manager**
3. Find **MERCILESS AUTHORITY** (or search `MercilessAuthority.exe`)
4. Click **End Task** or Right-Click it and press **End the process**

But me? This is the only thing that **works** when i tried both, which is:

### Option 3 — Force Shutdown (One Last Resort)
Hold the **power button** until your laptop turns off.

> **⚠️This program is intentionally aggressive.⚠️**  
> You are ALWAYS responsible for having a way to stop it when this stuff happens...  
> And if you wondering why other escape routes don't work? Your only choice is this:  
> Click on the Red button that exactly says,  
> **"YES pwease, Master~!"** and the fullscreen will disappear instantly.

If you are not comfortable with fully strictly forced fullscreen behavior...  
**DO NOT RUN THIS PROGRAM AND TRY THE TEST COMMANDS BY MOVING TO THE NEXT SECTION BELOW INSTEAD.**

---

## 🧪 Safe Test Runs 💚️

Don't want the force-shutdown behaviour while testing? Run `BatteryMercy_TestRun.ps1` instead.  
It fires the popups with real battery data but **never calls `Stop-Computer`**.  
Safe to run any time.

```pwsh
pwsh -ExecutionPolicy Bypass -File BatteryMercy_TestRun.ps1
```

Or these other optional harmless test run commands to try it out right now!
```pwsh
pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario low
```
```pwsh
pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario high
```
```pwsh
pwsh -ExecutionPolicy Bypass -STA -File ".\BatteryMercy_TestRun.ps1" -Scenario dead
```
You have to type `Set-Location "C:\path\to\MercilessBattery"` first in order to work or else error.

---

## 📁 File Structure inside Scripts Folder

```
MercilessAuthority\             ← Could be any name you want, mine is called "Scripts"
│        *(These "Archive" and "Pictures of what it looks like" folders
│          is very optional to keep. My set default location is "C:\Scripts")
├── Archive\
│   ├──MercyPopup_v3.11_RETIRED.ps1
│   └──Recompile.ps1
├── Pictures of what it looks like\
│   ├──And this intimidating warning.png
│   ├──It also shows your current background too.png
│   └──Now you can't ignore these!.png
├── BatteryMercy.ps1            ← Main source (compile this)
├── BatteryMercy_TestRun.ps1    ← Safe test, no shutdown
├── BootSplash.ps1              ← Boot splash screen
├── RecompileSplash.ps1         ← Splash shown during recompile
├── CLICK_TO_RECOMPILE.vbs      ← Double-click to recompile
├── LaunchBattery.vbs           ← Launcher (use in Task Scheduler)
├── RECOMPILE_GUIDE.ps1         ← Detailed recompile instructions
├── VisualFX-BestAppearance.ps1 ← Sets Windows visual FX on startup (this is very optional)
├── LICENSE                     ← MIT License
├── MercilessAuthority.exe      ← Compiled executable (pre-built)
├── holycleanAPP.ico            ← App icon (must be in same folder)
└── README.md                   ← This file
```

---

## 📜 Changelog Highlights

| Version | Date | Milestone |
|---|---|---|
| v1.0 | Feb 16, 2026 | Born. Basic WMI MessageBox. |
| v2.3 | Mar 14, 2026 | Replaced WMI with kernel32 P/Invoke. |
| v2.6 | Mar 15, 2026 | First ever real fullscreen popup fired. |
| v2.8 | Mar 15, 2026 | True zero-delay: popup runs in same process via STA Runspace. |
| v2.9 | Mar 16, 2026 | Iron Curtain: Win key + all hotkeys blocked. |
| v2.11 | Mar 19, 2026 | Three distinct melodic beeps. DEAD countdown. Force shutdown. |
| v2.20 | Mar 20, 2026 | Final polishings: DPI-proof layout, GDI ghost text eliminated, full animation system. |
| v2.21 | Apr 27, 2026 | Finally revealing this to the public. Universal paths — works on any Windows account on any machine. |

Full changelog inside `BatteryMercy.ps1` header.

*“Whatever you do, work heartily, as for the Lord and not for men,” — Colossians 3:23*   
*“For I am not ashamed of the gospel, for it is the power of God for salvation to everyone who believes.” — Romans 1:16*   
*Jesus said to him, “If you can,! Anything is possible for the one who believes” — Mark 9:23*

---

# 📄 License

MIT License

Copyright (c) 2026 Rabbi S. Arlan

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included  
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  
THE SOFTWARE.

---

## 👮 Other Infos 🚦️

> **DO NOT USE THIS AS A HILARIOUS PRANK OR IN OTHER  
> FORMS OF OTHER FUNNY SITUATIONS PLEASE!!! 😭️🙏️☠️🥀️**   
> DO SO WITH YOUR CONSENT WITH FROM OTHERS AND IF YOU HAVE  
> BEEN GRANTED A GIVEN PERMISSION WITH ABILITY TO USE IT.   
> I DO NOT HAVE ANY FORMS OF RESPONSIBILITY FOR ANY  
> IRREVERSIBLE DAMAGES CAUSED FURTHER FROM THIS PROGRAM  
> BY PEOPLE WITH SUSPICIOUS INTENTIONS TO DO SO, BECAUSE  
> THIS APPLICATION TOOL IS AN EDUCATIONAL SYSTEM AUTOMATION  
> PURPOSES PROJECT TO PUSH THE LIMITS OF DRASTICALLY ENHACING  
> BATTERY LONGEVITY, HEALTH LEVELS AND DURATION AT ALL COSTS.  
> And also it has `No system-level persistence, no network activity,`  
> `and lastly no data collection.` *(Who needs that pile of junk in their code...?)*

---

## 🤖 Development Notes

Built with AI-assisted pair programming (Claude Sonnet 4.6 Extended/Adaptive by Anthropic).  
All architecture decisions, feature design, debugging direction, engineering concepts   
and creative vision is all made by Rabbi S. Arlan.

---

## 🚧 Beta Status 🔂️

> ### **This single-person project is currently in public beta (v2.21).**
> Core features are fully functional and stable on the developer's hardware.  
> Behaviour on other hardware has not been fully verified yet, so please give fully  
> detailed information about your insights of your experience of this project.
>
> **Known Limitations(Beware):**
> - UI scaling not yet optimized for 4K (200%+ DPI) displays.  
> - Full Background or Slideshow Wallpaper Features requires a OneDrive Desktop folder to exist.  
> - *(My apologies but try check inside the codes to fully fix the paths)*  
> - Not tested on Windows 10 & ARM64 or non-standard display configurations.  
> - *(I have a 13 year old Japanese Lenovo ThinkPad E540 Laptop but did not try there because it's dead)*  
> - And many more that has yet to come.
>
> If you have any suggestions like a settings button in the top right corner when the battery event happened, you can change the critical level 35% to 20% and optimal level 85% to 80% in sliders, then ask me and i'll most certainly add it!
>
> ### Full Official Very Stable Release Planned for **v3.0** in the upcoming future.
> ### Bug reports and feedbacks will be welcomed via GitHub Issues or in this project.
