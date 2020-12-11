# Firejail profile for riot-web
# Description: A glossy Matrix collaboration client for the web
# This file is overwritten after every install/update
# Persistent local customizations
include riot-web.local
# Persistent global definitions
include globals.local

# See ABC.XYZ.ADD.A.NOTE
ignore include disable-devel.inc
ignore include disable-exec.inc
ignore include disable-interpreters.inc
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore nou2f
ignore novideo
ignore shell none
ignore disable-mnt
ignore private-cache
ignore private-dev
ignore private-tmp

noblacklist ${HOME}/.config/Riot

mkdir ${HOME}/.config/Riot
whitelist ${HOME}/.config/Riot

# Redirect
include electron.profile
