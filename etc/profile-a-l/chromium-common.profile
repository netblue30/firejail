# Firejail profile for chromium-common
# This file is overwritten after every install/update
# Persistent local customizations
include chromium-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# noexec ${HOME} breaks DRM binaries.
?BROWSER_ALLOW_DRM: ignore noexec ${HOME}

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

# Add the next line to your chromium-common.local if you want Google Chrome/Chromium browser
# to have access to Gnome extensions (extensions.gnome.org) via browser connector
#include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Add the next line to your chromium-common.local if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.inc.profile

apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
noinput
notv
?BROWSER_DISABLE_U2F: nou2f
shell none

disable-mnt
private-cache
?BROWSER_DISABLE_U2F: private-dev
#private-tmp - issues when using multiple browser sessions

#dbus-user none - prevents access to passwords saved in GNOME Keyring and KWallet, also breaks Gnome connector.
dbus-system none

# The file dialog needs to work without d-bus.
?HAS_NODBUS: env NO_CHROME_KDE_FILE_DIALOG=1
