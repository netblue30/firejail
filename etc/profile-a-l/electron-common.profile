# Firejail profile for electron-common
# Description: Build cross platform desktop apps with web technologies
# This file is overwritten after every install/update
# Persistent local customizations
include electron-common.local

noblacklist ${HOME}/.config/Electron
noblacklist ${HOME}/.config/electron*-flag*.conf

whitelist ${HOME}/.config/Electron
whitelist ${HOME}/.config/electron*-flag*.conf

# If your kernel allows the creation of user namespaces by unprivileged users
# (for example, if running `unshare -U echo enabled` prints "enabled"), you
# can add the next line to your electron-common.local.
#include electron-common-hardened.inc.profile

nou2f
novideo

private-dev
private-tmp

dbus-user none

# Redirect
include blink-common.profile
