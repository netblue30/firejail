# Firejail profile for tb-starter-wrapper
# Description: wrapper-script used by whonix to start the tor browser
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include tb-starter-wrapper.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tb

mkdir ${HOME}/.tb
allow  ${HOME}/.tb

private-bin tb-starter-wrapper

# Redirect
include torbrowser-launcher.profile
