# Local customizations come here
include /etc/firejail/whitelist-common.local

# common whitelist for all profiles

whitelist ${HOME}/.XCompose
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.icons
whitelist ${HOME}/.local/share/icons
whitelist ${HOME}/.config/user-dirs.dirs
read-only ${HOME}/.config/user-dirs.dirs
whitelist ${HOME}/.asoundrc
whitelist ${HOME}/.config/Trolltech.conf
whitelist ${HOME}/.local/share/mime
whitelist ${HOME}/.drirc
whitelist ${HOME}/.mime.types
whitelist ${HOME}/.local/share/applications
read-only ${HOME}/.local/share/applications
whitelist ${HOME}/.config/pkcs11
read-only ${HOME}/.config/pkcs11
whitelist ${HOME}/.config/ibus

# fonts
whitelist ${HOME}/.fonts
whitelist ${HOME}/.fonts.d
whitelist ${HOME}/.fontconfig
whitelist ${HOME}/.fonts.conf
whitelist ${HOME}/.fonts.conf.d
whitelist ${HOME}/.local/share/fonts
whitelist ${HOME}/.config/fontconfig
whitelist ${HOME}/.cache/fontconfig
whitelist ${HOME}/.pangorc

# gtk
whitelist ${HOME}/.gtkrc
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.gtk-2.0
whitelist ${HOME}/.config/gtk-2.0
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.config/gtkrc
whitelist ${HOME}/.config/gtkrc-2.0
whitelist ${HOME}/.themes
whitelist ${HOME}/.local/share/themes
whitelist ${HOME}/.kde/share/config/gtkrc
whitelist ${HOME}/.kde/share/config/gtkrc-2.0
whitelist ${HOME}/.kde4/share/config/gtkrc
whitelist ${HOME}/.kde4/share/config/gtkrc-2.0
whitelist ${HOME}/.gnome2
whitelist ${HOME}/.gnome2-private

# dconf
mkdir ${HOME}/.config/dconf
whitelist ${HOME}/.config/dconf

# qt/kde
whitelist ${HOME}/.config/kdeglobals
whitelist ${HOME}/.config/kioslaverc
whitelist ${HOME}/.kde/share/config/oxygenrc
whitelist ${HOME}/.kde/share/config/kdeglobals
whitelist ${HOME}/.kde/share/config/kioslaverc
whitelist ${HOME}/.kde/share/icons
whitelist ${HOME}/.kde4/share/config/oxygenrc
whitelist ${HOME}/.kde4/share/config/kdeglobals
whitelist ${HOME}/.kde4/share/config/kioslaverc
whitelist ${HOME}/.kde4/share/icons
