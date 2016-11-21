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

Edit this file:

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/boards.txt

adding this text:




Add these lines to

/home/pi/Downloads/arduino-1.6.12/hardware/arduino/avr/programmers.txt

`
gpio.name=Raspberry Pi GPIO
# gpio.communication=gpio
gpio.protocol=gpio
gpio.program.tool=avrdude
`
