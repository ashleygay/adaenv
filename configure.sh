#!/bin/bash

declare -a TOOLCHAINS=(GNAT_arm_toolchain GNAT_x86_toolchain)

declare -a TOOLCHAINS_URL=(mirrors.cdn.adacore.com/art/591c6413c7a447af2deed0e3\
			   mirrors.cdn.adacore.com/art/591c6d80c7a447af2deed1d7)

TOOLCHAIN_DIR=.toolchains

__PROJECT__=https://github.com/corentingay/templates2ada.git

download()
{
	echo "Checking if $1 need downloading"
	if [ ! -f "$TOOLCHAIN_DIR/$1" ] && [ ! -f "$TOOLCHAIN_DIR/$1.tar" ]; then
		echo "Downloading $1 in toolchain directory"
		wget $2 -O $TOOLCHAIN_DIR/$1
	fi
}

untar ()
{
	echo "Checking if $TOOLCHAIN_DIR/$1 need decompressing"
	DIR="$TOOLCHAIN_DIR/$1"
	if [ ! -f "$DIR.tar" ]; then
		mv $DIR $DIR.tar
		echo "Decompressing $TOOLCHAIN_DIR/$1"
		cd $TOOLCHAIN_DIR
		mkdir $1_directory && tar -xvf $1.tar -C $1_directory --strip-components 1
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

if [ ! -d "${TOOLCHAIN_DIR:+$TOOLCHAIN_DIR/}" ]; then
	mkdir -p $TOOLCHAIN_DIR
fi

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

if [ $CHOICE -lt 3 ]; then
	download ${TOOLCHAINS[(($CHOICE - 1))]} ${TOOLCHAINS_URL[(($CHOICE - 1))]}
	untar ${TOOLCHAINS[(($CHOICE - 1))]}
	echo "export __toolchain__=$TOOLCHAIN_DIR/${TOOLCHAINS[(($CHOICE - 1))]}_directory" > .variables.sh
	echo "export __PROJECT__=$__PROJECT__" >> .variables.sh
	if [ ! -d "project" ]; then
		git clone $__PROJECT__ project
		cp Dockerfile project
	else #Do we overwrite the project file ?
		read -p "Do yout want to overwrite the project directory?(y/n)" -n 1 -r
		printf "\n"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			#do stuff here
			rm -rf project
			git clone $__PROJECT__ project
			cp Dockerfile project
		fi
	fi

else #We chose a custom toolchain
	echo 'Not yet implemented'
fi

