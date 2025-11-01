---
title: "Droidian Guide"
date: "2022-05-06"
weight: 1
type: docs
summary: "Setting up the droidian mobile linux distribution."
---


# What is Droidian?

Droidian is a Linux distribution for Android Phones based on Mobian, and therefore supports all Debian applications. It runs on a large majority of Android 9 devices. If a device has been ported to Ubuntu Touch and is android 9 or 10, it is likely possible to run Droidian.

Dependencies:
Fastboot and ADB (On Arch these can be found in the android-tools package)

# Downgrading to Android 9

Since the OnePlus 6T currently has a Halium build based on Android 9, we need to make sure our device is running Android 9 before Droidian can be installed.

This can be done by flashing OOS 9 to the phone using TWRP or MSM Download Tool.

If you have Android 9 already installed, skip to "Preparing files for droidian".

### TWRP Method

Firstly, download the OOS 9 zip from:

[For OnePlus 6](https://otafsg1.h2os.com/patch/amazone2/GLO/OnePlus6Oxygen/OnePlus6Oxygen_22.O.34_GLO_034_1909112343/OnePlus6Oxygen_22_OTA_034_all_1909112343_dd26.zip)

[For OnePlus 6T](https://otafsg1.h2os.com/patch/amazone2/GLO/OnePlus6TOxygen/OnePlus6TOxygen_34.O.24_GLO_024_1909112343/OnePlus6TOxygen_34_OTA_024_all_1909112343_d5b1905.zip)

Also, download TWRP 3.5.2 for your respective device. You can use 3.6 instead for android 11.

[For OnePlus 6](https://eu.dl.twrp.me/enchilada/twrp-3.5.2_9-0-enchilada.img.html)

[For OnePlus 6T](https://eu.dl.twrp.me/fajita/twrp-3.5.2_9-0-fajita.img.html)

Once these are saved, you can load your device into fastboot mode. 
On the OnePlus 6 this can be done by holding POWER + VOL UP.
On the OnePlus 6T this can be done by holding VOL UP + VOL DOWN + POWER, hold these until you see fastboot mode appear.

Connect the phone to your machine with a USB cable.

Next, we can boot TWRP 3.5.2:

    sudo fastboot boot twrp-3.5.2_9-0-[device].img
    
   From TWRP, select Advanced, then Sideload.
   Then run the command:

    sudo adb sideload OnePlus6Oxygen_22_OTA_034_all_1909112343_dd26.zip

   (Change the filename depending on which is required for your device)
   
Select reboot from TWRP, then Bootloader.

Once fastboot mode loads once again, we should have OOS 9 installed to our currently booted slot, which means we are ready to install Droidian!

### MSM Download Tool Method

[Follow the steps here](https://forum.xda-developers.com/t/tool-6t-msmdownloadtool-v4-0-59-oos-v9-0-13.3867448/)

# Preparing files required for Droidian

First we need to download a few things. TWRP 3.3.1, the droidian zips and our boot image.
### TWRP
[For OnePlus 6](https://eu.dl.twrp.me/enchilada/twrp-3.3.1-2-enchilada.img.html)

[For OnePlus 6T](https://eu.dl.twrp.me/fajita/twrp-3.3.1-1-fajita.img.html)

### Follow Droidian upstream docs!

We used to have to manually flash images, but Droidian now have a native installer which does the job for us.
https://devices.droidian.org/#/devices/enchilada