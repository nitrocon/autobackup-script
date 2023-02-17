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

1. listing all IPs on youre vps, autoselecting if there is just 1 IP
2. listing all users with a homedir on youre vps, autoselects if there is just 1 User
3. Generates SSH Keys, so you just have to enter the password once
4. collecting all files [exceptions can be edited] (this takes some while)
5. zipping the folder "backups" - result file shows: year, month, day
6. deleting the folder "backups"
7. Automatically downloading the zip file to a default folder (D:\\server-backups...) (can be edited)
