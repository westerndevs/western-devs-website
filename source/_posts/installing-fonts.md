---
title:  Installing Fonts on Windows with Powershell
authorId: simon_timms
date: 2021-06-11
originalurl: https://blog.simontimms.com/2021/06/11/installing-fonts
mode: public
---



You'd like to think that in 2021 installing a font would involve just copying it and some advanced AI system would notice it and install it on Windows. Again the future has failed us. 

Let's say you have a folder of TTF fonts you need installing. Just copying them to the `c:\windows\fonts` directory won't work. You need to copy them with a magic COM command that is probably left over from when file names in Windows looked like `PROGRA~1`. I've seen some scripts which add the font to the windows registry but I didn't have much luck getting them to work and they feel fragile should Microsoft ever update font handling (ha!). 

Here is a script that will copy over all the fonts in the current directory. 
```
echo "Install fonts"
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
foreach ($file in gci *.ttf)
{
    $fileName = $file.Name
    if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
        echo $fileName
        dir $file | %{ $fonts.CopyHere($_.fullname) }
    }
}
cp *.ttf c:\windows\fonts\
```

The fonts don't seem to get installed using the same file name as they arrive with so that last `cp` line puts the original files in the fonts directory so you can run this script multiple times and it will just install the new fonts. If you wanted to get cool you could check for a checksum and install fonts where the checksum doesn't match. Don't both trying to use `CopyHere` with the flag `0x14` thinking it will overwrite fonts. That doesn't work for the font directory.