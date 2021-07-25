# Firejail profile alias for teamspeak3
# Description: TeamSpeak is software for quality voice communication via the Internet
# This file is overwritten after every install/update
# Persistent local customizations
include ts3client_runscript.sh.local
# Persistent global definitions
# added by included profile
#include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/TeamSpeak3-Client-linux_x86
noblacklist ${HOME}/TeamSpeak3-Client-linux_amd64

whitelist ${HOME}/TeamSpeak3-Client-linux_x86
whitelist ${HOME}/TeamSpeak3-Client-linux_amd64

# Redirect
include teamspeak3.profile
