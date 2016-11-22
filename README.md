# Arduino IDE - Experimental ARM Version Installation & Issues.

There are a variety of versions and methods available to install the Arduino IDE on a Raspberry Pi.

The most common way to install Arduino IDE on the Raspberry Pi the command:

```sudo apt-get install arduino```

can be used, however the version of the IDE installed as of 2016, is a very VERY old version.

To install a more recent one, say... perhaps you are interested in using the IDE to program the ESP8266, visit:

https://www.arduino.cc/en/Main/Software

and take note of the "Linux Arm (experimental)" version, which as of 2016, is the 1.6.12 version:

https://www.arduino.cc/download_handler.php?f=/arduino-1.6.12-linuxarm.tar.xz

These instructions will assume it is downloaded to the RPi directory:

/home/pi/Downloads/

First uncompress it from about 75MB to a 344MB tar file:

```
cd ~/Downloads/
xz -d arduino-1.6.12-linuxarm.tar.xz  # uncompress, removing original xz file when done
tar -xvf arduino-1.6.12-linuxarm.tar  # extract the Arduino IDE to the current directory
```
Upon completion, the Version 1.6.12 Arduino IDE will be in:

/home/pi/Downloads/arduino-1.6.12

(You can choose to put it pretty much anywhere)

Install using the bash script:

``'
cd arduino-1.6.12
sudo ./install.sh 
``'
You may get an error included in the output like this:

>Adding desktop shortcut, menu item and file associations for Arduino IDE...touch: cannot touch /root/.local/share/applications/mimeapps.list: No such file or directory
>/usr/bin/xdg-mime: 781: /usr/bin/xdg-mime: cannot create /root/.local/share/applications/mimeapps.list.new: Directory nonexistent 
>done!

(remember, it is "experimental" afterall, eh?)

to launch:

```
./arduino
```

Or if you are in a different directory:

```
~/Downloads/arduino-1.6.12/arduino
```

with this new version of Arduino on your Raspberry Pi, you'll probably want to include the magic url for Additional Boards Manager in File - Settings, perhaps for the ESP8266 with this URL:

http://arduino.esp8266.com/stable/package_esp8266com_index.json


If perhaps you want to bit-bang program an Arduino such as the http://rasp.io/duino/ a few more changes are needed.

Edit this file:

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/boards.txt

adding this text for these gert328 and gert168 boards:

```
##############################################################

gert328.name=Gertboard with ATmega328 (GPIO)

gert328.upload.using=gpio
gert328.upload.protocol=gpio
gert328.upload.maximum_size=32768
gert328.upload.speed=57600
gert328.upload.disable_flushing=true

gert328.bootloader.low_fuses=0xE7
gert328.bootloader.high_fuses=0xDA
gert328.bootloader.extended_fuses=0x07
gert328.bootloader.path=atmega
gert328.bootloader.file=ATmegaBOOT_168_gert328.hex
gert328.bootloader.unlock_bits=0x3F
gert328.bootloader.lock_bits=0x0F

gert328.build.mcu=atmega328p
gert328.build.f_cpu=12000000L
gert328.build.core=arduino
gert328.build.variant=standard

#
gert328.upload.tool=avrdude

##############################################################

gert168.name=Gertboard with ATmega168 (GPIO)

gert168.upload.using=gpio
gert168.upload.protocol=gpio
gert168.upload.maximum_size=16384
gert168.upload.speed=57600
gert168.upload.disable_flushing=true

gert168.bootloader.low_fuses=0xE7
gert168.bootloader.high_fuses=0xDA
gert168.bootloader.extended_fuses=0x07
gert168.bootloader.path=atmega
gert168.bootloader.file=ATmegaBOOT_168_gert168.hex
gert168.bootloader.unlock_bits=0x3F
gert168.bootloader.lock_bits=0x0F

gert168.build.mcu=atmega168
gert168.build.f_cpu=12000000L
gert168.build.core=arduino
gert168.build.variant=standard

#
gert168.upload.tool=avrdude

##############################################################

```

Add these gpio lines to

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/programmers.txt

```
gpio.name=Raspberry Pi GPIO
# gpio.communication=gpio
gpio.protocol=gpio
gpio.program.tool=avrdude
```

