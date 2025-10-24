#!/bin/env bash

if [[ $EUID != 0 ]] ; then
	echo This must be run as root!
	exit 1
fi

rmmod nvidia_uvm
modprobe nvidia_uvm
