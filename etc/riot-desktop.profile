# Firejail profile for riot-desktop
# Description: A glossy Matrix collaboration client for the desktop
# This file is overwritten after every install/update
# Persistent local customizations
include riot-desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

# Seccomp prevents riot from launching
ignore seccomp

# Redirect
include riot-web.profile
