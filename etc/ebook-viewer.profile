# Firejail profile alias for calibre
# This file is overwritten after every install/update
# Persistent local customizations
include ebook-viewer.local

ignore no3d
ignore tracelog

net none
nodbus
protocol unix,netlink
seccomp !chroot

# Redirect
include calibre.profile
