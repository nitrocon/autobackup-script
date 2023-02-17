<h1 align="center"> autobackup-script </h1>

<h3 align="left"> Requirements </h3>

* apt update
* apt -y install net-tools git zip

<h3 align="left"> How to run a backup: </h3>

* run as root
* git clone https://github.com/nitrocon/autobackup-script.git
* cd autobackup-script
* bash backup.sh

<h3 align="left"> What this script does: </h3>

1.Checks if net-tools, git, and zip are installed.
2.Gets a list of IP addresses and prompts the user to select one to use.
3.Gets a list of available users and prompts the user to select one to use.
4.Generates an SSH key and copies the SSH public key to the VPS server.
5.Creates a backup directory in the user's home directory.
6.Performs the backup using rsync, excluding certain directories.
7.Compresses the backup directory into a ZIP file.
8. Downloading the zip file to your hard drive, default is (D:\server-backups..)
