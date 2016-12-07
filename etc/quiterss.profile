noblacklist ${HOME}/.cache/QuiteRss
noblacklist ${HOME}/.config/QuiteRss
noblacklist ${HOME}/.config/QuiteRssrc
noblacklist ${HOME}/.local/share/QuiteRss

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

whitelist ${HOME}/quiterssfeeds.opml
mkdir ~/.config/QuiteRss
whitelist ${HOME}/.config/QuiteRss/
whitelist ${HOME}/.config/QuiteRssrc
mkdir ~/.local/share/data
mkdir ~/.local/share/data/QuiteRss
whitelist ${HOME}/.local/share/data/QuiteRss
mkdir ~/.cache/QuiteRss
whitelist ${HOME}/.cache/QuiteRss

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin quiterss
private-dev
#private-etc X11,ssl

include /etc/firejail/whitelist-common.inc
