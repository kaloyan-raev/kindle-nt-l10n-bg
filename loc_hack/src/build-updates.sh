#! /bin/sh

ulimit -c 100000000

. ../../config

PKGNAME="${HACKNAME}"
PKGVER="${VERSION}"

tar cvzf low_level_screens.tar.gz -C ../../images low_level_screens
tar cvzf img.tar.gz -C ../../images img

# Prepare our files for this specific kindle model...
ARCH=${PKGNAME}_${PKGVER}_k4x

# Build install update
./kindletool create ota2 -d kindle4 install.sh bcel-5.2.jar K3Translator.jar translation.jar default.keyb bg.properties low_level_screens.tar.gz img.tar.gz updatewait MobiReader-bg_BG.jar framework-api-bg_BG.jar update_${ARCH}_install.bin

# Build uninstall update
./kindletool create ota2 -d kindle4 uninstall.sh update_${ARCH}_uninstall.bin

# Pack the updates
rm -f ../${PKGNAME}_${PKGVER}.zip
zip -r ../${PKGNAME}_${PKGVER}.zip *.bin Readme.txt
rm -f *.bin
rm img.tar.gz
rm low_level_screens.tar.gz
