# Firejail profile for obsidian-wayland
# Description: Personal knowledge base and note-taking with Markdown files.
# This file is overwritten after every install/update
# Persistent local customizations
include obsidian-wayland.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/AMD
noblacklist ${HOME}/.cache/nvidia
noblacklist ${HOME}/.cache/mesa_shader_cache
noblacklist ${HOME}/.local/share/applnk
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.local/share/vulkan
noblacklist ${HOME}/.config/vulkan
noblacklist ${HOME}/.config/kdedefaults
noblacklist ${HOME}/.config/obsidian

whitelist ${HOME}/.cache/AMD
whitelist ${HOME}/.cache/nvidia
whitelist ${HOME}/.cache/mesa_shader_cache
whitelist ${HOME}/.local/share/applnk
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.config/vulkan
whitelist ${HOME}/.config/kdedefaults
whitelist ${HOME}/.config/obsidian

ipc-namespace
nonewprivs
noroot

protocol unix,inet,inet6,netlink,

# If you need net disable "net none" and uncomment the rest in this block
net none
#
#noblacklist ${HOME}/.pki/nssdb
#whitelist ${HOME}/.pki/nssdb
#
#private-etc ca-certificates,nsswitch.conf,hosts,gnutls,

private-bin cat,gawk,tr,realpath,cut,grep,basename,bash,obsidian,electron28,
private-etc libva.conf,vulkan,ati,xdg,gtk-3.0,drirc,fonts,

?HAS_APPIMAGE: private-lib

read-only ${HOME}/.config/vulkan
read-only ${HOME}/.config/kdedefaults

include electron-common.profile
