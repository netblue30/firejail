# HTTP / FTP / Mail
blacklist ${HOME}/.adobe
blacklist ${HOME}/.macromedia
blacklist ${HOME}/.mozilla
blacklist ${HOME}/.icedove
blacklist ${HOME}/.thunderbird
blacklist ${HOME}/.config/midori
blacklist ${HOME}/.config/opera
blacklist ${HOME}/.config/chromium
blacklist ${HOME}/.config/google-chrome
blacklist ${HOME}/.filezilla
blacklist ${HOME}/.config/filezilla
blacklist ${HOME}/.local/share/systemd

# Instant Messaging
blacklist ${HOME}/.purple
blacklist ${HOME}/.config/psi+

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

# etc
blacklist /etc/cron.*
blacklist /etc/profile.d
blacklist /etc/rc.local
blacklist /etc/anacrontab

