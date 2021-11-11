#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTID=$BASHPID
LOGPATH=$SCRIPTPATH/logs
SKIPTIME=3
SKIPDIALOG=1
C_RED=$(tput setaf 1)
C_PURPLE=$(tput setaf 5)
C_BLUE=$(tput setaf 4)
C_ORANGE=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)
