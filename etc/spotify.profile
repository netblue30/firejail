# Spotify profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

# Whitelist the folders needed by Spotify - This is more restrictive 
# than a blacklist though, but this is all spotify requires for 
# streaming audio
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
include /etc/firejail/whitelist-common.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
noroot

