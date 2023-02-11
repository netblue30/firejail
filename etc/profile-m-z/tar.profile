# Firejail profile for tar
# Description: GNU version of the tar archiving utility
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tar.local
# Persistent global definitions
include globals.local

# If you use nvm, add the below lines to your tar.local
#noblacklist ${HOME}/.nvm

# Included in archiver-common.profile
ignore include disable-shell.inc

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop
# all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

#private-lib libfakeroot,liblzma.so.*,libreadline.so.*
# Debian based distributions need this for 'dpkg --unpack' (incl. synaptic)
writable-var

# Redirect
include archiver-common.profile
