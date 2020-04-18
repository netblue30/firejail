# Firejail profile for ranger
# Description: File manager with an ncurses frontend written in Python
# This file is overwritten after every install/update
# Persistent local customizations
include ranger.local
# Persistent global definitions
include globals.local

# Put 'ignore noroot' in your ranger.local if you use MPV+Vulkan (see issue #3012)

# Redirect
include file-manager-common.profile

join-or-start ranger
