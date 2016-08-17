# Spotify media player profile
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.local/share/spotify
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

# Whitelist the folders needed by Spotify - This is more restrictive
# than a blacklist though, but this is all spotify requires for
# streaming audio
mkdir ${HOME}/.config/spotify
whitelist ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.local/share/spotify
mkdir ${HOME}/.cache/spotify
whitelist ${HOME}/.cache/spotify
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
shell none

#private-bin spotify
private-dev
