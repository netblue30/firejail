# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update

# Persistent global definitions
include tor-browser_zh-CN.local

noblacklist ${HOME}/.tor-browser_zh-CN

mkdir ${HOME}/.tor-browser_zh-CN
whitelist ${HOME}/.tor-browser_zh-CN

# Redirect
include torbrowser-launcher.profile
