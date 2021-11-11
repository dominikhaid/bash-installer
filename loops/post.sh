#!/bin/bash
#shopt -s nullglob dotglob


while IFS= read -d $'\0' -r file; do
    source $file
done < <(find $SCRIPTPATH/functions/post -regex ".*\.\(sh\)" -print0)

post=('POST INSTALL' postInstall)

POST=(post[@])