Then edit

/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/etc/avrdude.conf

(yes, the Arduino IDE wants to use its OWN version of avrdude, regardless of what you may have installed!)

..and add this lines right after the PROGRAMMER DEFINITIONS header:

```
programmer
  id    = "gpio";
  desc  = "Use sysfs interface to bitbang GPIO lines";
  type  = "linuxgpio";
  reset = 8;
  sck   = 11;
  mosi  = 10;
  miso  = 9;
;
```

To test the GPIO programming:

Exit and restart Arduino IDE if it was running while making the above changes.

Tools - Board (select Gertboard with ATmega328 (GPIO)), and select the port (probably /dev/ttyAMA0)
Tools - Programmer (select Raspberry Pi GPIO)
Scketch - Upload Using Programmer

At this point, if there's an error such as "An error occured while uploading the sketch", the version of avrdude is likely not happy with the GPIO settings.

To confirm: File - Preferences (check verbose output during upload)

If you see "Can't export GPIO 8, already exported/busy?: Invalid argument" 

For reference, see: http://savannah.nongnu.org/bugs/?40748

```
ls  /sys/class/gpio               # should not have a gpio8 item listed in this directory
echo 8 > /sys/class/gpio/export   # this confirms you have permissions to export
echo 8 > /sys/class/gpio/unexport # this should confirm you can unexport a GPIO pin
```

given all of that, you'll need to use a symbolic link to force the Arduino IDE to use a different version of avrdude.

see what version you have by using avrdude -v 

```
avrdude: Version 6.1, compiled on Jul  7 2015 at 13:18:47
         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/
         Copyright (c) 2007-2014 Joerg Wunsch

         System wide configuration file is "/etc/avrdude.conf"
         User configuration file is "/home/pi/.avrduderc"
         User configuration file does not exist or is not a regular file, skipping


avrdude: no programmer has been specified on the command line or the config file
         Specify a programmer using the -c option and try again

```
however the newer version of avrdude (6.3) that came with the Arduino 1.6.12 IDE seems to have problems:

/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/bin/avrdude -v
```
avrdude: Version 6.3, compiled on Sep 12 2016 at 15:28:39
         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/
         Copyright (c) 2007-2014 Joerg Wunsch

```

So I renamed that avrdude to avrdude.bak and created a link to the older one that is installed with apt-get (6.1):

```
ln -s /usr/bin/avrdude /home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/bin/avrdude
```

At this point, when you try to upload, you should see a new version of avrdude used, along with a new error:
```
avrdude: Version 6.1, compiled on Jul  7 2015 at 13:18:47
         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/
         Copyright (c) 2007-2014 Joerg Wunsch

         System wide configuration file is "/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/etc/avrdude.conf"
         User configuration file is "/home/pi/.avrduderc"
         User configuration file does not exist or is not a regular file, skipping
An error occurred while uploading the sketch

         Using Port                    : unknown
         Using Programmer              : gpio
Can't open gpioX/direction: Permission denied

avrdude done.  Thank you.
```
There's a useful discussion of this topic here: https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=100913&p=700025

In particular this comment from nsayer:
>It turns out this isn't a bug in sysfs, but it is a consequence of having udev set the file permissions. There's inevitably going to be a race between the creation of the node with the "wrong" permissions and the rectification of those permissions by udev.

>The fundamental reason the race exists is that users of gpio are expected to perform initialization actions that alter the content of the device tree (by creating the /sys/class/gpio/gpioX symlinks and associated directories and device control nodes). The alteration of the device tree wakes up udev, which comes in and does its work, completing it at an indeterminate future time. There is no way to block the write to "export" until udev finishes.

>The alternative would be for the device tree to be static rather than dynamic. udev would then be able to set the permissions correctly at boot time and be done with it. But that would be a huge change from how it's done now.

>The only other solution is to either not care about udev's permission changing, which means respecting the default kernel permissions of root:root and 644, or sleeping (not only to give udev time to do its work, but to yield the cpu to give it a chance on single core systems), or polling the node, checking the permissions until they change.

Thus far, the only solution I have found to the permission issue is to run the IDE with full permissions (certainly not ideal)

