# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/keepass2.local

# keepass password manager profile
#noblacklist ${HOME}/.config/KeePass
#noblacklist ${HOME}/.keepass
 
include /etc/firejail/keepass.profile
