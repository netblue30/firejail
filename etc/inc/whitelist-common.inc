# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-common.local

# common whitelist for all profiles

whitelist ${HOME}/.XCompose
whitelist ${HOME}/.alsaequal.bin
whitelist ${HOME}/.asoundrc
whitelist ${HOME}/.config/ibus
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.config/pkcs11
read-only ${HOME}/.config/pkcs11
whitelist ${HOME}/.config/user-dirs.dirs
read-only ${HOME}/.config/user-dirs.dirs
whitelist ${HOME}/.config/user-dirs.locale
read-only ${HOME}/.config/user-dirs.locale
whitelist ${HOME}/.drirc
whitelist ${HOME}/.icons
?HAS_APPIMAGE: whitelist ${HOME}/.local/share/appimagekit
whitelist ${HOME}/.local/share/applications
read-only ${HOME}/.local/share/applications
whitelist ${HOME}/.local/share/icons
whitelist ${HOME}/.local/share/mime
whitelist ${HOME}/.mime.types
whitelist ${HOME}/.sndio/cookie
whitelist ${HOME}/.uim.d

# dconf
mkdir ${HOME}/.config/dconf
whitelist ${HOME}/.config/dconf

# fonts
whitelist ${HOME}/.cache/fontconfig
whitelist ${HOME}/.config/fontconfig
whitelist ${HOME}/.fontconfig
whitelist ${HOME}/.fonts
whitelist ${HOME}/.fonts.conf
whitelist ${HOME}/.fonts.conf.d
whitelist ${HOME}/.fonts.d
whitelist ${HOME}/.local/share/fonts
whitelist ${HOME}/.pangorc

# gtk
whitelist ${HOME}/.config/gtk-2.0
whitelist ${HOME}/.config/gtk-3.0
whitelist ${HOME}/.config/gtk-4.0
whitelist ${HOME}/.config/gtkrc
whitelist ${HOME}/.config/gtkrc-2.0
whitelist ${HOME}/.gnome2
whitelist ${HOME}/.gnome2-private
whitelist ${HOME}/.gtk-2.0
whitelist ${HOME}/.gtkrc
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.kde/share/config/gtkrc
whitelist ${HOME}/.kde/share/config/gtkrc-2.0
whitelist ${HOME}/.kde4/share/config/gtkrc
whitelist ${HOME}/.kde4/share/config/gtkrc-2.0
whitelist ${HOME}/.local/share/themes
whitelist ${HOME}/.themes

# qt/kde
whitelist ${HOME}/.cache/kioexec/krun
whitelist ${HOME}/.config/Kvantum
whitelist ${HOME}/.config/Trolltech.conf
whitelist ${HOME}/.config/QtProject.conf
whitelist ${HOME}/.config/kdeglobals
whitelist ${HOME}/.config/kio_httprc
whitelist ${HOME}/.config/kioslaverc
whitelist ${HOME}/.config/ksslcablacklist
whitelist ${HOME}/.config/qt5ct
whitelist ${HOME}/.config/qt6ct
whitelist ${HOME}/.config/qtcurve
whitelist ${HOME}/.kde/share/config/kdeglobals
whitelist ${HOME}/.kde/share/config/kio_httprc
whitelist ${HOME}/.kde/share/config/kioslaverc
whitelist ${HOME}/.kde/share/config/ksslcablacklist
whitelist ${HOME}/.kde/share/config/oxygenrc
whitelist ${HOME}/.kde/share/icons
whitelist ${HOME}/.kde4/share/config/kdeglobals
whitelist ${HOME}/.kde4/share/config/kio_httprc
whitelist ${HOME}/.kde4/share/config/kioslaverc
whitelist ${HOME}/.kde4/share/config/ksslcablacklist
whitelist ${HOME}/.kde4/share/config/oxygenrc
whitelist ${HOME}/.kde4/share/icons
whitelist ${HOME}/.local/share/qt5ct
whitelist ${HOME}/.local/share/qt6ct
