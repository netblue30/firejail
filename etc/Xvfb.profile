caps.drop all
# Xvfb needs to be allowed access to the abstract Unix socket namespace.
#net none
nogroups
nonewprivs
# In noroot mode, Xvfb cannot create a socket in the real /tmp/.X11-unix.
#noroot
nosound
shell none
protocol unix

private
#private-bin Xvfb,sh,xkbcomp,strace,bash,cat,ls
private-bin Xvfb,sh,xkbcomp
private-dev
private-tmp
private-etc ld.so.conf,ld.so.cache,resolv.conf,host.conf,nsswitch.conf,gai.conf,hosts,hostname

blacklist /media
whitelist /var/lib/xkb
whitelist /tmp/.X11-unix
mask-x11 no
