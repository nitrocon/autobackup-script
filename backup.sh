#!/bin/sh
echo "IP of you're VPS"
read IP
echo "User to backup?"
read user
rsync $user@$IP:/ -aAXvh \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
/root/backups/
cd /root/
zip -r backups.zip backups
echo -e "$GREEN Finish !!! $COL_RESET"
