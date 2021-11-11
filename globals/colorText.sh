#!/bin/bash
#shopt -s nullglob dotglob
# color strings
color_text() {
	red=$(tput setaf 1)
	purple=$(tput setaf 5)
	blue=$(tput setaf 4)
	orange=$(tput setaf 3)
	green=$(tput setaf 2)
	reset=$(tput sgr0)
	str=

	for ((i = 1; i <= $(expr ${#@} + 1); i++)); do
		realCount=$(expr $i - 1)
		colorCol=$(expr $i + 1)
		if [[ ${@:$i:1} == "red" ]]; then
			str=$str$red$(echo ${@:$colorCol:1})$reset
		elif [[ ${@:$i:1} == "purple" ]]; then
			str=$str$purple$(echo ${@:$colorCol:1})$reset
		elif [[ ${@:$i:1} == "blue" ]]; then
			str=$str$blue$(echo ${@:$colorCol:1})$reset
		elif [[ ${@:$i:1} == "green" ]]; then
			str=$str$green$(echo ${@:$colorCol:1})$reset
		elif [[ ${@:$i:1} == "orange" ]]; then
			str=$str$orange$(echo ${@:$colorCol:1})$reset
		elif [[ ${@:$i:1} == "white" ]]; then
			str=$str$reset$(echo ${@:$colorCol:1})$reset
		fi
		i=$colorCol
	done

	echo -e $str
}
