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

ipc-namespace
nonewprivs
noroot
protocol unix,inet,inet6
#net none

private-bin bash,basename,cat,cut,electron28,gawk,grep,obsidian,realpath,tr
private-etc @network,@tls-ca,@x11,gnutls,libva.conf

read-only ${HOME}/.config/kdedefaults
read-only ${HOME}/.config/vulkan

include electron-common.profile
