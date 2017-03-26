# This file is overwritten during software install. 
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-passwdmgr.local

blacklist ${HOME}/.lastpass
blacklist ${HOME}/.keepassx
blacklist ${HOME}/.keepass
blacklist ${HOME}/.password-store
blacklist ${HOME}/.config/keepassx
blacklist ${HOME}/.config/keepass
blacklist ${HOME}/.config/KeePass
