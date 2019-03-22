apt install figlet
cd /usr/bin/
wget https://raw.githubusercontent.com/lm0ser/debian9/master/motd/custom_motd
chmod +x custom_motd
echo 'custom_motd' >> /etc/update-motd.d/10-uname
