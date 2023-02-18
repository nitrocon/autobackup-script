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
sleep 1

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
sleep 1

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
echo -e "\033[36mSelecting the User...\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 1

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
echo -e "\033[36mGenerating SSH Key\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 1

ssh_key_file="/home/$USER/.ssh/id_rsa"
ssh_dir="/home/$USER/.ssh"

ssh-add "$ssh_key_file"

if [ ! -d "$ssh_dir" ]; then
    mkdir "$ssh_dir"
    chmod 700 "$ssh_dir"
    chown "$USER:$USER" "$ssh_dir"
fi

if [ ! -f "$ssh_key_file" ]; then
    ssh-keygen -t rsa -b 4096 -f "$ssh_key_file" -N ""
    echo "SSH key generated at $ssh_key_file"
else
    echo "SSH key already exists, skipping..."
fi

if ssh -q "$USER@$IP" "exit"; then
    echo "SSH key is already authorized, skipping..."
else
    ssh-copy-id -i "$ssh_key_file.pub" "$USER@$IP"
    if [ "$?" -eq 0 ]; then
        echo "Public key copied"
    else
        echo "Failed to copy public key"
    fi
fi

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mPerforming backup\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Create backup directory if it doesn't exist
backup_path="/home/$USER/backup"
if [ ! -d "$backup_path" ]; then
    sudo mkdir -p "$backup_path"
    sudo chown $USER:$USER "$backup_path"
    sudo chmod 777 "$backup_path"
fi

# Backup directory using rsync
sudo rsync -aAXv -e "ssh -i $ssh_key_file -p 22" / "$USER@$IP:$backup_path" --exclude={"/home/$USER/backup","/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/sbin/*","/media/*","/lost+found","swapfile","/usr/bin/*","/usr/share/*"}

# Create timestamp for backup file name
timestamp=$(date +%Y-%m-%d)

echo
echo -e "\033[36m************************************************************************\033[0m"
echo -e "\033[36mZipping...\033[0m"
echo -e "\033[36m************************************************************************\033[0m"
echo
sleep 3

# Zip backup directory
zip_file="/home/$USER/${IP}_${USER}_backup_${timestamp}.zip"
sudo zip -r "$zip_file" "$backup_path"

# Remove backup directory
sudo rm -rf "$backup_path"
