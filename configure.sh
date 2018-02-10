#!/bin/bash

declare -a TOOLCHAINS=(GNAT_arm_toolchain GNAT_x86_toolchain)

declare -a TOOLCHAINS_URL=(mirrors.cdn.adacore.com/art/591c6413c7a447af2deed0e3\
			   mirrors.cdn.adacore.com/art/591c6d80c7a447af2deed1d7)

TOOLCHAIN_DIR=.toolchains


download()
{
	echo "Checking if $1 need downloading"
	if [ ! -f "$TOOLCHAIN_DIR/$1" ]; then
		echo "Downloading $1 in toolchain directory"
		wget $2 -O $TOOLCHAIN_DIR/$1
	fi
}

untar ()
{
	echo "Checking if $TOOLCHAIN_DIR/$1 need decompressing"
	DIR="$TOOLCHAIN_DIR/$1"
	if [ ! -f "${DIR%.tar}" ]; then
		mv $DIR ${DIR%.tar}
		echo "Decompressing $TOOLCHAIN_DIR/$1"
		cd $TOOLCHAIN_DIR
		tar -xvf ${1%.tar}
		cd ..
	fi
}



HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="Backtitle here"
TITLE="Title here"
MENU="Choose one of the following options:"

OPTIONS=(1 "GNAT arm"
         2 "GNAT x86"
         3 "Custom toolchain")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

CUSTOM_TOOLCHAIN_MENU=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)


if [ ! -d "${TOOLCHAIN_DIR:+$TOOLCHAIN_DIR/}" ]; then
	mkdir -p $TOOLCHAIN_DIR
fi

clear

case $CHOICE in
        1)
		clear
		download ${TOOLCHAINS[0]} ${TOOLCHAINS_URL[0]}
		untar ${TOOLCHAINS[0]}
		;;
        2)
		clear
		download ${TOOLCHAINS[1]} ${TOOLCHAINS_URL[1]}
		untar ${TOOLCHAINS[1]}
		;;
        3)
		echo "You chose Option 3"
		;;
esac
#clear
