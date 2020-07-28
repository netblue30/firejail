# Firejail profile for dolphin
# Description: File manager
# This file is overwritten after every install/update
# Persistent local customizations
include dolphin.local
# Persistent global definitions
include globals.local

# Put 'ignore noroot' in your dolphin.local if you use MPV+Vulkan (see issue #3012)

# Redirect
include file-manager-common.profile

join-or-start dolphin
