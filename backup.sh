# -------------------------------------------------------------------------
# Shell script: autobackup-script
# -------------------------------------------------------------------------
# Copyright (c) 2022 nitrocon <https://pool.cryptoverse.eu>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
#!/bin/sh

# Define backup directory
BACKUP_DIR="/home/pool/backups"

# Clear screen
clear

# Print banner
echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mReading out IP addresses\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Get a list of IP addresses
IP_LIST="$(ifconfig | grep 'inet ' | awk '{print $2}' | grep -v '127.0.0.1')"

# Count the number of IP addresses
IP_COUNT=$(echo "$IP_LIST" | wc -l)

# If there is only one IP address, use it automatically
if [ "$IP_COUNT" -eq 1 ]; then
  IP="$IP_LIST"
  echo "Using IP address: $IP"
else
  # Prompt the user to select an IP address from the list
  echo "Select an IP address to use:"
  select IP in $IP_LIST; do
    if [ -n "$IP" ]; then
      echo "Using IP address: $IP"
      break
    else
      echo "Invalid selection. Please try again."
    fi
  done
fi

# Print banner
echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mEnter password & username for .home included to the backup\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Get a list of all available users
USER_LIST="$(cut -d: -f1 /etc/passwd)"

# Prompt the user to select a username from the list
select USER in $USER_LIST; do
  if [ -n "$USER" ]; then
    echo "Using user: $USER"
    break
  else
    echo "Invalid selection. Please try again."
  fi
done

# Perform backup
rsync $user@$IP:/ -aAXvh \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/sbin/*","/media/*","/lost+found","/usr/bin/*","/usr/share/*"} \
$BACKUP_DIR

# Compress backup
cd $BACKUP_DIR
echo
echo -e "\033[31m************************************************************************\033[0m"
echo -e "\033[31mZipping files...\033[0m"
echo -e "\033[31m************************************************************************\033[0m"
echo
sleep 3
zip -r "backup-$(date +"%Y-%m-%d").zip" .

# Remove backup folder
echo
echo -e "\033[31m************************************************************************\033[0m"
echo -e "\033[31mRemoving backup folder...\033[0m"
echo -e "\033[31m************************************************************************\033[0m"
echo
sleep 3
rm -rf $BACKUP_DIR

# Print message and exit
echo -e "\033[35mBackup ready to download!\033[0m"
