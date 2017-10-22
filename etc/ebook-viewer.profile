# Firejail profile alias for calibre
# This file is overwritten after every install/update

blacklist /run/user/*/bus

net none

# Redirect
include /etc/firejail/calibre.profile
