#!/bin/env bash

# alsa_output.pci-0000_00_1b.0.analog-stereo
# alsa_output.usb-Logitech_G935_Gaming_Headset-00.analog-stereo

sink=`pactl get-default-sink`
if [[ $sink =~ "G935" ]]; then
	pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo
else
	pactl set-default-sink alsa_output.usb-Logitech_G935_Gaming_Headset-00.analog-stereo
fi
