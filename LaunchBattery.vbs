Dim scriptDir
scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colWScript = objWMIService.ExecQuery("Select * from Win32_Process Where Name = 'wscript.exe'")
count = 0
For Each objItem in colWScript
    If InStr(1, objItem.CommandLine, WScript.ScriptFullName, vbTextCompare) > 0 Then
        count = count + 1
    End If
Next
If count > 1 Then WScript.Quit
Set WshShell = CreateObject("WScript.Shell")
' Kill any existing MercilessAuthority.exe instance first
Set colExe = objWMIService.ExecQuery("Select * from Win32_Process Where Name = 'MercilessAuthority.exe'")
For Each objItem in colExe
    objItem.Terminate()
Next
' Small pause so killed process fully exits before relaunch
WScript.Sleep 600
' Launch boot splash — runs async alongside MercilessAuthority startup
WshShell.Run """C:\Program Files\PowerShell\7\pwsh.exe"" -ExecutionPolicy Bypass -WindowStyle Hidden -STA -File """ & scriptDir & "BootSplash.ps1""", 0, False
' Launch MercilessAuthority silently
WshShell.Run """" & scriptDir & "MercilessAuthority.exe""", 0, False
' VisualFX still needs pwsh.exe
WshShell.Run """C:\Program Files\PowerShell\7\pwsh.exe"" -WindowStyle Hidden -ExecutionPolicy Bypass -File """ & scriptDir & "VisualFX-BestAppearance.ps1""", 0, False
Set WshShell = Nothing
