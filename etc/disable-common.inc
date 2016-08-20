# History files in $HOME
blacklist-nolog ${HOME}/.history
blacklist-nolog ${HOME}/.*_history

# HTTP / FTP / Mail
blacklist-nolog ${HOME}/.adobe
blacklist-nolog ${HOME}/.macromedia
blacklist ${HOME}/.mozilla
blacklist ${HOME}/.icedove
blacklist ${HOME}/.thunderbird
blacklist ${HOME}/.sylpheed-2.0
blacklist ${HOME}/.config/midori
blacklist ${HOME}/.config/opera
blacklist ${HOME}/.config/opera-beta
blacklist ${HOME}/.config/chromium
blacklist ${HOME}/.config/google-chrome
blacklist ${HOME}/.config/google-chrome-beta
blacklist ${HOME}/.config/google-chrome-unstable
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
blacklist ${HOME}/.Skype

# Cryptocoins
blacklist ${HOME}/.*coin
blacklist ${HOME}/.electrum*
blacklist ${HOME}/wallet.dat

# VNC
blacklist ${HOME}/.remmina

# Other
blacklist ${HOME}/.tconn
blacklist ${HOME}/.FBReader
blacklist ${HOME}/.wine

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
blacklist ${HOME}/.config/VirtualBox

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

# General startup files
read-only ${HOME}/.xinitrc
read-only ${HOME}/.xserverrc
read-only ${HOME}/.profile

# Shell startup files
read-only ${HOME}/.bash_login
read-only ${HOME}/.bashrc
read-only ${HOME}/.bash_profile
read-only ${HOME}/.bash_logout
read-only ${HOME}/.zshrc
read-only ${HOME}/.zlogin
read-only ${HOME}/.zprofile
read-only ${HOME}/.zlogout
read-only ${HOME}/.zsh_files
read-only ${HOME}/.tcshrc
read-only ${HOME}/.cshrc
read-only ${HOME}/.csh_files

# Initialization files that allow arbitrary command execution
read-only ${HOME}/.mailcap
read-only ${HOME}/.exrc
read-only ${HOME}/_exrc
read-only ${HOME}/.vimrc
read-only ${HOME}/_vimrc
read-only ${HOME}/.gvimrc
read-only ${HOME}/_gvimrc
read-only ${HOME}/.vim
read-only ${HOME}/.emacs
read-only ${HOME}/.tmux.conf
read-only ${HOME}/.iscreenrc
read-only ${HOME}/.muttrc
read-only ${HOME}/.mutt/muttrc
read-only ${HOME}/.xmonad
read-only ${HOME}/.xscreensaver

# The user ~/bin directory can override commands such as ls
read-only ${HOME}/bin

# disable terminals running as server resulting in sandbox escape
blacklist ${PATH}/lxterminal
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
blacklist ${PATH}/urxvtc
blacklist ${PATH}/urxvtcd
