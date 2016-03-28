# Firejail profile for Mozilla Thunderbird (Icedove in Debian)
# Users have thunderbird set to open a browser by clicking a link in an email
# We are not allowed to blacklist browser-specific directories

noblacklist ${HOME}/.gnupg
noblacklist ~/.icedove
noblacklist ~/.thunderbird
noblacklist ~/.mozilla
noblacklist ~/.cache/mozilla
noblacklist ~/keepassx.kdbx
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
tracelog
noroot

