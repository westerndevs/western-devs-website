---
layout: post
title: The Great RS-232 Adventure
tags:
  - xamarin
  - c#
categories:
  - development
authorId: simon_timms
date: 2017-05-11 19:36:36
excerpt: Talking over the RS-232 serial protocol is a bit of a blast from the past but I needed to use in on an Android tablet from within Xamarin. This is the, painfully complete, story of my journey.
---

A few days back my buddy [Justin Self](/bios/justin_self) found me a pretty good challenge. Although my memory isn't as good as it once was I have a high degree of confidence that the interaction went something like this. 

**Scene:** Simon has just walked out of the ocean after having swum between two adjacent tropical islands. As he strolls up to the beach Justin arrives.

![100% truthful representation of what it looked like](http://imgur.com/WQlOjce.png)
*Photo of expensive and highly accurate recreation of what happened*

**Justin:** We need somebody to figure out how to get this android tablet to talk over serial to a computer. 

**Simon:** You mean over USB?

**Justin:** No, over RS-232 serial. And you need to be able to do it in Xamarin's MonoDroid or Mono for Android or whatever non-copyright infringing name they have for it now.

**Simon:** Well Justin, I've never use Xamarin before, nor have I written an Android app, nor have I ever done communication over a serial port before. I actually know nothing about hardware either. 

**Justin:** You're almost overqualified for this...

**Simon:** I'm as qualified as I am to do anything. I'll get right on it - ship me the tablet. 

And that is a very accurate representation of just what happened. My first step was to get the cables I needed. Back in 1996 I had a serial mouse but that fellow is long since gone and I haven't a single serial cable in my house. So I headed over to a local electronics store and threw myself at the mercy of the clerk and elderly electrical engineering type. He soon had me kitted out with all the hardware I needed

 - ATEN USB to Serial converter
 - 6tf straight through serial cable
 - F/F gender changer
 - Null modem adapter

 My computer didn't have an RS-232 port and neither did anything else in my house so the USB-to-serial converter was key. It installed using built in Windows drivers which was fortunate because the manual that came with it only had instructions for installing on Windows 2000. For the serial cable I took a straight through because I wasn't sure how the tablet was wired. The gender changer was needed to hook things together and the null modem adapter was to switch around the wiring for computer to computer communication. See back in the day you'd actually use different wires to connect two computers than to connect a computer and a mouse or printer or something. Twisted pair Ethernet use to be like that too before the gigabit standard introduced auto-switching. 

A couple of days later a box arrived for me containing the tablet

![Image of IoT-800 from http://www.ruggedpcreview.com/3_panels_arbor_iot800.html](http://i.imgur.com/co21I7x.jpg)
*Image from http://www.ruggedpcreview.com/3_panels_arbor_iot800.html*

It was an Arbor IoT-800 running Android 4.4. As you can see in that picture there are two 9-pin serial ports on the bottom as well as USB ports and an Ethernet jack. A quick ProTip about those USB port: they aren't the sort you can use to hook the tablet up to your computer but rather for hooking up the tablet to external devices. You might be able to get them working for hooking up to a computer but you'd need a USB-crossover cable, which I didn't have and, honestly, I'd never heard of before this.

My first step was to write something on the Windows side that could talk over serial. I needed to find the COM port that was related to the serial port I had plugged in. To do this I called into the Windows Management Interface, WMI. You need to run as admin to do this*. I enumerated all the serial ports on my machine and picked the one whose name contained USB. I'm not sure what the other one is, possibly something built into the motherboard that doesn't have an external connector.

```csharp
var searcher = new ManagementObjectSearcher("root\\WMI", "SELECT * FROM MSSerial_PortName");
string serialPortName = "";
foreach (var searchResult in searcher.Get())
{
    Console.Write($"{searchResult["InstanceName"]} - {searchResult["PortName"]}");
    if (searchResult["InstanceName"].ToString().Contains("USB"))
    {
        Console.Write(" <--- using this one");
        serialPortName = searchResult["PortName"].ToString();
    }
    Console.WriteLine();
}
```

You can also look in the device manager to see which COM port the device is on but this way is more portable. On my machine I got this output

```plain
Starting
ACPI\PNP0501\1_0 - COM1
USB VID_0557&PID_2008\6&2c24ce2e&0&4_0 - COM4 --- using this one
```

Next I needed to open up the port and write some data. Fortunately there is a built-in serial port library in .NET. Depending on which articles you read online the serial drivers might be terrible. I'm not overly concerned about performance on this line at this juncture so I just went with the built in class located in `System.IO.Ports`. 

```csharp
int counter = 0;
var serialPort = new SerialPort(serialPortName, 9600);//COM4 and baud of 9600bit/s to start, ramp up later
serialPort.Open();
while(true)
{
  Console.WriteLine(counter);
  var sendBytes = System.Text.ASCIIEncoding.ASCII.GetBytes($"hello from the C# program{counter++}\n");
  serialPort.Write(sendBytes, 0, sendBytes.Length);
  Thread.Sleep(1000);
}
```

Here we just loop over the serial port and ask it to send data every second. I chose the most brutally simplistic things at first: a low baud rate and ASCII encoding. 

Of course there really isn't a way to tell if this is working without having something on the other end to read it... So onto Android. My first stop was to install an SSH server on the machine. After all, this is UNIX system and I know that

![It's a UNIX system!](http://i.imgur.com/urrU3hU.jpg)

One of the really cool things about Linux is the `/dev` directory. This directory contains all the devices on your system. So if you pop in there you might see devices like `sda0` which is actually a partition on your hard drive or `/dev/random` which is a fun device that just emits random numbers. Go on, try doing `cat /dev/random` or `cat /dev/urandom` depending on what your system has. On this IoT-800 there are a whole cluster of devices starting with `tty`. These are, comically, teletype devices. See back in the good old UNIX days we had dumb terminals for accessing a single computer and those devices showed up as `tty` devices. Guess how those terminals were connected. Serial. So after some experimentation I was able to figure out that the middle physical port on the device was mapped to `/dev/ttyS3`.  

With the cables all hooked up I held my breath and ran `cat /dev/ttyS3` while the program on windows was running. Boom, there in my terminal was what was coming from Windows. 

```plain
u0_a74@rk3188:/ $ cat /dev/ttyS3
hello from the C# program0
```

Linux is awesome. So now all that is needed it to get this working from Xamarin. 

The System.IO.Ports package is not part of the version of .NET which runs on Android so a different approach was necessary. Again Linux to the rescue: we can simply read from the device. Before we do that, however, we need to set the baud on the connection. Normally you'd do this by using stty(1) but this command isn't available on Android and we likely wouldn't have permission to call it anyway. 

What is needed is a native OS call to set up the serial port. Xamarin.Android allows calling to native C functions so let's do that. 

```c
#include <termios.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>

int SetUpSerialSocket()
{
    printf("Opening serial port\n");
    int fd = open("/dev/ttyS3", O_RDWR);
    struct termios cfg;
    printf("Configuring serial port\n");
    if (tcgetattr(fd, &cfg))
    {
        printf("tcgetattr() failed\n");
        close(fd);
        return -1;
    }

    cfmakeraw(&cfg);
    printf("Setting speed in structure\n");
    cfsetispeed(&cfg, B115200);
    printf("Saving structure\n");
    if(!tcsetattr(fd, TCSANOW, &cfg))
    {
        printf("Serial port configured, mate\n");
        close(fd);
        return 0;
    }
    else{
        printf("Uh oh\n");
        return -1;
    }
}

int main(int argc, char** argv)
{
    printf("Setting baud on serial port /dev/ttyS3\n");
    return SetUpSerialSocket();
}
```

To actually call this function we'll need to compile it. For that we need the Android NDK. Instead of getting into how to do that I'll just link to Nick Desaulniers's [excellent post](http://nickdesaulniers.github.io/blog/2016/07/01/android-cli/). The end result is that we have a .so file. This file should be included in the Android application in Visual Studio. A couple of things seem to be important here: first the file should be in a hierarchy which indicates what sort of processor it runs on. If you need to support more than one processor then you'll need to compile a couple of different versions of the library. I knew that this particular 


 *There is probably some way to grant your user account the ability to do this but I didn't look into it