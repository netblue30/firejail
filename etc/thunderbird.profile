# Firejail profile for Mozilla Thunderbird (Icedove in Debian)
noblacklist ${HOME}/.gnupg
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-devel.inc

# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories
#include /etc/firejail/disable-common.inc thunderbird icedove
blacklist ${HOME}/.adobe
blacklist ${HOME}/.macromedia
blacklist ${HOME}/.filezilla
blacklist ${HOME}/.config/filezilla
blacklist ${HOME}/.purple
blacklist ${HOME}/.config/psi+
blacklist ${HOME}/.remmina
blacklist ${HOME}/.tconn


caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
tracelog
noroot

