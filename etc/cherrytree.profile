# cherrytree note taking application
noblacklist /usr/bin/python2*
noblacklist /usr/lib/python3*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ${HOME}/cherrytree
mkdir ~/.config/cherrytree
whitelist ${HOME}/.config/cherrytree/
mkdir ~/.local/share
whitelist ${HOME}/.local/share/

caps.drop all
netfilter
nonewprivs
noroot
nosound
seccomp
protocol unix,inet,inet6,netlink
tracelog

include /etc/firejail/whitelist-common.inc

# no private-bin support for various reasons:
#10:25:34 exec 11249 (root) NEW SANDBOX: /usr/bin/firejail /usr/bin/cherrytree 
#10:25:34 exec 11252 (netblue) /bin/bash -c "/usr/bin/cherrytree"  
#10:25:34 exec 11252 (netblue) /usr/bin/python /usr/bin/cherrytree 
#10:25:34 exec 11253 (netblue) sh -c /sbin/ldconfig -p 2>/dev/null 
#10:25:34 exec 11255 (netblue) sh -c if type gcc >/dev/null 2>&1; then CC=gcc; elif type cc >/dev/null 2>&1; then CC=cc;else exit 10; fi;LANG=C LC_ALL=C $CC -Wl,-t -o /tmp/tmpiYr44S 2>&1 -llibc 
# it requires acces to browser to show the online help
# it doesn't play nicely with expect
