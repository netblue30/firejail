# Firejail profile for riot-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/riot-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

# Redirect
include /etc/firejail/riot-web.profile
