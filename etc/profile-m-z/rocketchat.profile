# Firejail profile for rocketchat
# This file is overwritten after every install/update
# Persistent local customizations
include rocketchat.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ingore include disable-devel.inc
ignore include disable-exec.inc
ignore include disable-interpreters.inc
ignore include disable-xdg.inc
ingore nou2f
ingore novideo
ignore shell none

noblacklist ${HOME}/.config/Rocket.Chat

mkdir ${HOME}/.config/Rocket.Chat
whitelist ${HOME}/.config/Rocket.Chat

# Redirect
include electron.profile
