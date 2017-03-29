# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-common.local

# History files in $HOME
blacklist-nolog ${HOME}/.history
blacklist-nolog ${HOME}/.*_history
blacklist-nolog ${HOME}/.bash_history
blacklist ${HOME}/.local/share/systemd
blacklist ${HOME}/.config/systemd
blacklist-nolog ${HOME}/.adobe
blacklist-nolog ${HOME}/.macromedia
read-only ${HOME}/.local/share/applications

# X11 session autostart
blacklist ${HOME}/.xinitrc
blacklist ${HOME}/.xserverrc
blacklist /etc/X11/Xsession.d
blacklist ${HOME}/.Xsession
blacklist ${HOME}/.xsession
blacklist ${HOME}/.xsessionrc
blacklist ${HOME}/.xprofile
blacklist ${HOME}/.gnomerc
blacklist /etc/xdg/autostart
blacklist ${HOME}/.config/autostart
blacklist ${HOME}/.local/share/autostart
blacklist ${HOME}/.kde4/share/config/startupconfig
blacklist ${HOME}/.kde4/env
blacklist ${HOME}/.kde4/Autostart
blacklist ${HOME}/.kde4/share/autostart
blacklist ${HOME}/.kde4/shutdown
blacklist ${HOME}/.kde/share/config/startupconfig
blacklist ${HOME}/.kde/env
blacklist ${HOME}/.kde/Autostart
blacklist ${HOME}/.kde/share/autostart
blacklist ${HOME}/.kde/shutdown
blacklist ${HOME}/.config/startupconfig
blacklist ${HOME}/.config/autostart-scripts
blacklist ${HOME}/.config/plasma-workspace/env
blacklist ${HOME}/.config/plasma-workspace/shutdown
blacklist ${HOME}/.config/lxsession/LXDE/autostart
blacklist ${HOME}/.config/openbox/autostart
blacklist ${HOME}/.config/openbox/environment
blacklist ${HOME}/.fluxbox/startup
# blacklist ${HOME}/.xpra - this will kill --x11=xpra cmdline option for all programs

