# Local customizations come here
include /etc/firejail/whitelist-common.local

# common whitelist for all profiles

whitelist ~/.XCompose
whitelist ~/.config/mimeapps.list
whitelist ~/.icons
whitelist ~/.local/share/icons
whitelist ~/.config/user-dirs.dirs
read-only ~/.config/user-dirs.dirs
whitelist ~/.asoundrc
whitelist ~/.config/Trolltech.conf
whitelist ~/.local/share/mime
whitelist ~/.drirc
whitelist ~/.mime.types
whitelist ~/.local/share/applications
read-only ~/.local/share/applications
whitelist ~/.config/ibus

# fonts
whitelist ~/.fonts
whitelist ~/.fonts.d
whitelist ~/.fontconfig
whitelist ~/.fonts.conf
whitelist ~/.fonts.conf.d
whitelist ~/.local/share/fonts
whitelist ~/.config/fontconfig
whitelist ~/.cache/fontconfig
whitelist ~/.pangorc

# gtk
whitelist ~/.gtkrc
whitelist ~/.gtkrc-2.0
whitelist ~/.gtk-2.0
whitelist ~/.config/gtk-2.0
whitelist ~/.config/gtk-3.0
whitelist ~/.config/gtkrc
whitelist ~/.config/gtkrc-2.0
whitelist ~/.themes
whitelist ~/.local/share/themes
whitelist ~/.kde/share/config/gtkrc
whitelist ~/.kde/share/config/gtkrc-2.0
whitelist ~/.kde4/share/config/gtkrc
whitelist ~/.kde4/share/config/gtkrc-2.0
whitelist ~/.gnome2
whitelist ~/.gnome2-private

# dconf
mkdir ~/.config/dconf
whitelist ~/.config/dconf

# qt/kde
whitelist ~/.config/kdeglobals
whitelist ~/.kde/share/config/oxygenrc
whitelist ~/.kde/share/config/kdeglobals
whitelist ~/.kde/share/icons
whitelist ~/.kde4/share/config/oxygenrc
whitelist ~/.kde4/share/config/kdeglobals
whitelist ~/.kde4/share/icons
