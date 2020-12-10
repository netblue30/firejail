# Firejail profile for beaker
# This file is overwritten after every install/update
# Persistent local customizations
include beaker.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ignore include disable-exec.inc
ignore include disable-xdg.inc
ingore nou2f
ingore novideo
ignore shell none

noblacklist ${HOME}/.config/Beaker Browser

mkdir ${HOME}/.config/Beaker Browser
whitelist ${HOME}/.config/Beaker Browser

# Redirect
include electron.profile
