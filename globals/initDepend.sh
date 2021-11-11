#!/bin/bash


initDepend() {
	export DEBIAN_FRONTEND=noninteractive

	if ! [ -d "$LOGPATH/out" ]; then
		mkdir -p $LOGPATH/out
		chown -R $USER_NAME:$USER_NAME $LOGPATH
	fi

	if ! [ -d "$LOGPATH/err" ]; then
		mkdir -p $LOGPATH/err
		chown -R $USER_NAME:$USER_NAME $LOGPATH
	fi

	aptInst() {
		apt update && apt upgrade -y
		apt install -y neofetch
		apt install -y expect
		neofetch --off --underline --color_blocks --stdout >$LOGPATH/out/hardware_before.log
		apt install -y xdotool
		apt install -y gawk
	}

	aptInst >$LOGPATH/out/gawk.log 2> \
		$LOGPATH/err/gawk.log &

	setIndicator "SCRIPT DEPENDENCIES" ${WORKINGICONS[2]} $!

	vscodettf() {
		if ! [ -f "$USER_HOME/.fonts/vscode.ttf" ]; then
			if ! [ -d "$USER_HOME/.fonts" ]; then
				mkdir $USER_HOME/.fonts
			fi
			wget 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' -O $USER_HOME/.fonts/vscode.ttf
			chown -R $USER_NAME:$USER_NAME $USER_HOME/.fonts
			chown -R $USER_NAME:$USER_NAME $USER_HOME/.fonts/vscode.ttf
		fi
	}

	vscodettf >$LOGPATH/out/fonts.log 2> \
		$LOGPATH/err/fonts.log

	nerd() {

		sudo -i -u $USER_NAME <<EOF
    cd $USER_HOME && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraMono.zip
    unzip FiraMono.zip -d $USER_HOME/.fonts
    fc-cache -fv
    rm $USER_HOME/FiraMono.zip
EOF
	}

	if ! [ -f $USER_HOME/.fonts/"Fira Mono Bold Nerd Font Complete.otf" ]; then
		nerd >$LOGPATH/out/fonts.log 2> \
			$LOGPATH/err/fonts.log &

		setIndicator "FONTS" ${WORKINGICONS[2]} $!
	fi
}
