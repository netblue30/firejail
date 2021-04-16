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
# include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

# Add the next line to your chromium-common.local if your kernel allows unprivileged userns clone.
#include chromium-common-hardened.inc.profile

# Add the next line to your chromium-common.local to allow screen sharing under wayland.
#whitelist ${RUNUSER}/pipewire-0

# AppArmor breaks brave's native Tor support, which is installed under ${HOME}.
# Add 'apparmor' to your chromium-common.local to enable AppArmor support.
# IMPORTANT: the relevant rule in /etc/apparmor.d/local/firejail-default will need
# to be uncommented too for this to work as expected.
#apparmor
caps.keep sys_admin,sys_chroot
netfilter
nodvd
nogroups
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
