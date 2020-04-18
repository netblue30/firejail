# Firejail profile for nemo
# Description: File manager and graphical shell for Cinnamon
# This file is overwritten after every install/update
# Persistent local customizations
include nemo.local
# Persistent global definitions
include globals.local

# Put 'ignore noroot' in your nemo.local if you use MPV+Vulkan (see issue #3012)

# Redirect
include file-manager-common.profile

join-or-start nemo
