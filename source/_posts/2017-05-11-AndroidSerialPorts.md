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
 - 6ft straight through serial cable
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

To actually call this function we'll need to compile it. For that we need the Android NDK. Instead of getting into how to do that I'll just link to Nick Desaulniers's [excellent post](http://nickdesaulniers.github.io/blog/2016/07/01/android-cli/). I will say that I did the compilation using the Windows Subsystem for Linux which is boss. 

The end result is a libSetBaud.so file, .so being the extension for shared objects. This file should be included in the Android application in Visual Studio. A couple of things seem to be important here: first the file should be in a hierarchy which indicates what sort of processor it runs on. If you need to support more than one processor then you'll need to compile a couple of different versions of the library. I knew that this particular device had an armeabi-v7a so into that folder went the compiled .so file. Second you'll need to set the type on the file to AndroidNativeLibrary.

Next came exposing the function the function for use in Xamarin. To do that we use the Platform Invocation Service (PInvoke). PInvoke allows calling into unmanaged code in an easy way. All that is needed is to 

```csharp
using System;
using System.Linq;
using System.Runtime.InteropServices;

namespace SerialMessaging.Android
{
    public class BaudSetter
    {
        [DllImport("libSetBaud", ExactSpelling = true)]
        public static extern int SetUpSerialSocket();
    }
}
```

I'd never had to do this before and it is actually surprisingly easy. Things obviously get way more complex if the function you're calling out to requires more complex types or pointers or file descriptors. I specifically kept the C code to a minimum because I don't trust in my ability to do things with C. If you're more adventurous then you can hook into the Android libraries and make use of things like their logging pipeline instead of `printf`.

With this all in place it was possible to spin up an Android application to see if we can get the message from the Windows side. Building on the idea of just reading from the device I started with 

```csharp
var readHandle = File.Open("/dev/ttyS3", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
while (true)
{
    var readBuffer = new byte[2000];

    if (readHandle.CanRead)
        readHandle.Read(readBuffer, 0, 2000);
    Android.Util.Log.Debug("serial", readBuffer);
}
```

This was able to retrieve bytes out of the device and print them to the Android debug console. Awesome! The problem was that when they came in they weren't all a contiguous block. If the windows side sent `hello from the C# program1\n` in a loop then we might get the output

```plain
hel
lo from the C# 
program1\nh
ello from the C# program1
```

Uh oh. Guess we'll have to use a stop byte to indicate the end of messages. `0x00` won't work because the read buffer contains a bunch of those already. For now we can try using `0x01`. Looking at an ASCII table sending `0x03`, End of Text might be more appropriate. We add that to the send side with a WireFormatSerializer

```csharp
public class WireFormatSerializer
{
    public byte[] Serialize(string toSerialize)
    {
        var bytes = System.Text.ASCIIEncoding.ASCII.GetBytes(toSerialize);
        var bytesWithSpaceForTerminatingCharacter = new byte[bytes.Length + 1];
        Array.Copy(bytes, bytesWithSpaceForTerminatingCharacter, bytes.Length);
        bytesWithSpaceForTerminatingCharacter[bytesWithSpaceForTerminatingCharacter.Length - 1] = 0x1;
        return bytesWithSpaceForTerminatingCharacter;
    }
}
```

On the receiving side we hook up a BufferedMessageReader whose responsibility it is to read bytes and assemble messages. I decided to push the boat out a bit here and implement an IObservable<string> which would rebuild the messages and emit them as events. 

```csharp

public class BufferedMessageReader : IObservable<string>
{
    List<IObserver<string>> observers = new List<IObserver<string>>();
    List<byte> freeBytes = new List<byte>();

    public void AddBytes(byte[] bytes)
    {
        foreach(var freeByte in bytes)
        {
            if(freeByte == 0x01)
            {
                EndOfMessageEncountered();
            }
            else
            {
                freeBytes.Add(freeByte);
            }
        }
    }

    public IDisposable Subscribe(IObserver<string> observer)
    {
        if(!observers.Contains(observer))
            observers.Add(observer);
        return new Unsubscriber(observers, observer);
    }

    void EndOfMessageEncountered()
    {
        var deserializer = new WireFormatDeserializer();
        var message = deserializer.Deserialize(freeBytes.ToArray());

        foreach (var observer in observers)
            observer.OnNext(message);
        freeBytes.Clear();
    }

    private class Unsubscriber: IDisposable
    {
        private List<IObserver<string>> _observers;
        private IObserver<string> _observer;

        public Unsubscriber(List<IObserver<string>> observers, IObserver<string> observer)
        {
            this._observers = observers;
            this._observer = observer;
        }

        public void Dispose()
        {
            if (_observer != null && _observers.Contains(_observer))
                _observers.Remove(_observer);
        }
    }
}
```

