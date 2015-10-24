# HTTP / FTP / Mail
blacklist ${HOME}/.adobe
blacklist ${HOME}/.macromedia
blacklist ${HOME}/.mozilla
blacklist ${HOME}/.icedove
blacklist ${HOME}/.thunderbird
blacklist ${HOME}/.sylpheed-2.0
blacklist ${HOME}/.config/midori
blacklist ${HOME}/.config/opera
blacklist ${HOME}/.config/chromium
blacklist ${HOME}/.config/google-chrome
blacklist ${HOME}/.filezilla
blacklist ${HOME}/.config/filezilla
blacklist ${HOME}/.local/share/systemd

# Instant Messaging
blacklist ${HOME}/.config/hexchat
blacklist ${HOME}/.mcabber
blacklist ${HOME}/.purple
blacklist ${HOME}/.config/psi+
blacklist ${HOME}/.retroshare
blacklist ${HOME}/.weechat
blacklist ${HOME}/.config/xchat

# Cryptocoins
blacklist ${HOME}/.*coin
blacklist ${HOME}/.electrum*
blacklist ${HOME}/wallet.dat

# VNC
blacklist ${HOME}/.remmina

# Other
blacklist ${HOME}/.tconn
blacklist ${HOME}/.FBReader

# X11 session autostart
blacklist ${HOME}/.xinitrc
blacklist ${HOME}/.xprofile
blacklist ${HOME}/.config/autostart
blacklist /etc/xdg/autostart
blacklist ${HOME}/.kde4/Autostart
blacklist ${HOME}/.kde4/share/autostart
blacklist ${HOME}/.kde/Autostart
blacklist ${HOME}/.config/plasma-workspace/shutdown
blacklist ${HOME}/.config/plasma-workspace/env
blacklist ${HOME}/.config/lxsession/LXDE/autostart
blacklist ${HOME}/.fluxbox/startup
blacklist ${HOME}/.config/openbox/autostart
blacklist ${HOME}/.config/openbox/environment

# VirtualBox
blacklist ${HOME}/.VirtualBox
blacklist ${HOME}/VirtualBox VMs

# git, subversion
blacklist ${HOME}/.subversion
blacklist ${HOME}/.gitconfig
blacklist ${HOME}/.git-credential-cache

# var
blacklist /var/spool/cron
blacklist /var/spool/anacron
blacklist /var/run/acpid.socket
blacklist /var/run/minissdpd.sock
blacklist /var/run/rpcbind.sock
blacklist /var/run/mysqld/mysqld.sock
blacklist /var/run/mysql/mysqld.sock
blacklist /var/lib/mysqld/mysql.sock
blacklist /var/lib/mysql/mysql.sock
blacklist /var/run/docker.sock

# etc
blacklist /etc/cron.*
blacklist /etc/profile.d
blacklist /etc/rc.local
blacklist /etc/anacrontab

