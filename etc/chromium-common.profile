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

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
#include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.keep sys_admin,sys_chroot
netfilter
# nodbus - prevents access to passwords saved in GNOME Keyring and KWallet, also breaks Gnome connector
nodvd
nogroups
notv
?BROWSER_DISABLE_U2F: nou2f
shell none

disable-mnt
?BROWSER_DISABLE_U2F: private-dev
# private-tmp - problems with multiple browser sessions

# the file dialog needs to work without d-bus
?HAS_NODBUS: env NO_CHROME_KDE_FILE_DIALOG=1
