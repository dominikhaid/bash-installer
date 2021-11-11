#!/bin/bash
#shopt -s nullglob dotglob

SEARCHPATH=$SCRIPTPATH"/functions/main"
FUNCTIONS=()
MAIN=()

while IFS= read -d $'\0' -r file; do
	source $file
	FUNCTIONS+=($(echo $file | sed -En "s|$SEARCHPATH/(.*)\.sh$|\1|p"))
done < <(find $SEARCHPATH -regex ".*\.\(sh\)" -print0)


for func in ${FUNCTIONS[@]}; do
	str=$(echo "Install $func" | tr '[a-z]' '[A-Z]')
	str=$(echo $str | sed "s/\s/_/g")
	eval "$func"="($str  $func)"
	MAIN+=("$func[@]")
done

