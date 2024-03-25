# Firejail profile for tqemu
# Description: QEMU frontend without libvirt
# This file is overwritten after every install/update
# Persistent local customizations
include tqemu.local
# Persistent global definitions
include globals.local

# breaks app
ignore restrict-namespaces

# For host-only network sys_admin is needed.
# See https://github.com/netblue30/firejail/issues/2868#issuecomment-518647630
ignore caps.drop all
caps.keep net_raw,sys_nice
#caps.keep net_raw,sys_admin

# Redirect
include qemu-common.profile
