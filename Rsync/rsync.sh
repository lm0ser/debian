#!/bin/bash

date=`date +%d-%B-%Y-%H:%M:%S`
local="/dossier/source/"
distant=/dossier/destination/
hostssh="X.X.X.X"
userssh="user"
passwordssh="mdp"
logfile="sync_backup_$(date +%d-%B-%Y-%H:%M:%S).log"

sshpass -p $passwordssh rsync -avzruh --stats --del --progress $local $userssh@$hostssh:$distant > $logfile 2>&1

if [ $? -eq 0 ]; then
        mail -s "Rsync backup termine - $(date +%d-%B-%Y-%H:%M:%S) for $(hostname)" email@domaine.com < $logfile
else
        mail -s "Rsync backup erreur - $(date +%d-%B-%Y-%H:%M:%S) for $(hostname)" email@domaine.com < $logfile
fi

exit 0