Most of this class is boilerplate code for wiring up observers. The crux is that we read bytes into a buffer until we encounter the stop bit which we discard and deserialize the buffer before clearing it ready for the next message. This seemed to work pretty well. There could be some additional work done around the message formats for the wire for instance adding more complete checksums and a retry policy. I'd like to get some experimental data on how well the current set up works in the real world before going to that length. 

On the Android side I wrapped this observable with a thing to actually read the file so it ended up looking like 

```csharp
public class SerialReader
{

    public string _device { get; set; }

    /// <summary>
    /// Starts a serial reader on the given device
    /// </summary>
    /// <param name="device">The device to start a reader on. Defaults to /dev/ttyS3</param>
    public SerialReader(string device = "/dev/ttyS3")
    {
        if (!device.StartsWith("/dev/"))
            throw new ArgumentException("Device must be /dev/tty<something>");
        _device = device;
    }

    private BufferedMessageReader reader = new BufferedMessageReader();

    public IObservable<string> GetMessageObservable()
    {
        return reader;
    }

    private void ProcessBytes(byte[] bytes)
    {
        int i = bytes.Length - 1;
        while (i >= 0 && bytes[i] == 0)
            --i;
        if (i <= 0)
            return;
        var trimmedBytes = new byte[i + 1];
        Array.Copy(bytes, trimmedBytes, i + 1);
        reader.AddBytes(trimmedBytes);
    }

    public void Start()
    {
        var readThread = new Thread(new ThreadStart(StartThread));
        readThread.Start();
    }

    private void StartThread()
    {
        var readHandle = File.Open(_device, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        while (true)
        {
            var readBuffer = new byte[2000];

            if (readHandle.CanRead)
                readHandle.Read(readBuffer, 0, 2000);
            ProcessBytes(readBuffer);
        }
    }
}
```

Now listening for messages is as easy as doing 

```csharp
 BaudSetter.SetupUpSerialSocket(); //sets up the baud rate
 var reader = new SerialReader(); //create a new serial reader
 reader.GetMessageObservable().Subscribe((message) => Log(message));//subscribe to new messages
 reader.Start();//start the listener
```

One way communication squared away. Now to get messages back from the tablet to the computer. First stop was writing to the file on Android. Again we can make use of the fact that the serial port is just a file

```csharp
public class SerialWriter
{
    public string _device { get; set; }
    public SerialWriter(string device = "/dev/ttyS3")
    {
        if (!device.StartsWith("/dev/"))
            throw new ArgumentException("Device must be /dev/tty<something>");
        _device = device;
    }

    public void Write(string toWrite)
    {
        var writeHandle = File.Open(_device, FileMode.Open, FileAccess.ReadWrite, FileShare.ReadWrite);

        var bytes = new WireFormatSerializer().Serialize(toWrite);
        if (writeHandle.CanWrite)
        {
            writeHandle.Write(bytes, 0, bytes.Length);
        }
        writeHandle.Close();
    }
}
```

Really no more than just writing to a file like normal. Closing the file descriptor after each write seemed to make things work better. On the Windows side the serial port already has a data received event built into it so we can just go and add an event handler.

```csharp
serialPort.DataReceived += DataReceivedHandler;
```

This can then be hooked up like so 

```csharp
static BufferedMessageReader reader = new BufferedMessageReader();
private static void DataReceivedHandler(
                object sender,
                SerialDataReceivedEventArgs e)
{
    SerialPort sp = (SerialPort)sender;

    var bytesToRead = sp.BytesToRead;//need to create a variable for this because it can change between lines
    var bytes = new byte[bytesToRead];
    sp.Read(bytes, 0, bytesToRead);

    reader.AddBytes(bytes);
}
```

And that is pretty much that. This code all put together allows sending and receiving messages on a serial port. You can check out the full example at https://github.com/ClearMeasure/AndroidSerialPort where we'll probably add any improvements we find necessary as we make use of the code.

 *There is probably some way to grant your user account the ability to do this but I didn't look into it