```
sudo ~/Downloads/arduino-1.6.12/arduino
```

Note that when running with sudo, the IDE will not have the previous defaults remembered for board, port, and programmer.

Compiling and attempting to upload again will likely result in yet another, new message:

```
Bootloader file specified but missing: /home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/bootloaders/ATmegaBOOT_168_gert328.hex
```
This is a very promising error, and since the board is a simple ATmeaga328, we can simply copy the bootloader file:

```
cp /home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/bootloaders/atmega/ATmegaBOOT_168_atmega328.hex  /home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/bootloaders/ATmegaBOOT_168_gert328.hex
```

Note that if you are STILL getting the error about not being able to export GPIO, consider manually unexporting it, for example #8:

``` 
echo 8 > /sys/class/gpio/unexport 
```

If all is working ok, you should see something like this (blink.ino shown):

```
Sketch uses 976 bytes (2%) of program storage space. Maximum is 32,768 bytes.
Global variables use 9 bytes of dynamic memory.
/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/bin/avrdude -C/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/etc/avrdude.conf -v $

avrdude: Version 6.1, compiled on Jul  7 2015 at 13:18:47
         Copyright (c) 2000-2005 Brian Dean, http://www.bdmicro.com/
         Copyright (c) 2007-2014 Joerg Wunsch

         System wide configuration file is "/home/pi/Downloads/arduino-1.6.12/hardware/tools/avr/etc/avrdude.conf"
         User configuration file is "/root/.avrduderc"
         User configuration file does not exist or is not a regular file, skipping

         Using Port                    : unknown
         Using Programmer              : gpio
         AVR Part                      : ATmega328P
         Chip Erase delay              : 9000 us
         PAGEL                         : PD7
         BS2                           : PC2
         RESET disposition             : dedicated
         RETRY pulse                   : SCK
         serial program mode           : yes
         parallel program mode         : yes
         Timeout                       : 200
         StabDelay                     : 100
         CmdexeDelay                   : 25
         SyncLoops                     : 32
         ByteDelay                     : 0
         PollIndex                     : 3
         PollValue                     : 0x53
         Memory Detail                 :

                                  Block Poll               Page                       Polled
           Memory Type Mode Delay Size  Indx Paged  Size   Size #Pages MinW  MaxW   ReadBack
           ----------- ---- ----- ----- ---- ------ ------ ---- ------ ----- ----- ---------
           eeprom        65    20     4    0 no       1024    4      0  3600  3600 0xff 0xff
           flash         65     6   128    0 yes     32768  128    256  4500  4500 0xff 0xff
           lfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00
           hfuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00
           efuse          0     0     0    0 no          1    0      0  4500  4500 0x00 0x00
           lock           0     0     0    0 no          1    0      0  4500  4500 0x00 0x00
           calibration    0     0     0    0 no          1    0      0     0     0 0x00 0x00
           signature      0     0     0    0 no          3    0      0     0     0 0x00 0x00

         Programmer Type : linuxgpio
         Description     : Use sysfs interface to bitbang GPIO lines
         Pin assignment  : /sys/class/gpio/gpio{n}
           RESET   =  8
           SCK     =  11
           MOSI    =  10
           MISO    =  9

avrdude: AVR device initialized and ready to accept instructions

Reading | ################################################## | 100% 0.01s

avrdude: Device signature = 0x1e950f
avrdude: NOTE: "flash" memory has been specified, an erase cycle will be performed
         To disable this feature, specify the -D option.
avrdude: erasing chip
avrdude: reading input file "/tmp/arduino_build_217340/Blink.ino.hex"
avrdude: writing flash (976 bytes):

Writing | ################################################## | 100% 0.73s

avrdude: 976 bytes of flash written
avrdude: verifying flash memory against /tmp/arduino_build_217340/Blink.ino.hex:
avrdude: load data flash data from input file /tmp/arduino_build_217340/Blink.ino.hex:
avrdude: input file /tmp/arduino_build_217340/Blink.ino.hex contains 976 bytes
avrdude: reading on-chip flash data:

Reading | ################################################## | 100% 0.72s

avrdude: verifying ...
avrdude: 976 bytes of flash verified

avrdude done.  Thank you.

```
