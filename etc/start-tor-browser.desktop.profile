# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update


noblacklist ${HOME}/.tor-browser-ar:
mkdir ${HOME}/.tor-browser-ar:
whitelist ${HOME}/.tor-browser-ar:

noblacklist ${HOME}/.tor-browser-en:
mkdir ${HOME}/.tor-browser-en:
whitelist ${HOME}/.tor-browser-en:

noblacklist ${HOME}/.tor-browser-en-us:
mkdir ${HOME}/.tor-browser-en-us:
whitelist ${HOME}/.tor-browser-en-us:

noblacklist ${HOME}/.tor-browser-es:
mkdir ${HOME}/.tor-browser-es:
whitelist ${HOME}/.tor-browser-es:

noblacklist ${HOME}/.tor-browser-es-es:
mkdir ${HOME}/.tor-browser-es-es:
whitelist ${HOME}/.tor-browser-es-es:

noblacklist ${HOME}/.tor-browser-fa:
mkdir ${HOME}/.tor-browser-fa:
whitelist ${HOME}/.tor-browser-fa:

noblacklist ${HOME}/.tor-browser-fr:
mkdir ${HOME}/.tor-browser-fr:
whitelist ${HOME}/.tor-browser-fr:

noblacklist ${HOME}/.tor-browser-it:
mkdir ${HOME}/.tor-browser-it:
whitelist ${HOME}/.tor-browser-it:

noblacklist ${HOME}/.tor-browser-ja:
mkdir ${HOME}/.tor-browser-ja:
whitelist ${HOME}/.tor-browser-ja:

noblacklist ${HOME}/.tor-browser-ko:
mkdir ${HOME}/.tor-browser-ko:
whitelist ${HOME}/.tor-browser-ko:

noblacklist ${HOME}/.tor-browser-pl:
mkdir ${HOME}/.tor-browser-pl:
whitelist ${HOME}/.tor-browser-pl:

noblacklist ${HOME}/.tor-browser-pt-br:
mkdir ${HOME}/.tor-browser-pt-br:
whitelist ${HOME}/.tor-browser-pt-br:

noblacklist ${HOME}/.tor-browser-ru:
mkdir ${HOME}/.tor-browser-ru:
whitelist ${HOME}/.tor-browser-ru:

noblacklist ${HOME}/.tor-browser-vi:
mkdir ${HOME}/.tor-browser-vi:
whitelist ${HOME}/.tor-browser-vi:

noblacklist ${HOME}/.tor-browser-zh-cn:
mkdir ${HOME}/.tor-browser-zh-cn:
whitelist ${HOME}/.tor-browser-zh-cn:

# Redirect
include /etc/firejail/torbrowser-launcher.profile
