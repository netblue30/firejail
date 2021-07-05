# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-common.local

# common whitelist for all profiles

allow  ${HOME}/.XCompose
allow  ${HOME}/.alsaequal.bin
allow  ${HOME}/.asoundrc
allow  ${HOME}/.config/ibus
allow  ${HOME}/.config/mimeapps.list
allow  ${HOME}/.config/pkcs11
read-only ${HOME}/.config/pkcs11
allow  ${HOME}/.config/user-dirs.dirs
read-only ${HOME}/.config/user-dirs.dirs
allow  ${HOME}/.config/user-dirs.locale
read-only ${HOME}/.config/user-dirs.locale
allow  ${HOME}/.drirc
allow  ${HOME}/.icons
?HAS_APPIMAGE: whitelist ${HOME}/.local/share/appimagekit
allow  ${HOME}/.local/share/applications
read-only ${HOME}/.local/share/applications
allow  ${HOME}/.local/share/icons
allow  ${HOME}/.local/share/mime
allow  ${HOME}/.mime.types
allow  ${HOME}/.sndio/cookie
allow  ${HOME}/.uim.d

# dconf
mkdir ${HOME}/.config/dconf
allow  ${HOME}/.config/dconf

# fonts
allow  ${HOME}/.cache/fontconfig
allow  ${HOME}/.config/fontconfig
allow  ${HOME}/.fontconfig
allow  ${HOME}/.fonts
allow  ${HOME}/.fonts.conf
allow  ${HOME}/.fonts.conf.d
allow  ${HOME}/.fonts.d
allow  ${HOME}/.local/share/fonts
allow  ${HOME}/.pangorc

# gtk
allow  ${HOME}/.config/gtk-2.0
allow  ${HOME}/.config/gtk-3.0
allow  ${HOME}/.config/gtk-4.0
allow  ${HOME}/.config/gtkrc
allow  ${HOME}/.config/gtkrc-2.0
allow  ${HOME}/.gnome2
allow  ${HOME}/.gnome2-private
allow  ${HOME}/.gtk-2.0
allow  ${HOME}/.gtkrc
allow  ${HOME}/.gtkrc-2.0
allow  ${HOME}/.kde/share/config/gtkrc
allow  ${HOME}/.kde/share/config/gtkrc-2.0
allow  ${HOME}/.kde4/share/config/gtkrc
allow  ${HOME}/.kde4/share/config/gtkrc-2.0
allow  ${HOME}/.local/share/themes
allow  ${HOME}/.themes

# qt/kde
allow  ${HOME}/.cache/kioexec/krun
allow  ${HOME}/.config/Kvantum
allow  ${HOME}/.config/Trolltech.conf
allow  ${HOME}/.config/QtProject.conf
allow  ${HOME}/.config/kdeglobals
allow  ${HOME}/.config/kio_httprc
allow  ${HOME}/.config/kioslaverc
allow  ${HOME}/.config/ksslcablacklist
allow  ${HOME}/.config/qt5ct
allow  ${HOME}/.config/qtcurve
allow  ${HOME}/.kde/share/config/kdeglobals
allow  ${HOME}/.kde/share/config/kio_httprc
allow  ${HOME}/.kde/share/config/kioslaverc
allow  ${HOME}/.kde/share/config/ksslcablacklist
allow  ${HOME}/.kde/share/config/oxygenrc
allow  ${HOME}/.kde/share/icons
allow  ${HOME}/.kde4/share/config/kdeglobals
allow  ${HOME}/.kde4/share/config/kio_httprc
allow  ${HOME}/.kde4/share/config/kioslaverc
allow  ${HOME}/.kde4/share/config/ksslcablacklist
allow  ${HOME}/.kde4/share/config/oxygenrc
allow  ${HOME}/.kde4/share/icons
allow  ${HOME}/.local/share/qt5ct
