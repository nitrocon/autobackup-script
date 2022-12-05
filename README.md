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

1. collecting IP address with netstat (yet not working when you have more than 1 address)
2. asking for the Username that will be backuped
3. collecting all files [exceptions can be edited] (this takes some while)
4. zipping the folder "backups" - result file shows: year, month, day, daytime
5. deleting the folder "backups"
6. finish, youre zip can be downloaded in your root folder
