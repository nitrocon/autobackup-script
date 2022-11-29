#! /bin/sh
rsync pool@31.187.74.53:/ -aAXvh \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
/root/backups/
cd /root/
zip -r backups.zip backups
