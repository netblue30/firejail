# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-nodejs.local
# This works around bug 1793, and allows whitelisting to be used for some KDE applications.

whitelist ${HOME}/.config/ibus
whitelist ${HOME}/.config/mimeapps.list
whitelist ${HOME}/.config/pkcs11
read-only ${HOME}/.config/pkcs11
whitelist ${HOME}/.config/user-dirs.dirs
read-only ${HOME}/.config/user-dirs.dirs
whitelist ${HOME}/.config/user-dirs.locale
read-only ${HOME}/.config/user-dirs.locale
whitelist ${HOME}/.config/fontconfig
whitelist ${HOME}/.config/Kvantum
whitelist ${HOME}/.config/Trolltech.conf
whitelist ${HOME}/.config/QtProject.conf
whitelist ${HOME}/.config/kdeglobals
whitelist ${HOME}/.config/kio_httprc
whitelist ${HOME}/.config/kioslaverc
whitelist ${HOME}/.config/ksslcablacklist
whitelist ${HOME}/.config/qt5ct
whitelist ${HOME}/.config/qtcurve

blacklist ${HOME}/.config/*
whitelist ${HOME}/.config
