# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-1793-workaround.local
# This works around bug 1793, and allows whitelisting to be used for some KDE applications.

nodeny  ${HOME}/.config/ibus
nodeny  ${HOME}/.config/mimeapps.list
nodeny  ${HOME}/.config/pkcs11
nodeny  ${HOME}/.config/user-dirs.dirs
nodeny  ${HOME}/.config/user-dirs.locale
nodeny  ${HOME}/.config/dconf
nodeny  ${HOME}/.config/fontconfig
nodeny  ${HOME}/.config/gtk-2.0
nodeny  ${HOME}/.config/gtk-3.0
nodeny  ${HOME}/.config/gtk-4.0
nodeny  ${HOME}/.config/gtkrc
nodeny  ${HOME}/.config/gtkrc-2.0
nodeny  ${HOME}/.config/Kvantum
nodeny  ${HOME}/.config/Trolltech.conf
nodeny  ${HOME}/.config/QtProject.conf
nodeny  ${HOME}/.config/kdeglobals
nodeny  ${HOME}/.config/kio_httprc
nodeny  ${HOME}/.config/kioslaverc
nodeny  ${HOME}/.config/ksslcablacklist
nodeny  ${HOME}/.config/qt5ct
nodeny  ${HOME}/.config/qtcurve

deny  ${HOME}/.config/*
allow  ${HOME}/.config
