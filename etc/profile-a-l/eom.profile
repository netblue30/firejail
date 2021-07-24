# Firejail profile for eom
# Description: Eye of MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eom.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/mate/eom

allow  /usr/share/eom

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'.
# Add the next lines to your eom.local if you need that functionality.
#ignore private-bin
#ignore private-etc
#ignore private-lib

private-bin eom

# Redirect
include eo-common.profile