# KDE config
blacklist ${HOME}/.kde4/share/apps/solid
blacklist ${HOME}/.kde4/share/apps/konsole
blacklist ${HOME}/.kde4/share/config/*.notifyrc
blacklist ${HOME}/.kde4/share/config/khotkeysrc
blacklist ${HOME}/.kde4/share/config/krunnerrc
blacklist ${HOME}/.kde4/share/kde4/services
blacklist ${HOME}/.kde/share/apps/solid
blacklist ${HOME}/.kde/share/apps/konsole
blacklist ${HOME}/.kde/share/config/*.notifyrc
blacklist ${HOME}/.kde/share/config/khotkeysrc
blacklist ${HOME}/.kde/share/config/krunnerrc
blacklist ${HOME}/.kde/share/kde4/services
blacklist ${HOME}/.config/*.notifyrc
blacklist ${HOME}/.config/khotkeysrc
blacklist ${HOME}/.config/krunnerrc
blacklist ${HOME}/.local/share/kglobalaccel
blacklist ${HOME}/.local/share/konsole
blacklist ${HOME}/.local/share/kservices5
blacklist ${HOME}/.local/share/solid

# VirtualBox
blacklist ${HOME}/.VirtualBox
blacklist ${HOME}/VirtualBox VMs
blacklist ${HOME}/.config/VirtualBox

# VeraCrypt
blacklist ${PATH}/veracrypt
blacklist ${PATH}/veracrypt-uninstall.sh
blacklist /usr/share/veracrypt
blacklist /usr/share/applications/veracrypt.*
blacklist /usr/share/pixmaps/veracrypt.*
blacklist ${HOME}/.VeraCrypt

# TrueCrypt
blacklist ${PATH}/truecrypt
blacklist ${PATH}/truecrypt-uninstall.sh
blacklist /usr/share/truecrypt
blacklist /usr/share/applications/truecrypt.*
blacklist /usr/share/pixmaps/truecrypt.*
blacklist ${HOME}/.TrueCrypt

# zuluCrypt
blacklist ${HOME}/.zuluCrypt
blacklist ${HOME}/.zuluCrypt-socket
blacklist ${PATH}/zuluCrypt-cli
blacklist ${PATH}/zuluMount-cli

# var
blacklist /var/spool/cron
blacklist /var/spool/anacron
blacklist /var/mail
blacklist /var/run/acpid.socket
blacklist /var/run/minissdpd.sock
blacklist /var/run/rpcbind.sock
blacklist /var/run/mysqld/mysqld.sock
blacklist /var/run/mysql/mysqld.sock
blacklist /var/lib/mysqld/mysql.sock
blacklist /var/lib/mysql/mysql.sock
blacklist /var/run/docker.sock

# etc
blacklist /etc/cron*
blacklist /etc/profile.d
blacklist /etc/rc.local
blacklist /etc/anacrontab

# Startup files
read-only ${HOME}/.antigen
read-only ${HOME}/.bash_login
read-only ${HOME}/.bashrc
read-only ${HOME}/.bash_aliases
read-only ${HOME}/.bash_profile
read-only ${HOME}/.bash_logout
read-only ${HOME}/.zsh.d
read-only ${HOME}/.zshenv
read-only ${HOME}/.zshrc
read-only ${HOME}/.zshrc.local
read-only ${HOME}/.zlogin
read-only ${HOME}/.zprofile
read-only ${HOME}/.zlogout
read-only ${HOME}/.zsh_files
read-only ${HOME}/.tcshrc
read-only ${HOME}/.cshrc
read-only ${HOME}/.csh_files
read-only ${HOME}/.profile
read-only ${HOME}/.forward
read-only ${HOME}/.login
read-only ${HOME}/.logout
read-only ${HOME}/.pgpkey
read-only ${HOME}/.plan
read-only ${HOME}/.project

# Initialization files that allow arbitrary command execution
read-only ${HOME}/.caffrc
read-only ${HOME}/.dotfiles
read-only ${HOME}/dotfiles
read-only ${HOME}/.mailcap
read-only ${HOME}/.muttrc
read-only ${HOME}/.mutt/muttrc
read-only ${HOME}/.msmtprc
read-only ${HOME}/.exrc
read-only ${HOME}/_exrc
read-only ${HOME}/.vimrc
read-only ${HOME}/_vimrc
read-only ${HOME}/.gvimrc
read-only ${HOME}/_gvimrc
read-only ${HOME}/.vim
read-only ${HOME}/.emacs
read-only ${HOME}/.emacs.d
read-only ${HOME}/.nano
read-only ${HOME}/.tmux.conf
read-only ${HOME}/.iscreenrc
read-only ${HOME}/.reportbugrc
read-only ${HOME}/.xmonad
read-only ${HOME}/.xscreensaver

# Make directories commonly found in $PATH read-only
read-only ${HOME}/bin
read-only ${HOME}/.gem
read-only ${HOME}/.luarocks
read-only ${HOME}/.npm-packages

# Make the contents of ~/.local read-only,
#  except the commonly-used ~/.local/share
read-only  ${HOME}/.local
read-write ${HOME}/.local/share

# top secret
blacklist ${HOME}/.ecryptfs
blacklist ${HOME}/.Private
blacklist ${HOME}/.ssh
blacklist ${HOME}/.cert
blacklist ${HOME}/.gnome2/keyrings
blacklist ${HOME}/.local/share/keyrings
blacklist ${HOME}/.kde4/share/apps/kwallet
blacklist ${HOME}/.kde/share/apps/kwallet
blacklist ${HOME}/.local/share/kwalletd
blacklist ${HOME}/.config/keybase
blacklist ${HOME}/.netrc
blacklist ${HOME}/.gnupg
blacklist ${HOME}/.caff
blacklist ${HOME}/.smbcredentials
blacklist ${HOME}/*.kdbx
blacklist ${HOME}/*.kdb
blacklist ${HOME}/*.key
blacklist ${HOME}/.muttrc
blacklist ${HOME}/.mutt/muttrc
blacklist ${HOME}/.msmtprc
blacklist ${HOME}/.pki
blacklist /etc/shadow
blacklist /etc/gshadow
blacklist /etc/passwd-
blacklist /etc/group-
blacklist /etc/shadow-
blacklist /etc/gshadow-
blacklist /etc/passwd+
blacklist /etc/group+
blacklist /etc/shadow+
blacklist /etc/gshadow+
blacklist /etc/ssh
blacklist /var/backup
blacklist /home/.ecryptfs

# system directories
blacklist /sbin
blacklist /usr/sbin
blacklist /usr/local/sbin

# system management
blacklist ${PATH}/umount
blacklist ${PATH}/mount
blacklist ${PATH}/fusermount
blacklist ${PATH}/ntfs-3g
blacklist ${PATH}/at
blacklist ${PATH}/su
blacklist ${PATH}/sudo
blacklist ${PATH}/xinput
blacklist ${PATH}/evtest
blacklist ${PATH}/xev
blacklist ${PATH}/strace
blacklist ${PATH}/nc
blacklist ${PATH}/ncat
blacklist ${PATH}/gpasswd
blacklist ${PATH}/newgidmap
blacklist ${PATH}/newgrp
blacklist ${PATH}/newuidmap
blacklist ${PATH}/pkexec
blacklist ${PATH}/sg
blacklist ${PATH}/crontab
blacklist ${PATH}/ksu
blacklist ${PATH}/chsh
blacklist ${PATH}/chfn
blacklist ${PATH}/chage
blacklist ${PATH}/expiry
blacklist ${PATH}/unix_chkpwd
blacklist ${PATH}/procmail
blacklist ${PATH}/mount.ecryptfs_private

# other SUID binaries
blacklist /usr/lib/virtualbox
blacklist /usr/lib64/virtualbox

# prevent lxterminal connecting to an existing lxterminal session
blacklist /tmp/.lxterminal-socket*
# prevent tmux connecting to an existing session
blacklist /tmp/tmux-*

# disable terminals running as server resulting in sandbox escape
blacklist ${PATH}/gnome-terminal
blacklist ${PATH}/gnome-terminal.wrapper
blacklist ${PATH}/xfce4-terminal
blacklist ${PATH}/xfce4-terminal.wrapper
blacklist ${PATH}/mate-terminal
blacklist ${PATH}/mate-terminal.wrapper
blacklist ${PATH}/lilyterm
blacklist ${PATH}/pantheon-terminal
blacklist ${PATH}/roxterm
blacklist ${PATH}/roxterm-config
blacklist ${PATH}/terminix
blacklist ${PATH}/tilix
blacklist ${PATH}/urxvtc
blacklist ${PATH}/urxvtcd
# konsole doesn't seem to have this problem - last tested on Ubuntu 16.04
# blacklist ${PATH}/konsole

# kernel files
blacklist /vmlinuz*
blacklist /initrd*
