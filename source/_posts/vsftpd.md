---
title:  Installing VSFTP from source
authorId: simon_timms
date: 2021-09-08
originalurl: https://blog.simontimms.com/2021/09/08/vsftpd
mode: public
---



The 3.0.3 version of VSFTP seems to have an exploit against it so you should update to 3.0.5. However at the current time that has not been released in Debian upstream so we get to compile it ourselves!

First get and decompress the source
```
wget https://security.appspot.com/downloads/vsftpd-3.0.5.tar.gz
tar xvf vsftpd-3.0.5.tar.gz
cd vsftpd-3.0.5
```

Now you're going to need to edit the `builddefs.h` specifically you want to enable SSL with 

```
 #define VSF_BUILD_SSL
```

You may need to install the open ssl headers

```
sudo apt install libssl-dev
```

Next run a standard make/make install

```
make
make install
```

That should be it. If you're replacing an apt sourced vsftpd then remember to uninstall that and you will have to update the init.d script to point at the new one which is in `/usr/local/sbin` instead of `/usr/sbin`. You could also change the install prefix but I like `local` better.