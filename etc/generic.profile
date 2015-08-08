################################
# Generic profile based on Firefox profile
################################
#include /etc/firejail/disable-mgmt.inc
# system directories	
blacklist /sbin
blacklist /usr/sbin
# system management
blacklist ${PATH}/umount
blacklist ${PATH}/mount
blacklist ${PATH}/fusermount
blacklist ${PATH}/su
blacklist ${PATH}/sudo
blacklist ${PATH}/xinput
blacklist ${PATH}/strace

#include /etc/firejail/disable-secret.inc
# HOME directory
blacklist ${HOME}/.ssh
tmpfs ${HOME}/.gnome2_private
blacklist ${HOME}/.gnome2/keyrings
blacklist ${HOME}/kde4/share/apps/kwallet
blacklist ${HOME}/kde/share/apps/kwallet
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.gnupg
blacklist ${HOME}/.local/share/recently-used.xbel

blacklist ${HOME}/.adobe
blacklist ${HOME}/.macromedia
blacklist ${HOME}/.mozilla
blacklist ${HOME}/.icedove
blacklist ${HOME}/.thunderbird
blacklist ${HOME}/.config/opera
blacklist ${HOME}/.config/chromium
blacklist ${HOME}/.config/google-chrome

caps.drop all
seccomp
netfilter
noroot

