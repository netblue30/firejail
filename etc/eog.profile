# Firejail profile for eog
# Description: Eye of GNOME graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eog.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/eog

whitelist /usr/share/eog
include whitelist-usr-share-common.inc

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'
# comment those if you need that functionality
# or put 'ignore private-bin', 'ignore private-etc' and 'ignore private-lib' in your eog.local
private-bin eog

# Redirect
include eo-common.profile
