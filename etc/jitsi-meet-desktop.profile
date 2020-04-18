# Firejail profile for jitsi-meet-desktop
# Description: Jitsi Meet desktop application powered by Electron
# This file is overwritten after every install/update
# Persistent local customizations
include jitsi-meet-desktop.local
# Persistent global definitions
include globals.local

ignore noexec /tmp

noblacklist ${HOME}/.config/Jitsi Meet

include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-xdg.inc

mkdir ${HOME}/.config/Jitsi Meet
whitelist ${HOME}/.config/Jitsi Meet
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

seccomp !chroot

disable-mnt
private-bin jitsi-meet-desktop,bash
private-cache
private-dev
private-tmp

# Redirect
include electron.profile
