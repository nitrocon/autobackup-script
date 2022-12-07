#!/bin/sh
    clear
    echo
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo -e "$GREEN Reading out IP addresses $COL_RESET"
    echo -e "$GREEN Enter password & username for .home included to the backup $COL_RESET"
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo
    sleep 3
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
# -------------------------------------------------------------------------
# Shell script: autobackup-script
# -------------------------------------------------------------------------
# Copyright (c) 2022 nitrocon <https://pool.cryptoverse.eu>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
echo "Username [Home folder will be included to the Backup]"
read user
rsync $user@$IP:/ -aAXvh \
    echo
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo -e "$GREEN Collecting files... $COL_RESET"
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo
    sleep 3
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/sbin/*","/media/*","/lost+found","/usr/bin/*"} \
/root/backups/
cd /root/
    clear
    echo
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo -e "$GREEN Zipping files... $COL_RESET"
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo
    sleep 3
zip -r "backup-$(date +"%Y-%m-%d").zip" backups
    clear
    echo
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo -e "$GREEN Removing backup folder... $COL_RESET"
    echo -e "$GREEN************************************************************************$COL_RESET"
    echo
    sleep 3
rm -r backups
echo -e "$GREEN Finished !!! $COL_RESET"
