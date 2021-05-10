---
title:  Creating a Shortcut in Powershell
authorId: simon_timms
date: 2021-05-10
originalurl: https://blog.simontimms.com/2021/05/10/creating-a-shortcut
mode: public
---



You can't really create a shortcut in powershell directly but you can using the windows script host from powershell. For instance here is how you would create a new desktop icon to log the current user off. 

```powershell
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$home\Desktop\LogOff.lnk")
$Shortcut.TargetPath="C:\Windows\System32\shutdown.exe"
$Shortcut.Arguments="/l"
$Shortcut.IconLocation="C:\windows\system32\Shell32.dll,44"
$Shortcut.Save()
```

The icon here is taken from the long list of icons in `Shell32.dll` in this case it is the little orange key icon. These icons are going to be refreshed soon so your mileage may vary on them. I found the right icon by just google image searching `shell32.dll icon` and found a picture of some of the index numbers. They were 1 indexed so I had to subtract 1

![](/images/2021-05-10-creating-a-shortcut.md/2021-05-10-11-39-21.png)