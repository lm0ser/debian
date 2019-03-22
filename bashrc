#!/bin/bash
################################################################
#	Probléme Putty - Copier-Coller
#	Modifier le fichier /usr/share/vim/vim80/defaults.vim
#	et mettre en commentaire 
#	if has('mouse')
#		set mouse=a
#	endif
#################################################################
#    debserver9 - a bunch of functions used in the other scripts
#
#    DEBServer9 - Debian Install Server Scripts
#    A set of scripts to automate installation of Servers on Debian
#    Copyright (c) 2016 Frédéric LIETART - stuff@thelinuxfr.org
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Syntaxe: # su - -c "./debserver"
# Syntaxe: or # sudo ./debserver
# VERSION="9-20170608"

#=============================================================================
# Liste des applications à installer: A adapter a vos besoins
# Voir plus bas les applications necessitant un depot specifique
LISTE="ntp htop tree most ccze iftop molly-guard manpages-fr manpages-fr-extra tmux bash-completion needrestart wget btrfs-tools vim neofetch figlet"
#=============================================================================

#=============================================================================
# Test que le script est lance en root
#=============================================================================
if [ $EUID -ne 0 ]; then
  echo "Le script doit être lancé en root: # sudo $0" 1>&2
  exit 1
fi
#=============================================================================

#=============================================================================
# Test si version de Debian OK
#=============================================================================
if [ "$(cut -d. -f1 /etc/debian_version)" == "9" ]; then
				echo "Version compatible, début de l'installation"
else
        echo "Script non compatible avec votre version de Debian" 1>&2
        exit 1
fi
#=============================================================================

#=============================================================================
# Mise a jour de la liste des depots
#=============================================================================
#echo "
#deb http://deb.debian.org/debian/ stretch main contrib non-free
#deb-src http://deb.debian.org/debian/ stretch main contrib non-free

#deb http://deb.debian.org/debian/ stretch-updates main contrib non-free
#deb-src http://deb.debian.org/debian/ stretch-updates main contrib non-free

#deb http://deb.debian.org/debian-security stretch/updates main
#deb-src http://deb.debian.org/debian-security stretch/updates main

###Third Parties Repos
## Deb-multimedia.org
#deb http://www.deb-multimedia.org stretch main non-free

## Debian Backports
#deb http://deb.debian.org/debian stretch-backports main

## HWRaid
# wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | sudo apt-key add -
#deb http://hwraid.le-vert.net/debian stretch main" > /etc/apt/sources.list
#=============================================================================

#=============================================================================
# Update
#=============================================================================
#echo -e "\033[34m========================================================================================================\033[0m"
#echo "Mise à jour de la liste des dépôts"
#echo -e "\033[34m========================================================================================================\033[0m"
apt-get update
clear
#=============================================================================

#=============================================================================
# Upgrade
#=============================================================================
echo -e "\033[34m========================================================================================================\033[0m"
echo "Mise à jour du système"
echo -e "\033[34m========================================================================================================\033[0m"
apt-get upgrade
clear
#=============================================================================

#=============================================================================
# Installation
#=============================================================================
echo -e "\033[34m========================================================================================================\033[0m"
echo "Installation des logiciels suivants: $LISTE"
echo -e "\033[34m========================================================================================================\033[0m"
apt-get -y install $LISTE
#=============================================================================

#=============================================================================
# Configuration bashrc
#=============================================================================
cat > "$HOME"/.bashrc << EOL
#-------------------
# Alias
#-------------------
# la couleur pour chaque type de fichier, les répertoires s'affichent en premier
alias ls='ls -h --color --group-directories-first'
# affiche les fichiers cachés
alias lsa='ls -A'
# affiche en mode liste détail
alias ll='ls -ls'
# affiche en mode liste détail + fichiers cachés
alias lla='ls -Al'
# tri par extension
alias lx='ls -lXB'
 # tri par taille, le plus lourd à la fin
