# Firejail profile for sftp
# Description: Secure file transport protocol
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include sftp.local
# Persistent global definitions
# added by included profile
#include globals.local

# Redirect
include ssh.profile
