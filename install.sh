apt install figlet
cd /usr/bin/
wget https://raw.githubusercontent.com/lm0ser/motd/master/custom_motd
chmod +x custom_motd
echo 'custom_motd' >> /etc/profile