alias lk='ls -lSr'
# tri par date de modification, la plus récente à la fin
alias lc='ls -ltcr'
# tri par date d’accès, la plus récente à la fin
alias lu='ls -ltur'
# tri par date, la plus récente à la fin
alias lt='ls -ltr'
# Pipe a travers 'more'
alias lm='ls -al | more'
# ls récurssif
alias lr='ls -lR'
# affciche sous forme d'arborescence, nécessite le paquet tree
alias tree='tree -Csu'
# affiche les dernière d'un fichier log (par exemple) en live
alias voirlog='tail -f'
# commande df avec l'option -human
alias df='df -kTh'
# commande du avec l'option -human
alias du='du -kh'
# commande du avec l'option -human, au niveau du répertoire courant
alias duc='du -kh --max-depth=1'
# commande free avec l'option affichage en Mo
alias free='free -m'
# nécessite le paquet "htop", un top amélioré et en couleur
alias top='htop'
# faire une recherche dans l'historique de commande
alias shistory='history | grep'
# raccourci history
alias h='history'

# History length
HISTSIZE=10000
HISTFILESIZE=20000

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

# Ajout log en couleurs
ctail() { tail -f \$1 | ccze -A; }
cless() { ccze -A < \$1 | less -R; }

#set a fancy prompt (non-color, unless we know we want color)
PS1="\\\[\\\033[01;31m\\\][\\\u@\\\h\\\[\\\033[00m\\\]:\\\[\\\033[01;34m\\\]\\\w]\\\[\\\033[00m\\\]\\\$ "

# activation date_heure dans la commande history
export HISTTIMEFORMAT="%Y/%m/%d_%T : "

# les pages de man en couleur, necessite le paquet most
export PAGER=most

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


EOL


clear
#=============================================================================

#=============================================================================
# Email admin
#=============================================================================
echo -ne "\033[32;1mAdresse mail pour les rapports de sécurité: \033[0m"
read -r MAIL
#=============================================================================

#=============================================================================
# Reconfigure openssh-server !
#=============================================================================
echo -ne "\033[32;1mVoulez-vous autoriser l'accès root via SSH (y/N): \033[0m"
read -r SSHROOT
: "${SSHROOT:="N"}"
if [[ ${SSHROOT} == [Yy] ]]; then
	echo 'openssh-server openssh-server/permit-root-login boolean true' | debconf-set-selections
	sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
	systemctl restart ssh.service
fi
#=============================================================================

#=============================================================================
# Reconfigure locales !
#=============================================================================
echo -ne "\033[32;1mVoulez-vous reconfigurer locales (y/N): \033[0m"
read -r LOCALES
: "${LOCALES:="N"}"
if [[ ${LOCALES} == [Yy] ]]; then
	dpkg-reconfigure locales
fi
#=============================================================================

#=============================================================================
# Install beep
#=============================================================================
echo -ne "\033[32;1mVoulez-vous mettre en place un bip au démarrage/extinction de la machine (y/N): \033[0m"
read -r BEEP
: "${BEEP:="N"}"
if [[ ${BEEP} == [Yy] ]]; then
	apt-get install -y beep
	cat > /etc/init.d/beep << EOL
#!/bin/sh

### BEGIN INIT INFO
# Provides:          beep
# Required-Start:    $all
# Required-Stop:     $all
# Should-Start:
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Beeps after system start or before shutdown
### END INIT INFO

case "$1" in
	start|"")
		/usr/bin/beep -l 125 -f 500 &&
		/usr/bin/beep -l 125 -f 1000 &&
		/usr/bin/beep -l 125 -f 2000 &&
		/usr/bin/beep -l 125 -f 3000 &&
		/usr/bin/beep -l 125 -f 4000 &&
		/usr/bin/beep -l 125 -f 5000
		;;
		stop)
	    /usr/bin/beep -l 125 -f 5000 &&
	    /usr/bin/beep -l 125 -f 4000 &&
	    /usr/bin/beep -l 125 -f 3000 &&
	    /usr/bin/beep -l 125 -f 2000 &&
	    /usr/bin/beep -l 125 -f 1000 &&
	    /usr/bin/beep -l 125 -f 500
	    ;;
		*)
	    echo "Usage: beep [start|stop]" >&2
	    exit 3
	    ;;
esac
EOL

chmod +x /etc/init.d/beep && update-rc.d beep defaults
fi
#=============================================================================

#=============================================================================
# Désactiver les paquets recommandés !
#=============================================================================
echo -ne "\033[31;1mATTENTION : Voulez-vous désactiver l'installation de paquets recommandés (y/N): \033[0m"
read -r NORECOMMENDS
: "${NORECOMMENDS:="N"}"
if [[ ${NORECOMMENDS} == [Yy] ]]; then
    echo "APT::Install-Recommends \"0\";
    APT::Install-Suggests \"0\"; " > /etc/apt/apt.conf
