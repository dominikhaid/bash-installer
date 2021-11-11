#!/bin/bash

##
# DISPLAY LOGS
##
getLogs() {
	local outPath

	echo "Type (e) for error logs or (o) for output logs, navigate  with (:n)."
	read logType

	if [[ $logType == 'e' ]]; then
		outPath=$SCRIPTPATH/logs/err
	else
		outPath=$SCRIPTPATH/logs/out
	fi

	out=$(find $outPath)

	for log in "$out"; do
		if [ -f "$log" ]; then less $log; fi
		less $log
	done
}

if [[ $1 == "-l" ]]; then
	getLogs
	exit
fi

##
# MAIN INSTALLER
# TAKES ARRAY WITH FUNCTIONS
# 3 GRPS POSSIBLE "PRE" "MAIN" "POST"
##
install() {
	local SCRIPT=$(readlink -f "$0")
	local SCRIPTPATH=$(dirname "$SCRIPT")

	# msg constants
	CONTINUE_MSG='INSTALLING'
	SKIP_MSG='SKIPPING INSTALL STEP'
	CHOICE_MSG='Press (s) to skip, (q) to abort or (return) to continue [default return]'
	EXIT_MSG='INSTALLATION ABORTED'

	# get name arguments
	local -n preArr=$1
	local -n mainArr=$2
	local -n postArr=$3

	# welcome msg
	tput setaf 4
	cat $SCRIPTPATH/installer/asci/start.txt
	tput sgr0

	installer() {

		statusFunc() {
			stty -echo
			#catch the xdotool keypress
			keyTrap() {
				sleep $(($SKIPTIME + 2))
				old_tty_settings=$(stty -g) # Save old settings.
				stty -icanon
				local tmp=$(head -c1)
				stty "$old_tty_settings" # Restore old settings.
			}

			#auto spawn keypress if user dont inputs
			check() {
				xdotool key c
			}

			status_msg "$CHOICE_MSG" "orange" " " "orange"
			sleep $SKIPTIME && check &

			#input
			old_tty_settings=$(stty -g) # Save old settings.
			stty -icanon
			keyDown=$(head -c1)
			stty "$old_tty_settings" # Restore old settings.

			# if xdotool
			if [[ $keyDown == "c" ]]; then
				return 1
			fi

			# user inputs
			case $keyDown in
			[Ss]*) keyTrap && return 0 ;;
			[Qq]*) return 2 ;;
			*) keyTrap && return 1 ;;
			esac
			stty echo
		}

		local spin=1

		# install loop
		for func in "${@}"; do

			if [ $SKIPDIALOG -eq 0 ]; then
				#dislay install text
				msg=$(echo "${!func[0]:0:1}" | sed "s/_/ /g")
				status_msg "${msg}" "blue" "-" "blue"

				#ask user to skip step
				statusFunc
				local res=$?

				if [[ $res == 0 ]]; then
					status_msg "$SKIP_MSG" "blue" "-" "blue"
					continue
				elif [[ $res == 2 ]]; then
					status_msg "$EXIT_MSG" "red" "-" "red"
					exit
				else
					status_msg "$CONTINUE_MSG" "green" "-" "green"
				fi
			fi

			eval ${!func[0]:1:1}

			if [ -f $LOGPATH/out/$(echo ${!func[0]:1:1}).log ]; then
				chown $USER_NAME:$USER_NAME $LOGPATH/out/$(echo ${!func[0]:1:1}).log
			fi

			if [ -f $LOGPATH/err/$(echo ${!func[0]:1:1}).log ]; then
				chown $USER_NAME:$USER_NAME $LOGPATH/err/$(echo ${!func[0]:1:1}).log
			fi
			echo "" && echo ""
		done
	}

	#set -x
	# remove old log folder and recreate
	if [ -d "$LOGPATH/out" ]; then
		rm -R $LOGPATH/out/
	fi

	if [ -d "$LOGPATH/err" ]; then
		rm -R $LOGPATH/err/
	fi

	if [ ! -d "$LOGPATH/out" ]; then
		mkdir -p $LOGPATH/out
		chown -R $USER_NAME:$USER_NAME $LOGPATH
	fi

	if [ ! -d "$LOGPATH/err" ]; then
		mkdir -p $LOGPATH/err
		chown -R $USER_NAME:$USER_NAME $LOGPATH
	fi

	if ((${#preArr[@]})); then
		#set +x
		echo ""
		echo ""
		# pre  install step
		status_msg "PREPARING" "purple" "_" "purple"
		installer ${preArr[@]}
	fi

	if ((${#mainArr[@]})); then
		echo ""
		echo ""
		# main install
		status_msg "INSTALLING" "purple" "_" "purple"
		installer ${mainArr[@]}
	fi

	if ((${#postArr[@]})); then
		echo ""
		echo ""
		# post install
		status_msg "CLEAN UP" "purple" "_" "purple"
		installer ${postArr[@]}
	fi


	tput setaf 4
	cat $SCRIPTPATH/installer/asci/end.txt
	echo "
    "
	echo "Do not forget to reboot "
	tput sgr0
}
