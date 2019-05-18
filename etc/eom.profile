# Firejail profile for eom
# Description: Eye of MATE graphics viewer program
# This file is overwritten after every install/update
# Persistent local customizations
include eom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/mate/eom

# private-bin, private-etc and private-lib break 'Open With' / 'Open in file manager'
# comment those if you need that functionality
# or put 'ignore private-bin', 'ignore private-etc' and 'ignore private-lib' in your eom.local
private-bin eom

# Redirect
include eo-common.profile
