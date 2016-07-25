#!/bin/bash
export PATH=/home/cristi/kb/arm-eabi-4.9.4/bin:$PATH
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/cristi/kb/arm-eabi-4.9.4/bin/arm-eabi-
rm -f arch/arm/boot/zImage*
make mrproper
make shamu_defconfig
make -j12
