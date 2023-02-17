# -------------------------------------------------------------------------
# Shell script: autobackup-script
# -------------------------------------------------------------------------
# Copyright (c) 2023 nitrocon <https://pool.cryptoverse.eu>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
#!/bin/sh

clear

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mChecking for requirements\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Check if net-tools, git, and zip are installed
PACKAGES="net-tools git zip sshpass"
for package in $PACKAGES; do
    if ! dpkg -s $package >/dev/null 2>&1; then
        echo "The $package package is not installed. Installing..."
        sudo apt-get -y install $package
    fi
done

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

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mEnter password & username for .home included to the backup\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Get a list of all available users
USER_LIST="$(awk -F':' '{if ($6 ~ /\/home\// && $1 != "syslog") print $1}' /etc/passwd)"

# If there is only one user, use it automatically
if [ "$(echo "$USER_LIST" | wc -l)" -eq 1 ]; then
  USER="$(echo "$USER_LIST")"
  echo "Using user: $USER"
else
  # Prompt the user to select a username from the list
  select USER in $USER_LIST; do
    if [ -n "$USER" ]; then
      echo "Using user: $USER"
      break
    else
      echo "Invalid selection. Please try again."
    fi
  done
fi

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mGenerating SSH key\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Generate SSH key
sudo mkdir -p /home/$USER/.ssh && sudo ssh-keygen -t rsa -b 4096 -C "autobackup-script key" -f /home/$USER/.ssh/autobackup-script -q -N ""

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mCopying SSH public key to VPS server\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Copy SSH public key to VPS server
echo "Please enter the password for the VPS server:"
read -s PASS

sudo ssh-copy-id -p 22 -i /home/$USER/.ssh/autobackup-script.pub $USER@$IP

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mPerforming backup\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Create backup directory in user's home directory
backup_path="/home/$USER/backup"
mkdir -p "$backup_path"

# Backup user's home directory using rsync
sudo rsync -aAXv --delete -e "ssh -i /home/$USER/.ssh/autobackup-script" "/home/$USER/" "$USER@$IP:/home/$USER/backup" \
--exclude={"/home/$USER/backup","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/sbin/*","/media/*","/lost+found","/usr/bin/*","/usr/share/*"}

# Create timestamp for backup file name
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mZipping...\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Zip backup directory
zip_file="/home/$USER/${USER}_backup_${timestamp}.zip"
sudo zip -r "$zip_file" "$backup_path"

# Remove backup directory
sudo rm -rf "$backup_path"

# Downloading the zip file
echo
echo -e "\033[32m************************************************************************\033[0m"
echo -e "\033[32mDownloading the zip file\033[0m"
echo -e "\033[32m************************************************************************\033[0m"
echo
sleep 3

# Download backup file to local machine
echo "Downloading backup file to local machine..."
mkdir -p "D:/server-backups/$IP/$USER"
rsync -avz --progress -e 'ssh -p 22' "$USER@$IP:$zip_file" "/mnt/d/server-backups/$IP/$USER/$(basename $zip_file)"

echo "Backup file downloaded to /mnt/d/server-backups/ on local machine."
