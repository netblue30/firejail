# Firejail profile for rocketchat
# This file is overwritten after every install/update
# Persistent local customizations
include rocketchat.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-devel.inc
ignore include disable-exec.inc
ignore include disable-interpreters.inc
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

noblacklist ${HOME}/.config/Rocket.Chat

mkdir ${HOME}/.config/Rocket.Chat
whitelist ${HOME}/.config/Rocket.Chat

# Redirect
include electron-common.profile
