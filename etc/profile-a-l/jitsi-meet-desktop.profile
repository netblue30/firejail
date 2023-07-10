# Firejail profile for jitsi-meet-desktop
# Description: Jitsi Meet desktop application powered by Electron
# This file is overwritten after every install/update
# Persistent local customizations
include jitsi-meet-desktop.local
# Persistent global definitions
include globals.local

# Disabled until someone reported positive feedback
ignore nou2f
ignore novideo

ignore noexec /tmp

noblacklist ${HOME}/.config/Jitsi Meet

nowhitelist ${DOWNLOADS}

mkdir ${HOME}/.config/Jitsi Meet
whitelist ${HOME}/.config/Jitsi Meet

private-bin bash,electron,electron[0-9],electron[0-9][0-9],jitsi-meet-desktop,sh
private-etc @tls-ca,@x11,bumblebee,glvnd,host.conf,mime.types,rpc,services

# Redirect
include electron-common.profile
