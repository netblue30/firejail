# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-passwdmgr.local

deny  ${HOME}/.config/Bitwarden
deny  ${HOME}/.config/KeePass
deny  ${HOME}/.config/keepass
deny  ${HOME}/.config/keepassx
deny  ${HOME}/.config/keepassxc
deny  ${HOME}/.config/KeePassXCrc
deny  ${HOME}/.config/Sinew Software Systems
deny  ${HOME}/.fpm
deny  ${HOME}/.keepass
deny  ${HOME}/.keepassx
deny  ${HOME}/.keepassxc
deny  ${HOME}/.lastpass
deny  ${HOME}/.local/share/KeePass
deny  ${HOME}/.local/share/keepass
deny  ${HOME}/.password-store
