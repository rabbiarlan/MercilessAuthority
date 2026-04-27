Dim scriptDir
scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\"))
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run """C:\Program Files\PowerShell\7\pwsh.exe"" -ExecutionPolicy Bypass -STA -File """ & scriptDir & "RecompileSplash.ps1""", 1, False
Set WshShell = Nothing
