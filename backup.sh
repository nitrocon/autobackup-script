#! /bin/sh
echo 'PUBLIC_IP='"${PUBLIC_IP}"'
read -e -p "User name to backup : " user
rsync '"${user}"'@'"${PUBLIC_IP}"':/ -aAXvh \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
/root/backups/
cd /root/
zip -r backups.zip backups
echo -e "$GREEN Finish !!! $COL_RESET"
