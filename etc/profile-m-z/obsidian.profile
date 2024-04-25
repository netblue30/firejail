# Firejail profile for obsidian-wayland
# Description: Personal knowledge base and note-taking with Markdown files.
# This file is overwritten after every install/update
# Persistent local customizations
include obsidian-wayland.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.config/obsidian
noblacklist ${HOME}/.gitconfig

whitelist ${HOME}/.cache/AMD
whitelist ${HOME}/.cache/mesa_shader_cache
whitelist ${HOME}/.cache/nvidia
whitelist ${HOME}/.local/share/applnk
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.local/share/vulkan
whitelist ${HOME}/.config/kdedefaults
whitelist ${HOME}/.config/obsidian
whitelist ${HOME}/.config/vulkan

ipc-namespace
nonewprivs
noroot
protocol unix,inet,inet6
#net none

private-bin bash,basename,cat,cut,electron28,gawk,grep,obsidian,realpath,tr
private-etc @network,@tls-ca,gnutls,nsswitch.conf,
private-etc @x11,fonts,libva.conf

read-only ${HOME}/.config/kdedefaults
read-only ${HOME}/.config/vulkan

include electron-common.profile
