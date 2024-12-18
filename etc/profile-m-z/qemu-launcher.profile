# Firejail profile for qemu-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include qemu-launcher.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.qemu-launcher

# Redirect
include qemu-common.profile
