# Firejail profile for caja
# Description: File manager for the MATE desktop
# This file is overwritten after every install/update
# Persistent local customizations
include caja.local
# Persistent global definitions
include globals.local

# Caja is started by systemd on most systems. Therefore it is not firejailed by default. Since there
# is already a caja process running on MATE desktops firejail will have no effect.

# Put 'ignore noroot' in your caja.local if you use MPV+Vulkan (see issue #3012)

# Redirect
include file-manager-common.profile
