#!/bin/bash
echo 8 > /sys/class/gpio/unexport

# see https://www.raspberrypi.org/forums/viewtopic.php?t=5185&f=5
#sudo groupadd gpio
#sudo usermod -aG gpio pi
#su pi
#sudo chgrp gpio /sys/class/gpio/export
#sudo chgrp gpio /sys/class/gpio/unexport
#sudo chmod 775 /sys/class/gpio/export

sudo avrdude -p atmega328p -C ~/Downloads/arduino-1.6.12/hardware/tools/avr/etc/avrdude.conf -c gpio -v -patmega328p -cgpio {program.extra_params} -Uflash:w:/tmp/arduino_build_747143/sketch_nov21a.ino.hex

