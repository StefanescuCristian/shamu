#!/bin/bash
adb wait-for-device reboot bootloader && sleep 5 && fastboot flash boot boot-n.img
