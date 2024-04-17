# Firejail profile for obsidian
# Description: Obsidian is the private and flexible writing app that adapts to the way you think.
# This file is overwritten after every install/update
# Persistent local customizations
include obsidian.local
# Persistent global definitions
include globals.local

### Basic Blacklisting ###
include disable-common.inc              # dangerous directories like ~/.ssh and ~/.gnupg
include disable-devel.inc               # development tools such as gcc and gdb
include disable-exec.inc                # non-executable directories such as /var, /tmp, and /home
include disable-interpreters.inc        # perl, python, lua etc.
include disable-programs.inc            # user configuration for programs such as firefox, vlc etc.
include disable-xdg.inc                 # standard user directories: Documents, Pictures, Videos, Music

### Home Directory Whitelisting ###
whitelist ${HOME}/.gitconfig            # for the git plugin
whitelist ${HOME}/.config/git           # for the git plugin
whitelist ${HOME}/.pki/nssdb
whitelist ${HOME}/.cache/AMD
whitelist ${HOME}/.cache/nvidia
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.local/share/vulkan/implicit_layer.d
whitelist ${HOME}/.config/vulkan
whitelist ${HOME}/.local/share/vulkan/loader_settings.d
whitelist ${HOME}/.config/kdedefaults
whitelist ${HOME}/.Xdefaults-desktop-pc
whitelist ${HOME}/.config/kdedefaults/gtk-3.0
whitelist ${HOME}/.cache/mesa_shader_cache
whitelist ${HOME}/.local/share/applnk
whitelist ${HOME}/.config/obsidian

include whitelist-common.inc

### Filesystem Whitelisting ###
whitelist /run/systemd/machines/api.obsidian.md
whitelist /run/systemd/resolve/io.systemd.Resolve
whitelist /run/systemd/machines/raw.githubusercontent.com
whitelist /run/udev/control

include whitelist-run-common.inc
include whitelist-runuser-common.inc

whitelist /usr/share/applnk

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

#apparmor       # if you have AppArmor running, try this one!

caps.drop all
ipc-namespace

#no3d           # disable 3D acceleration
#nodvd          # disable DVD and CD devices
#nogroups       # disable supplementary user groups
#noinput        # disable input devices
#novideo        # disable video capture devices

nonewprivs
noroot
?HAS_APPIMAGE: notv            # disable DVB TV devices
?HAS_APPIMAGE: nou2f           # disable U2F devices

protocol unix,inet,inet6,netlink,

# If you need networking, enable the firewall and disable "net none"
#net none        # disable network
netfilter      # enable default firewall in sandbox

seccomp !chroot # allowing chroot, just in case this is an Electron app
shell none

#tracelog       # send blacklist violations to syslog

disable-mnt     # no access to /mnt, /media, /run/mount and /run/media

private-bin git,cat,gawk,tr,realpath,cut,grep,basename,bash,obsidian,electron28
private-dev
private-etc gitattributes,gitconfig,ca-certificates,libva.conf,vulkan,ati,nsswitch.conf,hosts,xdg,gtk-3.0,drirc,fonts,gnutls,

?HAS_APPIMAGE: private-lib
?HAS_APPIMAGE: private-tmp

#dbus-user none
#dbus-system none
dbus-user filter
