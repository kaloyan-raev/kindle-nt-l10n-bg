#!/bin/sh
#
# $Id: install.sh 6845 2010-09-23 23:11:24Z NiLuJe $
#
# diff OTA patch script

_FUNCTIONS=/etc/rc.d/functions
[ -f ${_FUNCTIONS} ] && . ${_FUNCTIONS}

# ========== Variables ==========

INST_LOG=/mnt/us/localization/install.log

# FontFix config and log files
FIX_PREF=/mnt/us/system/fontfix.pref
FIX_LOG=/mnt/us/system/fontfix.log

# System dirs
ORIGFOLDER_JAR=/opt/amazon/ebook/booklet
ORIGFOLDER_LIB=/opt/amazon/ebook/lib
KEYBFOLDER=.

# =========== Logging ===========

MSG_SLLVL_D="debug"
MSG_SLLVL_I="info"
MSG_SLLVL_W="warn"
MSG_SLLVL_E="err"
MSG_SLLVL_C="crit"
MSG_SLNUM_D=0
MSG_SLNUM_I=1
MSG_SLNUM_W=2
MSG_SLNUM_E=3
MSG_SLNUM_C=4
MSG_CUR_LVL=/var/local/system/syslog_level

logmsg()
{
    local _NVPAIRS
    local _FREETEXT
    local _MSG_SLLVL
    local _MSG_SLNUM

    _MSG_LEVEL=$1
    _MSG_COMP=$2

    { [ $# -ge 4 ] && _NVPAIRS=$3 && shift ; }

    _FREETEXT=$3

    eval _MSG_SLLVL=\${MSG_SLLVL_$_MSG_LEVEL}
    eval _MSG_SLNUM=\${MSG_SLNUM_$_MSG_LEVEL}

    local _CURLVL

    { [ -f $MSG_CUR_LVL ] && _CURLVL=`cat $MSG_CUR_LVL` ; } || _CURLVL=1

    if [ $_MSG_SLNUM -ge $_CURLVL ]; then
        /usr/bin/logger -p local4.$_MSG_SLLVL -t "ota_install" "$_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
    fi

    if [ "$_MSG_LEVEL" != "D" ]; then
      echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
      [ -d /mnt/us/localization ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT" >> ${INST_LOG}
    fi
}

#If present other .keyb files then use it.
[ -n "$(find /mnt/us/ -maxdepth 1 -name '*.keyb')" ] && KEYBFOLDER=/mnt/us

#Create localization dir at user store
[ -d /mnt/us/localization ] || mkdir /mnt/us/localization

#Remove old bg* jar files
logmsg "I" "update" "Remove bg,bg_BG JARs"
rm -rf ${ORIGFOLDER_LIB}/*-bg_BG.jar  >>  ${INST_LOG} 2>&1
rm -rf ${ORIGFOLDER_LIB}/*-bg.jar  >>  ${INST_LOG} 2>&1

logmsg "I" "update" "Copy bg.properties"
update_progressbar 10
cp -f bg.properties /opt/amazon/ebook/config/locales

logmsg "I" "update" "Translate JARs"
update_progressbar 20
/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator td4 ${ORIGFOLDER_LIB} translation_nlp.jar en_GB bg >> ${INST_LOG} 2>&1

logmsg "I" "update" "Translate Keyboard"
update_progressbar 30
/usr/java/bin/cvm -Xms16m -classpath bcel-5.2.jar:K3Translator.jar Translator keyb4 ${ORIGFOLDER_LIB}/framework-api.jar $KEYBFOLDER es bg >> ${INST_LOG} 2>&1

update_progressbar 60
logmsg "I" "move" "Installing fontfix files"
mv -f *-bg_BG.jar ${ORIGFOLDER_LIB} >> ${INST_LOG} 2>&1
logmsg "I" "create" "File ${FIX_PREF} creation..."
if [ ! -f ${FIX_PREF} ]; then
    echo "#User font size for Reader Booklet
FONT_LETTER=A
FONT_SIZES=20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
#User margins for Reader Booklet
MOBI_HORIZONTAL_MARGINS=30,20,10
PDF_TOP_MARGIN=0
PDF_HORIZONTAL_MARGINS=0" > ${FIX_PREF}
    logmsg "I" "create" "Success!"
else
    logmsg "I" "check" "Skip: file ${FIX_PREF} already exists"
fi

logmsg "I" "create" "File ${FIX_LOG} creation..."
if [ ! -f ${FIX_LOG} ]; then
    echo "FontFix installed: `date`" >> ${FIX_LOG}
    logmsg "I" "create" "Success!"
else
    logmsg "I" "check" "Skip: file ${FIX_LOG} already exists"
fi

update_progressbar 70
logmsg "I" "update" "Use the new locale"
sed -i 's/^locale=.*$/locale=bg-UA/' /var/local/java/prefs/com.amazon.ebook.framework/prefs

update_progressbar 80
logmsg "I" "update" "Setup dictionaries"
echo "dictionary.list = bg,en-GB" > /opt/amazon/dict/conf/bg.conf
logmsg "I" "update" "Setup whitelist"
sed -i '/^[.]\/documents\/dictionaries\/bg/d' /opt/amazon/data.whitelist
sed -i '/^[.]\/localization/d' /opt/amazon/data.whitelist
echo "./documents/dictionaries/bg" >>/opt/amazon/data.whitelist
#echo "./documents/dictionaries/bg/en-bg.azw" >>/opt/amazon/data.whitelist
echo "./localization" >>/opt/amazon/data.whitelist
echo "./localization/INSTALLED" >>/opt/amazon/data.whitelist
echo "./localization/updatewait" >>/opt/amazon/data.whitelist

update_progressbar 90
logmsg "I" "update" "Copy updatewait wrapper & force using it"
cp -f updatewait /mnt/us/localization/
sed -i 's|^_UPDATE_WAIT=.*$|_UPDATE_WAIT="$(if [ -x /mnt/us/localization/updatewait ]; then echo /mnt/us/localization/updatewait; else echo /usr/sbin/updatewait; fi)"|' /etc/updater.conf >> ${INST_LOG} 2>&1

[ ! -f /mnt/us/localization/UNINSTALLED ] || rm -f /mnt/us/localization/UNINSTALLED
touch /mnt/us/localization/INSTALLED

logmsg "I" "update" "done"
update_progressbar 100

/usr/sbin/eips -c
/usr/sbin/eips -g success.png

for i in $(seq 1 10)
do
	sleep 1
	/usr/sbin/eips 45 1 $(( 10 - i ))
done

return 0
