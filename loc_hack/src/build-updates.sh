#! /bin/sh

ulimit -c 100000000

. ../../config

PKGNAME="${HACKNAME}"
PKGVER="${VERSION}"

tar cvzf low_level_screens.tar.gz -C ../../images low_level_screens
tar cvzf img.tar.gz -C ../../images img

# Prepare our files for this specific kindle model...
ARCH=${PKGNAME}_${PKGVER}_k4x

# Build install update with font-fix & with langpack
cp -f install_ff_lp.sh install.sh
cp -f MobiReader-bg_BG_ff_lp.jar MobiReader-bg_BG.jar
./kindletool create ota2 -d kindle4 install.sh bcel-5.2.jar K3Translator.jar translation.jar default.keyb bg.properties low_level_screens.tar.gz img.tar.gz success.png updatewait MobiReader-bg_BG.jar framework-api-bg_BG.jar Update_${ARCH}_install.bin

# Build install update witout font-fix & with langpack
cp -f install_nff_lp.sh install.sh
cp -f MobiReader-bg_BG_nff_lp.jar MobiReader-bg_BG.jar
./kindletool create ota2 -d kindle4 install.sh bcel-5.2.jar K3Translator.jar translation.jar default.keyb bg.properties low_level_screens.tar.gz img.tar.gz success.png updatewait MobiReader-bg_BG.jar Update_${ARCH}_nff_lp_install.bin

# Build install update with font-fix & without langpack
cp -f install_ff_nlp.sh install.sh
cp -f MobiReader-bg_BG_ff_nlp.jar MobiReader-bg_BG.jar
./kindletool create ota2 -d kindle4 install.sh bcel-5.2.jar K3Translator.jar translation_nlp.jar default.keyb bg.properties success.png updatewait MobiReader-bg_BG.jar framework-api-bg_BG.jar Update_${ARCH}_ff_nlp_install.bin

# Build install update witout font-fix & witout langpack (keyboard only)
cp -f install_nff_nlp.sh install.sh
./kindletool create ota2 -d kindle4 install.sh bcel-5.2.jar K3Translator.jar translation_nlp.jar default.keyb bg.properties success.png updatewait Update_${ARCH}_nff_nlp_install.bin

# Build uninstall update
./kindletool create ota2 -d kindle4 uninstall.sh Update_${ARCH}_uninstall.bin

# Pack the updates
rm -f ../${PKGNAME}_${PKGVER}.zip
zip -r ../${PKGNAME}_${PKGVER}.zip *.bin Readme.txt keyboards
rm -f *.bin
rm img.tar.gz
rm low_level_screens.tar.gz
rm install.sh
rm MobiReader-bg_BG.jar
