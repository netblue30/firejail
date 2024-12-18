# Firejail profile for beaker
# This file is overwritten after every install/update
# Persistent local customizations
include beaker.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-exec.inc
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore nou2f
ignore novideo
ignore disable-mnt
ignore private-cache
ignore private-dev
ignore private-tmp

noblacklist ${HOME}/.config/Beaker Browser

mkdir ${HOME}/.config/Beaker Browser
whitelist ${HOME}/.config/Beaker Browser

# Redirect
include electron-common.profile
