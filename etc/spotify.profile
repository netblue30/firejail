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

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

# common
whitelist ~/.fonts
whitelist ~/.fonts.d
whitelist ~/.fontconfig
whitelist ~/.fonts.conf
whitelist ~/.fonts.conf.d
