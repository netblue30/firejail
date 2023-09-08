# Firejail profile for pycharm-community
# This file is overwritten after every install/update
# Persistent local customizations
include pycharm-community.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.PyCharm*
# Persistent cache is needed for spell and grammar checkers, etc.
noblacklist ${HOME}/.cache/JetBrains/PyCharm*
noblacklist ${HOME}/.config/JetBrains/PyCharm*
# Not `PyCharm*`, because the state about of "anonymous data sent" is shared
# between JetBrains IDEs.
noblacklist ${HOME}/.local/share/JetBrains

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-devel.inc
include disable-programs.inc

caps.drop all
machine-id
nodvd
nogroups
noinput
nosound
notv
nou2f
novideo
tracelog

# minimum required to run but will probably break the program!
#private-etc alternatives,fonts,passwd
private-dev
private-tmp

noexec /tmp
