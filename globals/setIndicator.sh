#!/bin/bash

declare -g WORKINGMSG="Working"
declare -g WORKINGICONS=("" "" "" "" "" "" "")
declare -g WORKINGICON=${WORKINGICONS[0]}
C_RED=$(tput setaf 1)
C_PURPLE=$(tput setaf 5)
C_BLUE=$(tput setaf 4)
C_ORANGE=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)
C_TEXT=$C_ORANGE
C_ICON=$C_GREEN

setIndicator() {
	WORKINGMSG=$1
	WORKINGICON=$2

	# If this script is killed, kill the `cp'.
	trap "kill $3 2> /dev/null" EXIT

	# execute the function
	while kill -0 $3 2>/dev/null; do
		echo -ne "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
		echo -ne "$C_TEXT[ $WORKINGMSG ] ${WORKINGICON}$C_RESET  "
		#color_text "$4" "$DEC  " "$2" "$ARG" "$4" "  $DEC"
		sleep 0.5
		echo -ne "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\bb\b"
		echo -ne "$C_TEXT[ $WORKINGMSG ]$C_ICON ${WORKINGICON}$C_RESET  "
		sleep 0.5
	done

	# Disable the trap on a normal exit.
	trap - EXIT

}
