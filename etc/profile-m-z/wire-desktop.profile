# Firejail profile for wire-desktop
# Description: End-to-end encrypted messenger with file sharing, voice calls and video conferences
# This file is overwritten after every install/update
# Persistent local customizations
include wire-desktop.local
# Persistent global definitions
include globals.local

# Debian/Ubuntu use /opt/Wire. As that is not in PATH by default, run `firejail /opt/Wire/wire-desktop` to start it.

# Disabled until someone reported positive feedback
ignore include disable-exec.inc
ignore include disable-xdg.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore novideo
ignore private-cache

ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Wire

mkdir ${HOME}/.config/Wire
whitelist ${HOME}/.config/Wire

private-bin bash,electron,electron[0-9],electron[0-9][0-9],env,sh,wire-desktop
private-etc @tls-ca

# Redirect
include electron.profile
