# Firejail profile for Visual Studio Code
# This file is overwritten after every install/update
# Persistent local customizations
include code.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore include disable-devel.inc
ignore include disable-exec.inc
ignore include disable-interpreters.inc
ignore include disable-xdg.inc
ignore whitelist ${DOWNLOADS}
ignore whitelist ${HOME}/.config/Electron
ignore whitelist ${HOME}/.config/electron*-flag*.conf
ignore include whitelist-common.inc
ignore include whitelist-runuser-common.inc
ignore include whitelist-usr-share-common.inc
ignore include whitelist-var-common.inc
ignore apparmor
ignore disable-mnt
ignore dbus-user none
ignore dbus-system none

noblacklist ${HOME}/.config/Code
noblacklist ${HOME}/.config/Code - OSS
noblacklist ${HOME}/.vscode
noblacklist ${HOME}/.vscode-oss

# Allows files commonly used by IDEs
include allow-common-devel.inc

nosound

# Disabling noexec ${HOME} for now since it will
# probably interfere with running some programmes
# in VS Code
#noexec ${HOME}
noexec /tmp

# Redirect
include electron-common.profile