fi
#=============================================================================
clear

#=============================================================================
# Config reseau
#=============================================================================
echo "
# The primary network interface
#allow-hotplug eth0
#iface eth0 inet static
#	address 192.168.x.1
#	netmask 255.255.255.0
#	network 192.168.x.0
#	broadcast 192.168.x.255
#	gateway 192.168.x.254
#	dns-nameservers 192.168.x.1 x.x.x.x
#	dns-search domain.com

## Multi-IP ##
#auto eth0:0
#iface eth0:0 inet static
#    address 192.168.x.41
#    netmask 255.255.255.0
#    network 192.168.x.0
#    broadcast 192.168.x.255
#    gateway 192.168.x.254
#    dns-nameservers 192.168.x.1 x.x.x.x
#    dns-search domain.com
##

## Bonding ##
## apt-get install ifenslave-2.6
#iface bond0 inet static
#	address 192.168.x.1
#	netmask 255.255.255.0
#	network 192.168.x.0
#	broadcast 192.168.x.255
#	gateway 192.168.x.254
#	dns-nameservers 192.168.x.1 x.x.x.x
#	dns-search domain.com
#	bond-slaves eth0 eth1
#	bond-mode 1
#	bond-miimon 100
#	bond-primary eth0 eth1
##

## VLAN ##
# modprobe 8021q && apt-get install vlan
#iface vlanXX inet static
#        address 10.30.10.12
#        netmask 255.255.0.0
#        network 10.30.0.0
#        broadcast 10.30.255.255
#        vlan-raw-device eth0
##
" > /etc/network/interfaces.exemple
echo -e "\033[34m========================================================================================================\033[0m"
echo -e "Ajout d'exemple de configuration dans /etc/network/interfaces.exemple"
echo -e "\033[34m========================================================================================================\033[0m"
sleep 5
clear
#=============================================================================

