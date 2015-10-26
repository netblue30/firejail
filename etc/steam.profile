# Steam profile (applies to games/apps launched from Steam as well)
noblacklist ${HOME}/.steam
noblacklist ${HOME}/.local/share/steam
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-history.inc
caps.drop all
netfilter
noroot

# seccomp breaks Steam runtime due to 32/64bit syscall incompatibilties


## Author note:
##   If you wish to use a private directory for Steam, e.g.:
##       private /path/to/steam-home
##   ... be aware that games will not launch from this directory without
##   execute-permission trickery. In this case, you should store the games
##   in a separate (whitelisted/noblacklisted) directory.
