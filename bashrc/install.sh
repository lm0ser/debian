#!/bin/bash
################################################################
#	Probléme Putty - Copier-Coller
#	Modifier le fichier /usr/share/vim/vim80/defaults.vim
#	et mettre en commentaire 
#	if has('mouse')
#		set mouse=a
#	endif
#################################################################
#=============================================================================
# Configuration bashrc
#=============================================================================
cat > "$HOME"/.bashrc << EOL
#cat > /etc/profile.d/bash.sh << EOL
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

random-string()
{
cat /dev/urandom | tr -dc '123456789!@#$%,;abcdefghijklmnopqrstuvwxyziABCDEFGHIJKLMNOPQRSTUVWXYZ' | fold -w ${1:-50} | head -n 1
}

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


EOL