#=============================================================================
# Install apt-listbugs
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer apt-listbugs (y/N): \033[0m"
read -r APTLISTBUGS
: "${APTLISTBUGS:="N"}"
if [[ ${APTLISTBUGS} == [Yy] ]]; then
	apt-get install -y apt-listbugs
fi
#=============================================================================

#=============================================================================
# Install smartmontools
echo -ne "\033[32;1mVoulez-vous installer smartmontools (y/N): \033[0m"
read -r SMART
: "${SMART:="N"}"
if [[ ${SMART} == [Yy] ]]; then
	apt-get install -y smartmontools
fi
#=============================================================================

#=============================================================================
# Install hdparm
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer hdparm (y/N): \033[0m"
read -r HDPARM
: "${HDPARM:="N"}"
if [[ ${HDPARM} == [Yy] ]]; then
	apt-get install -y hdparm
fi
#=============================================================================

#=============================================================================
# Install lm-sensors
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer lm-sensors (y/N): \033[0m"
read -r LMSENSORS
: "${LMSENSORS:="N"}"
if [[ ${LMSENSORS} == [Yy] ]]; then
	apt-get install -y lm-sensors
  yes | sensors-detect > /dev/null &
fi
#=============================================================================

#=============================================================================
# Configuration cron-apt
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer cron-apt (y/N): \033[0m"
read -r CRONAPT
: "${CRONAPT:="N"}"
if [[ ${CRONAPT} == [Yy] ]]; then
    apt-get -y install -y cron-apt
	echo "
APTCOMMAND=/usr/bin/apt-get
MAILTO=\"$MAIL\"
MAILON=\"upgrade\"" > /etc/cron-apt/config
echo -ne "\033[32;1mVoulez-vous installer les mises à jours automatiquement (Y/n): \033[0m"
read -r CRONAPTAUTO
: "${CRONAPTAUTO:="Y"}"
if [[ ${CRONAPTAUTO} == [Yy] ]]; then
    echo "dist-upgrade -y -o APT::Get::Show-Upgraded=true" > /etc/cron-apt/action.d/5-install
fi
fi
#=============================================================================

#=============================================================================
# Configuration Proxy APT
#=============================================================================
echo -ne "\033[32;1mVoulez-vous vous raccorder à un proxy APT (y/N): \033[0m"
read -r PROXY
: "${PROXY:="N"}"
if [[ ${PROXY} == [Yy] ]]; then
	echo -e "IP et port du proxy (example : 192.168.1.1:9999) ?"
	read -r IPPROXY
	echo "Acquire::http::Proxy \"http://${IPPROXY}\";" > /etc/apt/apt.conf.d/01proxy
fi
#=============================================================================

#=============================================================================
# Install Webmin
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer Webmin (y/N): \033[0m"
read -r WEBMIN
: "${WEBMIN:="N"}"
if [[ ${WEBMIN} == [Yy] ]]; then
	wget http://prdownloads.sourceforge.net/webadmin/webmin_1.801_all.deb &&
	dpkg --install webmin_1.801_all.deb ||
	apt-get install -fy &&
	rm webmin_1.801_all.deb
fi
#=============================================================================

#=============================================================================
# Install Avahi
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer Avahi Daemon (y/N): \033[0m"
read -r AVAHI
: "${AVAHI:="N"}"
if [[ ${AVAHI} == [Yy] ]]; then
	apt-get install -y avahi-daemon
	echo -e "\033[34m========================================================================================================\033[0m"
	echo -e "Veuillez vérifier le fichier /etc/nsswitch.conf"
	echo -e "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4 mdns"
	echo -e "\033[34m========================================================================================================\033[0m"
	sleep 5
fi
#=============================================================================

#=============================================================================
# Install Glances
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer Glances (y/N): \033[0m"
read -r GLANCES
: "${GLANCES:="N"}"
if [[ ${GLANCES} == [Yy] ]]; then
  echo -ne "\033[32;1mVoulez-vous installer Glances via PIP (y/N): \033[0m"
  read -r GLANCESPIP
  if [[ ${GLANCESPIP} == [Yy] ]]; then
	   wget -O- http://bit.ly/glances | /bin/bash
    else apt-get install -y glances
  fi
fi
#=============================================================================

#=============================================================================
# Install cheat (via pip) https://github.com/chrisallenlane/cheat
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer Cheat (via pip) (y/N): \033[0m"
read -r CHEAT
: "${CHEAT:="N"}"
if [[ ${CHEAT} == [Yy] ]]; then
	apt-get install -y python-pip
  pip install cheat
fi
#=============================================================================

#=============================================================================
# Install UFW
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer UFW (y/N): \033[0m"
read -r UFW
: "${UFW:="N"}"
if [[ ${UFW} == [Yy] ]]; then
	apt-get install -y ufw
    ufw allow ssh
    ufw logging on
    ufw enable
fi
#=============================================================================

#=============================================================================
# Install fail2ban & rkhunter
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer des systèmes anti-malwares/bruteforce (y/N): \033[0m"
read -r FAIL2BAN
: "${FAIL2BAN:="N"}"
if [[ ${FAIL2BAN} == [Yy] ]]; then
	apt-get install -y fail2ban rkhunter
  dpkg-reconfigure rkhunter
fi
#=============================================================================

#=============================================================================
# Install open-vm-tools
#=============================================================================
echo -ne "\033[32;1mVoulez-vous installer les VMware Tools (y/N): \033[0m"
read -r OPENVMTOOLS
: "${OPENVMTOOLS:="N"}"
if [[ ${OPENVMTOOLS} == [Yy] ]]; then
	apt-get install -y open-vm-tools
fi
#=============================================================================
#=============================================================================
# Install Issue personnalisé
#=============================================================================
#echo -ne "\033[32;1mVoulez-vous une bannière de connexion personnalisée (y/N): \033[0m"
#read -r ISSUE
#: "${ISSUE:="N"}"
#if [[ ${ISSUE} == [Yy] ]]; then
#	wget http://dl.thelinuxfr.org/contribs/issue && mv issue /etc/issue
#fi
#=============================================================================

#=============================================================================
# END
#=============================================================================
clear
echo -e "\033[34m========================================================================================================\033[0m"
echo "Liste d'applications utiles installées :"
echo "$LISTE"
echo ""
echo "Pensez à aller dans /etc/default pour configurer les daemons smartmontools hdparm"
echo ""
echo "Notes de publication : https://www.debian.org/releases/stretch/releasenotes"
echo "Manuel d'installation : https://www.debian.org/releases/stretch/installmanual"
echo ""
echo "Le cahier de l'administrateur Debian : https://debian-handbook.info/browse/fr-FR/stable/"
echo -e "\033[34m========================================================================================================\033[0m"
#=============================================================================
