# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-common.local

# The following block breaks trash functionality in file managers
#read-only ${HOME}/.local
#read-write ${HOME}/.local/share
blacklist ${HOME}/.local/share/Trash

# History files in $HOME and clipboard managers
blacklist-nolog ${HOME}/.*_history
blacklist-nolog ${HOME}/.adobe
blacklist-nolog ${HOME}/.cache/greenclip*
blacklist-nolog ${HOME}/.histfile
blacklist-nolog ${HOME}/.history
blacklist-nolog ${HOME}/.kde/share/apps/klipper
blacklist-nolog ${HOME}/.kde4/share/apps/klipper
blacklist-nolog ${HOME}/.local/share/fish/fish_history
blacklist-nolog ${HOME}/.local/share/klipper
blacklist-nolog ${HOME}/.macromedia
blacklist-nolog ${HOME}/.python-history
blacklist-nolog ${HOME}/.pythonhist
blacklist-nolog /tmp/clipmenu*

# X11 session autostart
# blacklist ${HOME}/.xpra - this will kill --x11=xpra cmdline option for all programs
blacklist ${HOME}/.Xsession
blacklist ${HOME}/.blackbox
blacklist ${HOME}/.config/autostart
blacklist ${HOME}/.config/autostart-scripts
blacklist ${HOME}/.config/awesome
blacklist ${HOME}/.config/i3
blacklist ${HOME}/.config/lxsession/LXDE/autostart
blacklist ${HOME}/.config/openbox
blacklist ${HOME}/.config/plasma-workspace
blacklist ${HOME}/.config/startupconfig
blacklist ${HOME}/.config/startupconfigkeys
blacklist ${HOME}/.fluxbox
blacklist ${HOME}/.gnomerc
blacklist ${HOME}/.kde/Autostart
blacklist ${HOME}/.kde/env
blacklist ${HOME}/.kde/share/autostart
blacklist ${HOME}/.kde/share/config/startupconfig
blacklist ${HOME}/.kde/share/config/startupconfigkeys
blacklist ${HOME}/.kde/shutdown
blacklist ${HOME}/.kde4/env
blacklist ${HOME}/.kde4/Autostart
blacklist ${HOME}/.kde4/share/autostart
blacklist ${HOME}/.kde4/shutdown
blacklist ${HOME}/.kde4/share/config/startupconfig
blacklist ${HOME}/.kde4/share/config/startupconfigkeys
blacklist ${HOME}/.local/share/autostart
blacklist ${HOME}/.xinitrc
blacklist ${HOME}/.xprofile
blacklist ${HOME}/.xserverrc
blacklist ${HOME}/.xsession
blacklist ${HOME}/.xsessionrc
blacklist /etc/X11/Xsession.d
blacklist /etc/xdg/autostart
read-only ${HOME}/.Xauthority

