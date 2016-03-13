#!/bin/bash
export CROSS_COMPILE="ccache ../Toolchain/bin/arm-eabi-"

make mrproper
make shamu_defconfig

if [ $# -gt 0 ]; then
    echo $1 > .version
fi

make -j4
