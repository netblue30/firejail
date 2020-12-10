# Firejail profile for riot-web
# Description: A glossy Matrix collaboration client for the web
# This file is overwritten after every install/update
# Persistent local customizations
include riot-web.local
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

noblacklist ${HOME}/.config/Riot

mkdir ${HOME}/.config/Riot
whitelist ${HOME}/.config/Riot

# Redirect
include electron.profile
