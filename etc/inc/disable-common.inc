# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-common.local

# The following block breaks trash functionality in file managers
#read-only ${HOME}/.local
#read-write ${HOME}/.local/share
deny  ${HOME}/.local/share/Trash

# History files in $HOME and clipboard managers
deny-nolog  ${HOME}/.*_history
deny-nolog  ${HOME}/.adobe
deny-nolog  ${HOME}/.cache/greenclip*
deny-nolog  ${HOME}/.histfile
deny-nolog  ${HOME}/.history
deny-nolog  ${HOME}/.kde/share/apps/klipper
deny-nolog  ${HOME}/.kde4/share/apps/klipper
deny-nolog  ${HOME}/.local/share/fish/fish_history
deny-nolog  ${HOME}/.local/share/klipper
deny-nolog  ${HOME}/.macromedia
deny-nolog  ${HOME}/.mupdf.history
deny-nolog  ${HOME}/.python-history
deny-nolog  ${HOME}/.python_history
deny-nolog  ${HOME}/.pythonhist
deny-nolog  ${HOME}/.lesshst
deny-nolog  ${HOME}/.viminfo
deny-nolog  /tmp/clipmenu*

# X11 session autostart
# blacklist ${HOME}/.xpra - this will kill --x11=xpra cmdline option for all programs
deny  ${HOME}/.Xsession
deny  ${HOME}/.blackbox
deny  ${HOME}/.config/autostart
deny  ${HOME}/.config/autostart-scripts
deny  ${HOME}/.config/awesome
deny  ${HOME}/.config/i3
deny  ${HOME}/.config/sway
deny  ${HOME}/.config/lxsession/LXDE/autostart
deny  ${HOME}/.config/openbox
deny  ${HOME}/.config/plasma-workspace
deny  ${HOME}/.config/startupconfig
deny  ${HOME}/.config/startupconfigkeys
deny  ${HOME}/.fluxbox
deny  ${HOME}/.gnomerc
deny  ${HOME}/.kde/Autostart
deny  ${HOME}/.kde/env
deny  ${HOME}/.kde/share/autostart
deny  ${HOME}/.kde/share/config/startupconfig
deny  ${HOME}/.kde/share/config/startupconfigkeys
deny  ${HOME}/.kde/shutdown
deny  ${HOME}/.kde4/env
deny  ${HOME}/.kde4/Autostart
deny  ${HOME}/.kde4/share/autostart
deny  ${HOME}/.kde4/shutdown
deny  ${HOME}/.kde4/share/config/startupconfig
deny  ${HOME}/.kde4/share/config/startupconfigkeys
deny  ${HOME}/.local/share/autostart
deny  ${HOME}/.xinitrc
deny  ${HOME}/.xprofile
deny  ${HOME}/.xserverrc
deny  ${HOME}/.xsession
deny  ${HOME}/.xsessionrc
deny  /etc/X11/Xsession.d
deny  /etc/xdg/autostart
read-only ${HOME}/.Xauthority

# Session manager
# see #3358
#?HAS_X11: blacklist ${HOME}/.ICEauthority
#?HAS_X11: blacklist /tmp/.ICE-unix