# KDE config
blacklist ${HOME}/.config/khotkeysrc
blacklist ${HOME}/.config/krunnerrc
blacklist ${HOME}/.config/kscreenlockerrc
blacklist ${HOME}/.config/ksslcertificatemanager
blacklist ${HOME}/.config/kwinrc
blacklist ${HOME}/.config/kwinrulesrc
blacklist ${HOME}/.config/plasma-org.kde.plasma.desktop-appletsrc
blacklist ${HOME}/.config/plasmashellrc
blacklist ${HOME}/.config/plasmavaultrc
blacklist ${HOME}/.kde/share/apps/kwin
blacklist ${HOME}/.kde/share/apps/plasma
blacklist ${HOME}/.kde/share/apps/solid
blacklist ${HOME}/.kde/share/config/khotkeysrc
blacklist ${HOME}/.kde/share/config/krunnerrc
blacklist ${HOME}/.kde/share/config/kscreensaverrc
blacklist ${HOME}/.kde/share/config/ksslcertificatemanager
blacklist ${HOME}/.kde/share/config/kwinrc
blacklist ${HOME}/.kde/share/config/kwinrulesrc
blacklist ${HOME}/.kde/share/config/plasma-desktop-appletsrc
blacklist ${HOME}/.kde4/share/apps/kwin
blacklist ${HOME}/.kde4/share/apps/plasma
blacklist ${HOME}/.kde4/share/apps/solid
blacklist ${HOME}/.kde4/share/config/khotkeysrc
blacklist ${HOME}/.kde4/share/config/krunnerrc
blacklist ${HOME}/.kde4/share/config/kscreensaverrc
blacklist ${HOME}/.kde4/share/config/ksslcertificatemanager
blacklist ${HOME}/.kde4/share/config/kwinrc
blacklist ${HOME}/.kde4/share/config/kwinrulesrc
blacklist ${HOME}/.kde4/share/config/plasma-desktop-appletsrc
blacklist ${HOME}/.local/share/kglobalaccel
blacklist ${HOME}/.local/share/kwin
blacklist ${HOME}/.local/share/plasma
blacklist ${HOME}/.local/share/plasmashell
blacklist ${HOME}/.local/share/solid
read-only ${HOME}/.cache/ksycoca5_*
read-only ${HOME}/.config/*notifyrc
read-only ${HOME}/.config/kdeglobals
read-only ${HOME}/.config/kio_httprc
read-only ${HOME}/.config/kiorc
read-only ${HOME}/.config/kioslaverc
read-only ${HOME}/.config/ksslcablacklist
read-only ${HOME}/.kde/share/apps/konsole
read-only ${HOME}/.kde/share/apps/kssl
read-only ${HOME}/.kde/share/config/*notifyrc
read-only ${HOME}/.kde/share/config/kdeglobals
read-only ${HOME}/.kde/share/config/kio_httprc
read-only ${HOME}/.kde/share/config/kioslaverc
read-only ${HOME}/.kde/share/config/ksslcablacklist
read-only ${HOME}/.kde/share/kde4/services
read-only ${HOME}/.kde4/share/apps/konsole
read-only ${HOME}/.kde4/share/apps/kssl
read-only ${HOME}/.kde4/share/config/*notifyrc
read-only ${HOME}/.kde4/share/config/kdeglobals
read-only ${HOME}/.kde4/share/config/kio_httprc
read-only ${HOME}/.kde4/share/config/kioslaverc
read-only ${HOME}/.kde4/share/config/ksslcablacklist
read-only ${HOME}/.kde4/share/kde4/services
read-only ${HOME}/.local/share/konsole
read-only ${HOME}/.local/share/kservices5
read-only ${HOME}/.local/share/kssl

# KDE sockets
blacklist ${RUNUSER}/*.slave-socket
blacklist ${RUNUSER}/kdeinit5__*
blacklist ${RUNUSER}/kdesud_*
?HAS_NODBUS: blacklist ${RUNUSER}/ksocket-*
?HAS_NODBUS: blacklist /tmp/ksocket-*

# gnome
# contains extensions, last used times of applications, and notifications
blacklist ${HOME}/.local/share/gnome-shell

# systemd
blacklist ${HOME}/.config/systemd
blacklist ${HOME}/.local/share/systemd
blacklist /var/lib/systemd
# blacklist /var/run/systemd
# creates problems on Arch where /etc/resolv.conf is a symlink to /var/run/systemd/resolve/resolv.conf

# VirtualBox
blacklist ${HOME}/.VirtualBox
blacklist ${HOME}/.config/VirtualBox
blacklist ${HOME}/VirtualBox VMs

# VeraCrypt
blacklist ${HOME}/.VeraCrypt
blacklist ${PATH}/veracrypt
blacklist ${PATH}/veracrypt-uninstall.sh
blacklist /usr/share/applications/veracrypt.*
blacklist /usr/share/pixmaps/veracrypt.*
blacklist /usr/share/veracrypt

# TrueCrypt
blacklist ${HOME}/.TrueCrypt
blacklist ${PATH}/truecrypt
blacklist ${PATH}/truecrypt-uninstall.sh
blacklist /usr/share/applications/truecrypt.*
blacklist /usr/share/pixmaps/truecrypt.*
blacklist /usr/share/truecrypt

# zuluCrypt
blacklist ${HOME}/.zuluCrypt
blacklist ${HOME}/.zuluCrypt-socket
blacklist ${PATH}/zuluCrypt-cli
blacklist ${PATH}/zuluMount-cli

# var
blacklist /var/cache/apt
blacklist /var/cache/pacman
blacklist /var/lib/apt
blacklist /var/lib/clamav
blacklist /var/lib/dkms
blacklist /var/lib/mysql/mysql.sock
blacklist /var/lib/mysqld/mysql.sock
blacklist /var/lib/pacman
blacklist /var/lib/upower
# blacklist /var/log - a virtual /var/log directory (mostly empty) is build up by default for
# every sandbox, unless --writeble-var-log switch is activated
blacklist /var/mail
blacklist /var/opt
blacklist /var/run/acpid.socket
blacklist /var/run/docker.sock
blacklist /var/run/minissdpd.sock
blacklist /var/run/mysql/mysqld.sock
blacklist /var/run/mysqld/mysqld.sock
blacklist /var/run/rpcbind.sock
blacklist /var/run/screens
blacklist /var/spool/anacron
blacklist /var/spool/cron
blacklist /var/spool/mail

# etc
blacklist /etc/anacrontab
blacklist /etc/cron*
blacklist /etc/profile.d
blacklist /etc/rc.local
# rc1.d, rc2.d, ...
blacklist /etc/rc?.d
blacklist /etc/kernel*
blacklist /etc/grub*
blacklist /etc/dkms
blacklist /etc/apparmor*
blacklist /etc/selinux
blacklist /etc/modules*
blacklist /etc/logrotate*
blacklist /etc/adduser.conf

# Startup files
read-only ${HOME}/.antigen
read-only ${HOME}/.bash_aliases
read-only ${HOME}/.bash_login
read-only ${HOME}/.bash_logout
read-only ${HOME}/.bash_profile
read-only ${HOME}/.bashrc
read-only ${HOME}/.config/fish
read-only ${HOME}/.csh_files
read-only ${HOME}/.cshrc
read-only ${HOME}/.forward
read-only ${HOME}/.local/share/fish
read-only ${HOME}/.login
read-only ${HOME}/.logout
read-only ${HOME}/.oh-my-zsh
read-only ${HOME}/.pam_environment
read-only ${HOME}/.pgpkey
read-only ${HOME}/.plan
read-only ${HOME}/.profile
read-only ${HOME}/.project
read-only ${HOME}/.tcshrc
read-only ${HOME}/.zlogin
read-only ${HOME}/.zlogout
read-only ${HOME}/.zprofile
read-only ${HOME}/.zsh.d
read-only ${HOME}/.zsh_files
read-only ${HOME}/.zshenv
read-only ${HOME}/.zshrc
read-only ${HOME}/.zshrc.local

# Remote access
read-only ${HOME}/.ssh/authorized_keys

# Initialization files that allow arbitrary command execution
read-only ${HOME}/.caffrc
read-only ${HOME}/.cargo/env
read-only ${HOME}/.dotfiles
read-only ${HOME}/.emacs
read-only ${HOME}/.emacs.d
read-only ${HOME}/.exrc
read-only ${HOME}/.gvimrc
read-only ${HOME}/.homesick
read-only ${HOME}/.iscreenrc
read-only ${HOME}/.mailcap
read-only ${HOME}/.msmtprc
read-only ${HOME}/.mutt/muttrc
read-only ${HOME}/.muttrc
read-only ${HOME}/.nano
read-only ${HOME}/.pythonrc.py
read-only ${HOME}/.reportbugrc
read-only ${HOME}/.tmux.conf
read-only ${HOME}/.vim
read-only ${HOME}/.viminfo
read-only ${HOME}/.vimrc
read-only ${HOME}/.xmonad
read-only ${HOME}/.xscreensaver
read-only ${HOME}/_exrc
read-only ${HOME}/_gvimrc
read-only ${HOME}/_vimrc
read-only ${HOME}/dotfiles

# Make directories commonly found in $PATH read-only
read-only ${HOME}/.gem
read-only ${HOME}/.luarocks
read-only ${HOME}/.npm-packages
read-only ${HOME}/bin
read-only ${HOME}/.bin
read-only ${HOME}/.local/bin
read-only ${HOME}/.cargo/bin
blacklist ${HOME}/.cargo/registry
blacklist ${HOME}/.cargo/config

# Write-protection for desktop entries
read-only ${HOME}/.config/menus
read-only ${HOME}/.local/share/applications

# Write-protection for thumbnailer dir
read-only ${HOME}/.local/share/thumbnailers

# top secret
blacklist ${HOME}/*.kdb
blacklist ${HOME}/*.kdbx
blacklist ${HOME}/*.key
blacklist ${HOME}/.Private
blacklist ${HOME}/.caff
blacklist ${HOME}/.cert
blacklist ${HOME}/.config/keybase
blacklist ${HOME}/.davfs2/secrets
blacklist ${HOME}/.ecryptfs
blacklist ${HOME}/.fetchmailrc
blacklist ${HOME}/.gnome2/keyrings
blacklist ${HOME}/.gnupg
blacklist ${HOME}/.config/hub
blacklist ${HOME}/.kde/share/apps/kwallet
blacklist ${HOME}/.kde4/share/apps/kwallet
blacklist ${HOME}/.local/share/keyrings
blacklist ${HOME}/.local/share/kwalletd
blacklist ${HOME}/.local/share/plasma-vault
blacklist ${HOME}/.msmtprc
blacklist ${HOME}/.mutt
blacklist ${HOME}/.muttrc
blacklist ${HOME}/.netrc
blacklist ${HOME}/.nyx
blacklist ${HOME}/.pki
blacklist ${HOME}/.local/share/pki
blacklist ${HOME}/.smbcredentials
blacklist ${HOME}/.ssh
blacklist ${HOME}/.vaults
blacklist /etc/davfs2/secrets
blacklist /etc/group+
blacklist /etc/group-
blacklist /etc/gshadow
blacklist /etc/gshadow+
blacklist /etc/gshadow-
blacklist /etc/passwd+
blacklist /etc/passwd-
blacklist /etc/shadow
blacklist /etc/shadow+
blacklist /etc/shadow-
blacklist /etc/ssh
blacklist /home/.ecryptfs
blacklist /var/backup

# cloud provider configuration
blacklist ${HOME}/.aws
blacklist ${HOME}/.boto
blacklist ${HOME}/.config/gcloud
blacklist ${HOME}/.kube
blacklist ${HOME}/.passwd-s3fs
blacklist ${HOME}/.s3cmd
blacklist /etc/boto.cfg

# system directories
blacklist /sbin
blacklist /usr/local/sbin
blacklist /usr/sbin

# system management
blacklist ${PATH}/at
blacklist ${PATH}/chage
blacklist ${PATH}/chfn
blacklist ${PATH}/chsh
blacklist ${PATH}/crontab
blacklist ${PATH}/evtest
blacklist ${PATH}/expiry
blacklist ${PATH}/fusermount
blacklist ${PATH}/gpasswd
blacklist ${PATH}/ksu
blacklist ${PATH}/mount
blacklist ${PATH}/mount.ecryptfs_private
blacklist ${PATH}/nc
blacklist ${PATH}/ncat
blacklist ${PATH}/newgidmap
blacklist ${PATH}/newgrp
blacklist ${PATH}/newuidmap
blacklist ${PATH}/ntfs-3g
blacklist ${PATH}/pkexec
blacklist ${PATH}/procmail
blacklist ${PATH}/sg
blacklist ${PATH}/strace
blacklist ${PATH}/su
blacklist ${PATH}/sudo
blacklist ${PATH}/umount
blacklist ${PATH}/unix_chkpwd
blacklist ${PATH}/xev
blacklist ${PATH}/xinput

# other SUID binaries
blacklist /usr/lib/virtualbox
blacklist /usr/lib64/virtualbox

# prevent lxterminal connecting to an existing lxterminal session
blacklist /tmp/.lxterminal-socket*
# prevent tmux connecting to an existing session
blacklist /tmp/tmux-*

# disable terminals running as server resulting in sandbox escape
blacklist ${PATH}/lxterminal
blacklist ${PATH}/gnome-terminal
blacklist ${PATH}/gnome-terminal.wrapper
blacklist ${PATH}/lilyterm
blacklist ${PATH}/mate-terminal
blacklist ${PATH}/mate-terminal.wrapper
blacklist ${PATH}/pantheon-terminal
blacklist ${PATH}/roxterm
blacklist ${PATH}/roxterm-config
blacklist ${PATH}/terminix
blacklist ${PATH}/tilix
blacklist ${PATH}/urxvtc
blacklist ${PATH}/urxvtcd
blacklist ${PATH}/xfce4-terminal
blacklist ${PATH}/xfce4-terminal.wrapper
# blacklist ${PATH}/konsole
# konsole doesn't seem to have this problem - last tested on Ubuntu 16.04

# kernel files
blacklist /initrd*
blacklist /vmlinuz*

# snapshot files
blacklist /.snapshots

# flatpak
blacklist ${HOME}/.config/flatpak
blacklist ${HOME}/.local/share/flatpak
blacklist ${HOME}/.var
blacklist /usr/share/flatpak
blacklist /var/lib/flatpak
# most of the time bwrap is SUID binary
blacklist ${PATH}/bwrap

# mail directories used by mutt
blacklist ${HOME}/.Mail
blacklist ${HOME}/.mail
blacklist ${HOME}/.signature
blacklist ${HOME}/Mail
blacklist ${HOME}/mail
blacklist ${HOME}/postponed
blacklist ${HOME}/sent
