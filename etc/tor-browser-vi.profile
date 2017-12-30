# Firejail profile for tor-browser-vi from the Arch User Repository:


blacklist /usr/local/bin
blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /var

private-bin bash,grep,sed,tail,tor-browser-vi,env,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf,file,expr
whitelist ${HOME}/.tor-browser-vi
whitelist /dev/dri
whitelist /dev/full
whitelist /dev/null
whitelist /dev/ptmx
whitelist /dev/pts
whitelist /dev/random
whitelist /dev/shm
whitelist /dev/snd
whitelist /dev/tty
whitelist /dev/urandom
whitelist /dev/video0
whitelist /dev/zero
whitelist ~/Downloads

# FIXME: Spoof D-Bus machine id (tor-browser segfaults when it is missing!)
# https://github.com/netblue30/firejail/issues/955
private-etc X11,pulse,machine-id

private-tmp
noexec /tmp
shell none
seccomp
noroot
caps.drop all
