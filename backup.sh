#!/bin/sh
# Shell script scripts to read ip address
# -------------------------------------------------------------------------
# Copyright (c) 2005 nixCraft project <https://www.cyberciti.biz>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit https://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Get OS name
OS="$(uname)"
IP="" # store IP
LIP="ifconfig" # default is ifconfig on Linux and BSD, but set to ip if not found below
# check for ifconfig command 
if ! type ifconfig >/dev/null
then
    if [ "$OS" != "Linux" ]
    then
        echo "$0 - ifconfig command not found on your $OS OS."
        exit 1 
    else
        if ! type ip >/dev/null
        then
            echo "$0 - ifconfig or ip command not found on your $OS OS."
            exit 1 
        else
            LIP="ip addr show"
        fi        
    fi
fi
#
# Supports Linux, macOS, FreeBSD, OpenBSD and SunOS Unix
#
case $OS in
   Linux) IP=$($LIP | grep 'inet'| grep -v '127.0.0.1' | cut -d: -f2 | awk 'NF>0{ print $2}');;
   FreeBSD|OpenBSD|Darwin) IP=$(ifconfig  | grep -E 'inet.[0-9]' | grep -v '127.0.0.1' | awk '{ print $2}') ;;
   SunOS) IP=$(ifconfig -a | grep inet | grep -v '127.0.0.1' | awk '{ print $2} ') ;;
   *) IP="Unknown";;
esac
echo "$IP"
echo "User to backup?"
read user
rsync $user@$IP:/ -aAXvh \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
/root/backups/
cd /root/
zip -r backups.zip backups
echo -e "$GREEN Finish !!! $COL_RESET"
