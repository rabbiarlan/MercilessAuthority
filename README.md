# ⚡ MercilessAuthority 🔋 — Totalitarian Battery Monitor   
## *💚🔋✅ No mercy. No remorse. No dead batteries. 🚫🪫❌*   
### *The Most Merciless Totalitarian Authoritarian Fullscreen Battery Monitor ever I made for fun!*   
#### *Only for Windows Laptops that has functioning batteries!*

> Built by the Author: **Rabbi S. Arlan**; a 16 years old Computer Science & Engineering enthusiast from the Philippines 🇵🇭   
> God first, before technology. — Matthew 6:33   
> From **v1.0** (basic popup MessageBox) to **v2.21** (fullscreen lockout with kernel32 P/Invoke) — built entirely from scratch.

---

# ⚠️READ THIS FIRST BEFORE USE AT YOUR OWN RISK —Why It Looks Like Malware‼️ *(But It Isn't)*

This app blocks Alt+Tab, the Win key, Ctrl+Esc, and goes fullscreen unclosable.   
It forces you to click on the Red button that says: **“YES pwease, Master~!”** *(I'm sorry if you have to go through this bro...🙏)*

**That's intentional.** Here's why:

If your laptop dies at 5% because a tiny toast notification was easy to ignore, you lose unsaved work. MercilessAuthority makes the alert **impossible to ignore** with also a mode to a literal **60 second countdown** if you try to deplete your battery to **ZERO** — you must literally acknowledge it like acknowledging God before you can continue!   
Task Manager always remains accessible as an emergency escape.*(If that's possible)* The source code is fully open. You can read every single line one by one before running anything in some systems or in yours.

**This is not a very suspicious malware.** It is aggressively opinionated battery management software that I have created just for fun.   
So expect getting this reaction from yourself: *“Why is this app literally controlling my system like this?”* — You probably.

**“Totalitarian battery monitor inspired by North Korean Authoritarian Control.”**   
**“This is apparently a Super high-attention aggressive strict focus mode notifier battery percentage-management alert system that actively interrupts and reinforces awareness of battery status to prevent missed low-power situations.”**

---

## 🔋 What It Does

Monitors your laptop battery every 5 seconds using Windows kernel32 `GetSystemPowerStatus()` — the same API your taskbar uses, zero WMI lag or inaccuracy.

Three alert modes:

| Mode | Trigger | What Happens |
|---|---|---|
| **LOW** | ≤35%,unplugged, per-% drop | Fullscreen popup, sad descending beep, yellow warning icon |
| **HIGH** | ≥85%, plugged in, per-% rise | Fullscreen popup, ascending major beep, green checkmark icon |
| **DEAD** | ≤10%, unplugged | **60-second countdown popup**, ominous beep, force shutdown if still unplugged after countdown |

---

## 🛠️ Technical Architecture

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

---

## 📋 Requirements and ✅ Compatibility

- PowerShell 7 (`pwsh.exe`) — [Download here](https://github.com/PowerShell/PowerShell/releases)

| | |
|---|---|
| **OS** | Windows 10 / 11 (64-bit) |
| **Architecture** | x64 primary. ARM64 via Windows emulation layer. |
| **Runtime** | None required — MercilessAuthority.exe is self-contained |
| **PowerShell** | Only needed if recompiling from source (PS 7.1+) |
| **Recompile tool** | Standard ps2exe v1.0.17 |
| **Device** | A laptop with a battery (obviously💀🥀🥶🙏) or if you're in a mobile phone running Windows *"dayumnn that's impressive!"* |

> **Note:** Windows Defender may flag this on first run due to keyboard hooks   
> and force-shutdown behaviour. This is a false positive. Source code is fully   
> open — read BatteryMercy.ps1 to verify exactly what runs.

To **recompile** from source only:
- [ps2exe v1.0.17](https://github.com/MScholtes/PS2EXE)

> The pre-built `.exe` works on any Windows 10/11 machine.  
> No PowerShell. No .NET install. No dependencies. Just run it.

---

## 🚀 Installation

1. Download or clone this repository
2. Place all files in the **same folder** (e.g. `C:\Scripts\` or anywhere you want)
3. Place `holycleanAPP.ico` in the same folder
4. Right-click `CLICK_TO_RECOMPILE.vbs` → Run — this compiles `MercilessAuthority.exe`
5. Set up Task Scheduler to run `LaunchBattery.vbs` at logon:
   - Open Task Scheduler → Create Basic Task
   - Trigger: At log on
   - Action: Start a program → `wscript.exe`
   - Arguments: `"C:\path\to\LaunchBattery.vbs"`

Or just double-click `LaunchBattery.vbs` to run it manually right now.

> If UI appears too small on some certain displays like 4K displays:  right-click  "MercilessAuthority.exe" → Properties → Compatibility →
> Change high DPI settings → Override high DPI scaling behaviour → Application

---

## 🧪 Safe Test Run

Don't want the force-shutdown behaviour while testing? Run `BatteryMercy_TestRun.ps1` instead. It fires the popups with real battery data but **never calls `Stop-Computer`**. Safe to run any time.

```powershell
pwsh -ExecutionPolicy Bypass -File BatteryMercy_TestRun.ps1
```

---

## 📁 File Structure

```
MercilessAuthority/
├── BatteryMercy.ps1            ← Main source (compile this)
├── BatteryMercy_TestRun.ps1    ← Safe test, no shutdown
├── BootSplash.ps1              ← Boot splash screen
├── RecompileSplash.ps1         ← Splash shown during recompile
├── CLICK_TO_RECOMPILE.vbs      ← Double-click to recompile
├── LaunchBattery.vbs           ← Launcher (use in Task Scheduler)
├── RECOMPILE_GUIDE.ps1         ← Detailed recompile instructions
├── VisualFX-BestAppearance.ps1 ← Sets Windows visual FX on startup (this is optional)
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
| v2.20 | Mar 20, 2026 | Final polish: DPI-proof layout, GDI ghost text eliminated, full animation system. |
| v2.21 | Apr 27, 2026 | Finally revealing this to the public. Universal paths — works on any Windows account on any machine. |

Full changelog inside `BatteryMercy.ps1` header.

*“Whatever you do, work heartily, as for the Lord and not for men,” — Colossians 3:23*   
*“For I am not ashamed of the gospel, for it is the power of God for salvation to everyone who believes.” — Romans 1:16*   
*Jesus said to him, “If you can,! Anything is possible for the one who believes” — Mark 9:23*

---

# 📄 License

MIT License

Copyright (c) 2026 Rabbi S. Arlan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## 👮 Other Infos

> **DO NOT USE THIS AS A PRANK OR IN OTHER FORMS OF HILARIOUS SITUATIONS PLEASE! :(**   
> DO SO WITH YOUR CONSENT WITH FROM OTHERS AND IF YOU HAVE BEEN GRANTED A GIVEN PERMISSION WITH ABILITY TO USE IT   
> I DO NOT HAVE ANY FORMS OF RESPONSIBILITY FOR ANY IRREVERSIBLE DAMAGES CAUSED FURTHER FROM THIS PROGRAM
> BY PEOPLE WITH SUSPICIOUS INTENTIONS TO DO SO
> BECAUSE THIS TOOL IS AN EDUCATIONAL/SYSTEM AUTOMATION PURPOSES PROJECT.   
> And also it has `No system-level persistence, no network activity, and lastly no data collection.`*(Who needs that pile of junk in their code...?)*

---

## 🤖 Development Notes

Built with AI-assisted pair programming (Claude Sonnet 4.6 Extended/Adaptive by Anthropic).  
All architecture decisions, feature design, debugging direction, engineering concepts   
and creative vision is all by Rabbi S. Arlan.
