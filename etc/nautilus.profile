# Firejail profile for nautilus
# Description: File manager and graphical shell for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include nautilus.local
# Persistent global definitions
include globals.local

# Nautilus is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a nautilus process running on gnome desktops firejail will have no effect.

# Redirect
include file-manager-common.profile

join-or-start nautilus
