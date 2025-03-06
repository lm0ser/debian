#!/bin/bash

nc_login=admin
nc_password='toto'
mysql_user=nextcloud
mysql_password='toto'

cd /root

# Installation des composants
echo -e "\033[32mInstallation des composants\033[0m"
apt update
apt install -y sudo apache2 php libapache2-mod-php php-gd php-mysql php-curl php-mbstring php-xml php-zip php-intl php-imagick php-bcmath php-gmp mariadb-server mariadb-client python3-pymysql unzip

# Configuration de la base de données
echo -e "\033[32mConfiguration de la base de données\033[0m"
mysql -e "CREATE DATABASE nextcloud;"
mysql -e "CREATE USER '$mysql_user'@'localhost' IDENTIFIED BY '$mysql_password';"
mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO '$mysql_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Téléchargement et installation de Nextcloud
echo -e "\033[32mTéléchargement et installation de Nextcloud\033[0m"
wget https://download.nextcloud.com/server/releases/latest.zip
echo -e "\033[32mDécompression de l'archive\033[0m"
unzip -q latest.zip
rm latest.zip
mv nextcloud /var/www/html/
chown -R www-data:www-data /var/www/html/nextcloud

# Configuration d'Apache
echo -e "\033[32mConfiguration d'Apache\033[0m"
sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/nextcloud/' /etc/apache2/sites-available/000-default.conf
sed -i 's/<Directory \/var\/www\/html>/<Directory \/var\/www\/html\/nextcloud>/' /etc/apache2/apache2.conf
sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
a2enmod headers
a2enmod rewrite

# Redémarrage d'Apache
systemctl restart apache2

# Ajout de la tâche cron
echo -e "\033[32mAjout de la tâche cron\033[0m"
echo "*/5 * * * * www-data php -f /var/www/html/nextcloud/cron.php" >> /etc/crontab

# Provisionnement de Nextcloud
echo -e "\033[32mProvisionnement de Nextcloud\033[0m"
cd /var/www/html/nextcloud
sudo -u www-data php occ maintenance:install --database mysql --database-name nextcloud --database-host localhost --database-port 3306 --database-user $mysql_user --database-pass $mysql_password --admin-user "$nc_login" --admin-pass "$nc_password" --data-dir /var/www/html/nextcloud/data

echo -e "\033[32mInstallation terminée\033[0m"
echo -e "\033[32mLogin: $nc_login\033[0m"
echo -e "\033[32mPassword: $nc_password\033[0m"
echo -e "\033[32mURL: http://localhost:8080/\033[0m"
