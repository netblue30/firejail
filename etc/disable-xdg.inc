# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-xdg.local

#blacklist ${DESKTOP}
blacklist ${DOCUMENTS}
#blacklist ${DOWNLOADS}
blacklist ${MUSIC}
blacklist ${PICTURES}
blacklist ${VIDEOS}
