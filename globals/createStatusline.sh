#!/bin/bash
#shopt -s nullglob dotglob
# create msg strings
status_msg() {
	MAX_LEN=76
	MIN_ARG_LEN=12
	ARG_LEN=${#1}
	ARG_DIFF=$(expr $MIN_ARG_LEN - $ARG_LEN)
	ARG=$1

	for ((i = 0; i <= $(expr $ARG_DIFF / 2); i++)); do
		ARG="\ $ARG \ "
	done

	ARG_LEN=${#ARG}
	DEC_LEN=$(expr $MAX_LEN - $ARG_LEN)
	DEC_LEN=$(expr $DEC_LEN / 2)

	declare DEC="$3"
	for ((i = $DEC_LEN; i >= 0; i--)); do
		DEC=$DEC"$3"
	done
	DEC="$DEC"

	echo ""
	color_text "$4" "$DEC  " "$2" "$ARG" "$4" "  $DEC"
	echo ""
}
