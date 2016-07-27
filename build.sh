#!/bin/bash
export PATH=/home/cristi/kb/arm-eabi-4.9.4/bin:$PATH
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE="ccache /home/cristi/kb/arm-eabi-4.9.4/bin/arm-eabi-"

#cleanup to be sure that we don't build the same kernel
echo -e "\e[92mCleaning the build directory\e[0m"
rm -f arch/arm/boot/zImage* boot-n.img zImage*
make mrproper > /dev/null 2>&1

#build
echo -e "\e[92mCompiling the kernel image...\e[0m"
echo -e "\e[92mBuilding the default configuration...\e[0m"
make shamu_defconfig > /dev/null 2>&1
echo -e "\e[92mBuilding the kernel...\e[0m"
make -j12

#make flashable boot image only if zImage-dtb exists
if  [[ -a arch/arm/boot/zImage-dtb ]]; then
    echo -e "\e[92mMaking the flashable boot image\e[0m"
    echo -e "\e[92mCopying the kernel image\e[0m"
    cp arch/arm/boot/zImage-dtb .
    echo -e "\e[92mProcessing the image and ramdisk\e[0m"
    ./mkbootimg --kernel zImage-dtb --ramdisk ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=shamu msm_rtb.filter=0x37 ehci-hcd.park=3 utags.blkdev=/dev/block/platform/msm_sdcc.1/by-name/utags utags.backup=/dev/block/platform/msm_sdcc.1/by-name/utagsBackup coherent_pool=8M' --base  0x00000000 --pagesize 2048 --ramdisk_offset 0x0000000b --tags_offset 0x0000000b -o boot-n.img
    if [[ -a boot-n.img ]]; then
        echo -e "\e[92mDone building, happy flashing!\e[0m"
    else
        echo -e "\e[31mBuild stuck in processing the ramdisk and kernel!\e[0m"
    fi
else
    echo -e "\e[31mBuild stuck in compiling!\e[0m"
fi
