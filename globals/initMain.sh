#!/bin/bash
#shopt -s nullglob dotglob
if [ -f "./installer/globals/vars.sh" ]; then
    source ./installer/globals/vars.sh
elif [ -f "../../installer/globals/vars.sh" ]; then
    source ../../installer/globals/vars.sh
    SCRIPTPATH="$SCRIPTPATH/../.."
else 
    echo "required files are missing"
    exit
fi   

source $SCRIPTPATH/installer/globals/initDepend.sh
source $SCRIPTPATH/installer/globals/setIndicator.sh
source $SCRIPTPATH/installer/globals/createStatusline.sh
source $SCRIPTPATH/installer/globals/colorText.sh

if  [ -z "$DEV_SINGLE_RUN" ]; then
    DEV_MAIN_RUN=1
    source $SCRIPTPATH/installer/globals/initInstall.sh
    source $SCRIPTPATH/installer/loops/pre.sh
    source $SCRIPTPATH/installer/loops/main.sh
    source $SCRIPTPATH/installer/loops/post.sh
    source $SCRIPTPATH/installer/installer.sh
fi

initGlobals() {

if ! [[ $USER == "root" ]]; then 
 echo "Script must be run as root!"
 exit
fi

if ! [[ -d "$SCRIPTPATH/logs" ]]; then
	mkdir -p "$SCRIPTPATH/logs/err"
	mkdir -p "$SCRIPTPATH/logs/out"
fi

if  [ -z "$LOGPATH" ]; then
	LOGPATH="$SCRIPTPATH/logs"
fi

# Read Password
printf "User Name: "
read USER_NAME
stty -echo
printf "User Password: "
read USER_PASS
stty echo
printf "\n"
USER_HOME="/home/$USER_NAME"
TEST_USER=$(cat /etc/passwd | gawk -F: '{ print $1 }' | gawk -e 'match($0, /'$USER_NAME'/) {print substr( $1, RSTART, RLENGTH )}')

if [[ "$TEST_USER" == "" ]]; then
	echo "
        No user: $USER_NAME 
        please add the user with /sbin/useradd USERNAME
        and run the script again!"
	exit
fi

}


if  [ -z $USER_NAME ] || [ -z $USER_PASS ]; then initDepend && initGlobals; fi


runSingle() {
    $1
}


if  [ -z "$DEV_SINGLE_RUN" ]; then
    initInstall
    install PRE MAIN POST
fi
