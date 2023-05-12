<h1 align="center"> autobackup-script </h1>

<h3 align="left"> Requirements </h3>

* apt update
* apt -y install net-tools git zip

<h3 align="left"> How to run a backup: </h3>

* run as user
* git clone https://github.com/nitrocon/autobackup-script.git
* cd autobackup-script
* bash backup.sh

<h3 align="left"> What this script does: </h3>

1. Checks if net-tools, git, and zip are installed.
2. Gets a list of IP addresses and prompts the user to select one to use.
3. Gets a list of available users and prompts the user to select one to use.
4. Creates a backup directory in the user's home directory.
5. Performs the backup using rsync, excluding certain directories.
6. Compresses the backup directory into a ZIP file & deletes the folder

