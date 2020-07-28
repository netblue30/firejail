# Firejail profile for riot-desktop
# Description: A glossy Matrix collaboration client for the desktop
# This file is overwritten after every install/update
# Persistent local customizations
include riot-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

seccomp !chroot

# Redirect
include riot-web.profile
