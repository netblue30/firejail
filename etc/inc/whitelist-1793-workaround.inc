# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-1793-workaround.local
# This works around bug 1793, and allows whitelisting to be used for some KDE applications.

noblacklist ${HOME}/.config/ibus
noblacklist ${HOME}/.config/mimeapps.list
noblacklist ${HOME}/.config/pkcs11
noblacklist ${HOME}/.config/user-dirs.dirs
noblacklist ${HOME}/.config/user-dirs.locale
noblacklist ${HOME}/.config/dconf
noblacklist ${HOME}/.config/fontconfig
noblacklist ${HOME}/.config/gtk-2.0
noblacklist ${HOME}/.config/gtk-3.0
noblacklist ${HOME}/.config/gtk-4.0
noblacklist ${HOME}/.config/gtkrc
noblacklist ${HOME}/.config/gtkrc-2.0
noblacklist ${HOME}/.config/Kvantum
noblacklist ${HOME}/.config/Trolltech.conf
noblacklist ${HOME}/.config/QtProject.conf
noblacklist ${HOME}/.config/kdeglobals
noblacklist ${HOME}/.config/kio_httprc
noblacklist ${HOME}/.config/kioslaverc
noblacklist ${HOME}/.config/ksslcablacklist
noblacklist ${HOME}/.config/qt5ct
noblacklist ${HOME}/.config/qtcurve

blacklist ${HOME}/.config/*
whitelist ${HOME}/.config
