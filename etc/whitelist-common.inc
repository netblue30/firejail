# common whitelist for all profiles

whitelist ~/.XCompose
whitelist ~/.config/mimeapps.list
whitelist ~/.icons
whitelist ~/.config/user-dirs.dirs
read-only ~/.config/user-dirs.dirs
whitelist ~/.asoundrc
whitelist ~/.config/Trolltech.conf

# fonts
whitelist ~/.fonts
whitelist ~/.fonts.d
whitelist ~/.fontconfig
whitelist ~/.fonts.conf
whitelist ~/.fonts.conf.d
whitelist ~/.config/fontconfig
whitelist ~/.cache/fontconfig

# gtk
whitelist ~/.gtkrc
whitelist ~/.gtkrc-2.0
whitelist ~/.config/gtk-3.0
whitelist ~/.themes

# dconf
mkdir ~/.config
mkdir ~/.config/dconf
whitelist ~/.config/dconf