# KDE config
deny  ${HOME}/.cache/konsole
deny  ${HOME}/.config/khotkeysrc
deny  ${HOME}/.config/krunnerrc
deny  ${HOME}/.config/kscreenlockerrc
deny  ${HOME}/.config/ksslcertificatemanager
deny  ${HOME}/.config/kwalletrc
deny  ${HOME}/.config/kwinrc
deny  ${HOME}/.config/kwinrulesrc
deny  ${HOME}/.config/plasma-locale-settings.sh
deny  ${HOME}/.config/plasma-org.kde.plasma.desktop-appletsrc
deny  ${HOME}/.config/plasmashellrc
deny  ${HOME}/.config/plasmavaultrc
deny  ${HOME}/.kde/share/apps/kwin
deny  ${HOME}/.kde/share/apps/plasma
deny  ${HOME}/.kde/share/apps/solid
deny  ${HOME}/.kde/share/config/khotkeysrc
deny  ${HOME}/.kde/share/config/krunnerrc
deny  ${HOME}/.kde/share/config/kscreensaverrc
deny  ${HOME}/.kde/share/config/ksslcertificatemanager
deny  ${HOME}/.kde/share/config/kwalletrc
deny  ${HOME}/.kde/share/config/kwinrc
deny  ${HOME}/.kde/share/config/kwinrulesrc
deny  ${HOME}/.kde/share/config/plasma-desktop-appletsrc
deny  ${HOME}/.kde4/share/apps/kwin
deny  ${HOME}/.kde4/share/apps/plasma
deny  ${HOME}/.kde4/share/apps/solid
deny  ${HOME}/.kde4/share/config/khotkeysrc
deny  ${HOME}/.kde4/share/config/krunnerrc
deny  ${HOME}/.kde4/share/config/kscreensaverrc
deny  ${HOME}/.kde4/share/config/ksslcertificatemanager
deny  ${HOME}/.kde4/share/config/kwalletrc
deny  ${HOME}/.kde4/share/config/kwinrc
deny  ${HOME}/.kde4/share/config/kwinrulesrc
deny  ${HOME}/.kde4/share/config/plasma-desktop-appletsrc
deny  ${HOME}/.local/share/kglobalaccel
deny  ${HOME}/.local/share/kwin
deny  ${HOME}/.local/share/plasma
deny  ${HOME}/.local/share/plasmashell
deny  ${HOME}/.local/share/solid
deny  /tmp/konsole-*.history
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
deny  ${RUNUSER}/*.slave-socket
deny  ${RUNUSER}/kdeinit5__*
deny  ${RUNUSER}/kdesud_*
# see #3358
#?HAS_NODBUS: blacklist ${RUNUSER}/ksocket-*
#?HAS_NODBUS: blacklist /tmp/ksocket-*

# gnome
# contains extensions, last used times of applications, and notifications
deny  ${HOME}/.local/share/gnome-shell
# contains recently used files and serials of static/removable storage
deny  ${HOME}/.local/share/gvfs-metadata
# no direct modification of dconf database
read-only ${HOME}/.config/dconf
deny  ${RUNUSER}/gnome-session-leader-fifo
deny  ${RUNUSER}/gnome-shell
deny  ${RUNUSER}/gsconnect

# systemd
deny  ${HOME}/.config/systemd
deny  ${HOME}/.local/share/systemd
deny  ${PATH}/systemctl
deny  ${PATH}/systemd-run
deny  ${RUNUSER}/systemd
deny  /etc/systemd/network
deny  /etc/systemd/system
deny  /var/lib/systemd
# creates problems on Arch where /etc/resolv.conf is a symlink to /var/run/systemd/resolve/resolv.conf
#blacklist /var/run/systemd

# openrc
deny  /etc/init.d/
deny  /etc/rc.conf
deny  /etc/runlevels/

# VirtualBox
deny  ${HOME}/.config/VirtualBox
deny  ${HOME}/.VirtualBox
deny  ${HOME}/VirtualBox VMs

# GNOME Boxes
deny  ${HOME}/.config/gnome-boxes
deny  ${HOME}/.local/share/gnome-boxes

# libvirt
deny  ${HOME}/.cache/libvirt
deny  ${HOME}/.config/libvirt
deny  ${RUNUSER}/libvirt
deny  /var/cache/libvirt
deny  /var/lib/libvirt
deny  /var/log/libvirt

# OCI-Containers / Podman
deny  ${RUNUSER}/containers
deny  ${RUNUSER}/crun
deny  ${RUNUSER}/libpod
deny  ${RUNUSER}/runc
deny  ${RUNUSER}/toolbox

# VeraCrypt
deny  ${HOME}/.VeraCrypt
deny  ${PATH}/veracrypt
deny  ${PATH}/veracrypt-uninstall.sh
deny  /usr/share/applications/veracrypt.*
deny  /usr/share/pixmaps/veracrypt.*
deny  /usr/share/veracrypt

# TrueCrypt
deny  ${HOME}/.TrueCrypt
deny  ${PATH}/truecrypt
deny  ${PATH}/truecrypt-uninstall.sh
deny  /usr/share/applications/truecrypt.*
deny  /usr/share/pixmaps/truecrypt.*
deny  /usr/share/truecrypt

# zuluCrypt
deny  ${HOME}/.zuluCrypt
deny  ${HOME}/.zuluCrypt-socket
deny  ${PATH}/zuluCrypt-cli
deny  ${PATH}/zuluMount-cli

# var
deny  /var/cache/apt
deny  /var/cache/pacman
deny  /var/lib/apt
deny  /var/lib/clamav
deny  /var/lib/dkms
deny  /var/lib/mysql/mysql.sock
deny  /var/lib/mysqld/mysql.sock
deny  /var/lib/pacman
deny  /var/lib/upower
# blacklist /var/log - a virtual /var/log directory (mostly empty) is build up by default for
# every sandbox, unless --writable-var-log switch is activated
deny  /var/mail
deny  /var/opt
deny  /var/run/acpid.socket
deny  /var/run/docker.sock
deny  /var/run/minissdpd.sock
deny  /var/run/mysql/mysqld.sock
deny  /var/run/mysqld/mysqld.sock
deny  /var/run/rpcbind.sock
deny  /var/run/screens
deny  /var/spool/anacron
deny  /var/spool/cron
deny  /var/spool/mail

# etc
deny  /etc/adduser.conf
deny  /etc/anacrontab
deny  /etc/apparmor*
deny  /etc/cron*
deny  /etc/dkms
deny  /etc/grub*
deny  /etc/kernel*
deny  /etc/logrotate*
deny  /etc/modules*
deny  /etc/profile.d
deny  /etc/rc.local
# rc1.d, rc2.d, ...
deny  /etc/rc?.d
deny  /etc/selinux

# hide config for various intrusion detection systems
deny  /etc/aide
deny  /etc/aide.conf
deny  /etc/chkrootkit.conf
deny  /etc/fail2ban.conf
deny  /etc/logcheck
deny  /etc/lynis
deny  /etc/rkhunter.*
deny  /etc/snort
deny  /etc/suricata
deny /etc/sysconfig/rkhunter
deny  /etc/tripwire
deny  /var/lib/rkhunter

# Startup files
read-only ${HOME}/.antigen
read-only ${HOME}/.bash_aliases
read-only ${HOME}/.bash_login
read-only ${HOME}/.bash_logout
read-only ${HOME}/.bash_profile
read-only ${HOME}/.bashrc
read-only ${HOME}/.config/environment.d
read-only ${HOME}/.config/fish
read-only ${HOME}/.csh_files
read-only ${HOME}/.cshrc
read-only ${HOME}/.forward
read-only ${HOME}/.kshrc
read-only ${HOME}/.local/share/fish
read-only ${HOME}/.login
read-only ${HOME}/.logout
read-only ${HOME}/.mkshrc
read-only ${HOME}/.oh-my-zsh
read-only ${HOME}/.pam_environment
read-only ${HOME}/.pgpkey
read-only ${HOME}/.plan
read-only ${HOME}/.profile
read-only ${HOME}/.project
read-only ${HOME}/.tcshrc
read-only ${HOME}/.zfunc
read-only ${HOME}/.zlogin
read-only ${HOME}/.zlogout
read-only ${HOME}/.zprofile
read-only ${HOME}/.zsh.d
read-only ${HOME}/.zsh_files
read-only ${HOME}/.zshenv
read-only ${HOME}/.zshrc
read-only ${HOME}/.zshrc.local

# Remote access
deny  ${HOME}/.rhosts
deny  ${HOME}/.shosts
deny  ${HOME}/.ssh/authorized_keys
deny  ${HOME}/.ssh/authorized_keys2
deny  ${HOME}/.ssh/environment
deny  ${HOME}/.ssh/rc
deny  /etc/hosts.equiv
read-only ${HOME}/.ssh/config
read-only ${HOME}/.ssh/config.d

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
read-only ${HOME}/.local/lib
read-only ${HOME}/.local/share/cool-retro-term
read-only ${HOME}/.mailcap
read-only ${HOME}/.msmtprc
read-only ${HOME}/.mutt/muttrc
read-only ${HOME}/.muttrc
read-only ${HOME}/.nano
read-only ${HOME}/.npmrc
read-only ${HOME}/.pythonrc.py
read-only ${HOME}/.reportbugrc
read-only ${HOME}/.tmux.conf
read-only ${HOME}/.vim
read-only ${HOME}/.viminfo
read-only ${HOME}/.vimrc
read-only ${HOME}/.xmonad
read-only ${HOME}/.xscreensaver
read-only ${HOME}/.yarnrc
read-only ${HOME}/_exrc
read-only ${HOME}/_gvimrc
read-only ${HOME}/_vimrc
read-only ${HOME}/dotfiles

# Make directories commonly found in $PATH read-only
read-only ${HOME}/.bin
read-only ${HOME}/.cargo/bin
read-only ${HOME}/.gem
read-only ${HOME}/.local/bin
read-only ${HOME}/.luarocks
read-only ${HOME}/.npm-packages
read-only ${HOME}/.nvm
read-only ${HOME}/.rustup
read-only ${HOME}/bin

# Write-protection for desktop entries
read-only ${HOME}/.config/menus
read-only ${HOME}/.gnome/apps
read-only ${HOME}/.local/share/applications

read-only ${HOME}/.config/mimeapps.list
read-only ${HOME}/.config/user-dirs.dirs
read-only ${HOME}/.config/user-dirs.locale
read-only ${HOME}/.local/share/mime

# Write-protection for thumbnailer dir
read-only ${HOME}/.local/share/thumbnailers

# prevent access to ssh-agent
deny  /tmp/ssh-*

# top secret
deny  /.fscrypt
deny  ${HOME}/*.kdb
deny  ${HOME}/*.kdbx
deny  ${HOME}/*.key
deny  ${HOME}/.caff
deny  ${HOME}/.cargo/credentials
deny  ${HOME}/.cargo/credentials.toml
deny  ${HOME}/.cert
deny  ${HOME}/.config/hub
deny  ${HOME}/.config/keybase
deny  ${HOME}/.davfs2/secrets
deny  ${HOME}/.ecryptfs
deny  ${HOME}/.fetchmailrc
deny  ${HOME}/.fscrypt
deny  ${HOME}/.git-credential-cache
deny  ${HOME}/.git-credentials
deny  ${HOME}/.gnome2/keyrings
deny  ${HOME}/.gnupg
deny  ${HOME}/.kde/share/apps/kwallet
deny  ${HOME}/.kde4/share/apps/kwallet
deny  ${HOME}/.local/share/keyrings
deny  ${HOME}/.local/share/kwalletd
deny  ${HOME}/.local/share/pki
deny  ${HOME}/.local/share/plasma-vault
deny  ${HOME}/.msmtprc
deny  ${HOME}/.mutt
deny  ${HOME}/.muttrc
deny  ${HOME}/.netrc
deny  ${HOME}/.nyx
deny  ${HOME}/.pki
deny  ${HOME}/.Private
deny  ${HOME}/.smbcredentials
deny  ${HOME}/.ssh
deny  ${HOME}/.vaults
deny  /etc/davfs2/secrets
deny  /etc/group+
deny  /etc/group-
deny  /etc/gshadow
deny  /etc/gshadow+
deny  /etc/gshadow-
deny  /etc/passwd+
deny  /etc/passwd-
deny  /etc/shadow
deny  /etc/shadow+
deny  /etc/shadow-
deny  /etc/ssh
deny  /etc/ssh/*
deny  /home/.ecryptfs
deny  /home/.fscrypt
deny  /var/backup

# cloud provider configuration
deny  ${HOME}/.aws
deny  ${HOME}/.boto
deny  ${HOME}/.config/gcloud
deny  ${HOME}/.kube
deny  ${HOME}/.passwd-s3fs
deny  ${HOME}/.s3cmd
deny  /etc/boto.cfg

# system directories
deny  /sbin
deny  /usr/local/sbin
deny  /usr/sbin

# system management
deny  ${PATH}/at
deny  ${PATH}/busybox
deny  ${PATH}/chage
deny  ${PATH}/chfn
deny  ${PATH}/chsh
deny  ${PATH}/crontab
deny  ${PATH}/evtest
deny  ${PATH}/expiry
deny  ${PATH}/fusermount
deny  ${PATH}/gksu
deny  ${PATH}/gksudo
deny  ${PATH}/gpasswd
deny  ${PATH}/kdesudo
deny  ${PATH}/ksu
deny  ${PATH}/mount
deny  ${PATH}/mount.ecryptfs_private
deny  ${PATH}/nc
deny  ${PATH}/ncat
deny  ${PATH}/nmap
deny  ${PATH}/newgidmap
deny  ${PATH}/newgrp
deny  ${PATH}/newuidmap
deny  ${PATH}/ntfs-3g
deny  ${PATH}/pkexec
deny  ${PATH}/procmail
deny  ${PATH}/sg
deny  ${PATH}/strace
deny  ${PATH}/su
deny  ${PATH}/sudo
deny  ${PATH}/tcpdump
deny  ${PATH}/umount
deny  ${PATH}/unix_chkpwd
deny  ${PATH}/xev
deny  ${PATH}/xinput

# other SUID binaries
deny  /usr/lib/virtualbox
deny  /usr/lib64/virtualbox

# prevent lxterminal connecting to an existing lxterminal session
deny  /tmp/.lxterminal-socket*
# prevent tmux connecting to an existing session
deny  /tmp/tmux-*

# disable terminals running as server resulting in sandbox escape
deny  ${PATH}/gnome-terminal
deny  ${PATH}/gnome-terminal.wrapper
deny  ${PATH}/lilyterm
deny  ${PATH}/lxterminal
deny  ${PATH}/mate-terminal
deny  ${PATH}/mate-terminal.wrapper
deny  ${PATH}/pantheon-terminal
deny  ${PATH}/roxterm
deny  ${PATH}/roxterm-config
deny  ${PATH}/terminix
deny  ${PATH}/tilix
deny  ${PATH}/urxvtc
deny  ${PATH}/urxvtcd
deny  ${PATH}/xfce4-terminal
deny  ${PATH}/xfce4-terminal.wrapper
# blacklist ${PATH}/konsole
# konsole doesn't seem to have this problem - last tested on Ubuntu 16.04

# kernel files
deny  /initrd*
deny  /vmlinuz*

# snapshot files
deny  /.snapshots

# flatpak
deny  ${HOME}/.cache/flatpak
deny  ${HOME}/.config/flatpak
nodeny  ${HOME}/.local/share/flatpak/exports
read-only ${HOME}/.local/share/flatpak/exports
deny  ${HOME}/.local/share/flatpak/*
deny  ${HOME}/.var
# most of the time bwrap is SUID binary
deny  ${PATH}/bwrap
deny  ${RUNUSER}/.dbus-proxy
deny  ${RUNUSER}/.flatpak
deny  ${RUNUSER}/.flatpak-cache
deny  ${RUNUSER}/.flatpak-helper
deny  ${RUNUSER}/app
deny  ${RUNUSER}/doc
deny  /usr/share/flatpak
nodeny  /var/lib/flatpak/exports
deny  /var/lib/flatpak/*

# snap
deny  ${RUNUSER}/snapd-session-agent.socket

# mail directories used by mutt
deny  ${HOME}/.Mail
deny  ${HOME}/.mail
deny  ${HOME}/.signature
deny  ${HOME}/Mail
deny  ${HOME}/mail
deny  ${HOME}/postponed
deny  ${HOME}/sent

# kernel configuration
deny  /proc/config.gz

# prevent DNS malware attempting to communicate with the server
# using regular DNS tools
deny  ${PATH}/dig
deny  ${PATH}/dlint
deny  ${PATH}/dns2tcp
deny  ${PATH}/dnssec-*
deny  ${PATH}/dnswalk
deny  ${PATH}/drill
deny  ${PATH}/host
deny  ${PATH}/iodine
deny  ${PATH}/kdig
deny  ${PATH}/khost
deny  ${PATH}/knsupdate
deny  ${PATH}/ldns-*
deny  ${PATH}/ldnsd
deny  ${PATH}/nslookup
deny  ${PATH}/resolvectl
deny  ${PATH}/unbound-host

# rest of ${RUNUSER}
deny  ${RUNUSER}/*.lock
deny  ${RUNUSER}/inaccessible
deny  ${RUNUSER}/pk-debconf-socket
deny  ${RUNUSER}/update-notifier.pid
