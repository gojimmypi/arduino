# arduino

To install Arduino IDE on the Raspberry Pi the command:

sudo apt-get install arduino

can be used, however the version of the IDE installed as of 2016, is a very VERY old version.

To install a more recent one, say... perhaps you are interested in using the IDE to progrem the ESP8266, visit:

https://www.arduino.cc/en/Main/Software

and take note of the "Linix Arm (experimental)" version, which as of 2016, is the 1.6.12 version:

https://www.arduino.cc/download_handler.php?f=/arduino-1.6.12-linuxarm.tar.xz

These instructions will assume it is downloaded to the RPi directory:

/home/pi/Downloads/

First uncompress it from about 75MB to a 344MB tar file:

cd ~/Downloads/
xz -d arduino-1.6.12-linuxarm.tar.xz  # uncompress, removing original xz file when done
tar -xvf arduino-1.6.12-linuxarm.tar  # extract the Arduino IDE to the current directory

Upon completion, the Version 1.6.12 Arduino IDE will be in:

/home/pi/Downloads/arduino-1.6.12

(You can choose to put it pretty much anywhere)

Install using the bash script:

cd arduino-1.6.12
sudo ./install.sh 

You may get an error included in the output like this:

Adding desktop shortcut, menu item and file associations for Arduino IDE...touch: cannot touch /root/.local/share/applications/mimeapps.list: No such file or directory
/usr/bin/xdg-mime: 781: /usr/bin/xdg-mime: cannot create /root/.local/share/applications/mimeapps.list.new: Directory nonexistent 
done!

(remember, it is "experimental" afterall, eh?)

to launch:

./arduino

Or if you are in a different directory:

~/Downloads/arduino-1.6.12/arduino

with this new version of Arduino on your Raspberry Pi, you'll probably want to include the magic url for Additional Boards Manager in File - Settings, perhaps for the ESP8266 with this URL:

http://arduino.esp8266.com/stable/package_esp8266com_index.json


If perhaps you want to bit-bang program an Arduino such as the http://rasp.io/duino/ a few more changes are needed.

Edit:

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/boards.txt

`
##############################################################gert328.name=Gertboard with ATmega328 (GPIO)gert328.upload.using=gpiogert328.upload.protocol=gpiogert328.upload.maximum_size=32768gert328.upload.speed=57600gert328.upload.disable_flushing=truegert328.bootloader.low_fuses=0xE7gert328.bootloader.high_fuses=0xDAgert328.bootloader.extended_fuses=0x07gert328.bootloader.path=atmegagert328.bootloader.file=ATmegaBOOT_168_gert328.hexgert328.bootloader.unlock_bits=0x3Fgert328.bootloader.lock_bits=0x0Fgert328.build.mcu=atmega328pgert328.build.f_cpu=12000000Lgert328.build.core=arduinogert328.build.variant=standard#gert328.upload.tool=avrdude##############################################################gert168.name=Gertboard with ATmega168 (GPIO)gert168.upload.using=gpiogert168.upload.protocol=gpiogert168.upload.maximum_size=16384gert168.upload.speed=57600gert168.upload.disable_flushing=truegert168.bootloader.low_fuses=0xE7gert168.bootloader.high_fuses=0xDAgert168.bootloader.extended_fuses=0x07gert168.bootloader.path=atmegagert168.bootloader.file=ATmegaBOOT_168_gert168.hexgert168.bootloader.unlock_bits=0x3Fgert168.bootloader.lock_bits=0x0Fgert168.build.mcu=atmega168gert168.build.f_cpu=12000000Lgert168.build.core=arduinogert168.build.variant=standard#gert168.upload.tool=avrdude##############################################################
`

Add these lines to

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/programmers.txt

`
gpio.name=Raspberry Pi GPIO
# gpio.communication=gpio
gpio.protocol=gpio
gpio.program.tool=avrdude
`
