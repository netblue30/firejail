# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include start-tor-browser.desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

noblacklist ${HOME}/.tor-browser*

whitelist ${HOME}/.tor-browser-ar
whitelist ${HOME}/.tor-browser-ca
whitelist ${HOME}/.tor-browser-cs
whitelist ${HOME}/.tor-browser-da
whitelist ${HOME}/.tor-browser-de
whitelist ${HOME}/.tor-browser-el
whitelist ${HOME}/.tor-browser-en
whitelist ${HOME}/.tor-browser-en-us
whitelist ${HOME}/.tor-browser-es
whitelist ${HOME}/.tor-browser-es-es
whitelist ${HOME}/.tor-browser-fa
whitelist ${HOME}/.tor-browser-fr
whitelist ${HOME}/.tor-browser-ga-ie
whitelist ${HOME}/.tor-browser-he
whitelist ${HOME}/.tor-browser-hu
whitelist ${HOME}/.tor-browser-id
whitelist ${HOME}/.tor-browser-is
whitelist ${HOME}/.tor-browser-it
whitelist ${HOME}/.tor-browser-ja
whitelist ${HOME}/.tor-browser-ka
whitelist ${HOME}/.tor-browser-ko
whitelist ${HOME}/.tor-browser-nb
whitelist ${HOME}/.tor-browser-nl
whitelist ${HOME}/.tor-browser-pl
whitelist ${HOME}/.tor-browser-pt-br
whitelist ${HOME}/.tor-browser-ru
whitelist ${HOME}/.tor-browser-sv-se
whitelist ${HOME}/.tor-browser-tr
whitelist ${HOME}/.tor-browser-vi
whitelist ${HOME}/.tor-browser-zh-cn
whitelist ${HOME}/.tor-browser-zh-tw

whitelist ${HOME}/.tor-browser_ar
whitelist ${HOME}/.tor-browser_ca
whitelist ${HOME}/.tor-browser_cs
whitelist ${HOME}/.tor-browser_da
whitelist ${HOME}/.tor-browser_de
whitelist ${HOME}/.tor-browser_el
whitelist ${HOME}/.tor-browser_en
whitelist ${HOME}/.tor-browser_en_US
whitelist ${HOME}/.tor-browser_es
whitelist ${HOME}/.tor-browser_es-ES
whitelist ${HOME}/.tor-browser_fa
whitelist ${HOME}/.tor-browser_fr
whitelist ${HOME}/.tor-browser_ga-IE
whitelist ${HOME}/.tor-browser_he
whitelist ${HOME}/.tor-browser_hu
whitelist ${HOME}/.tor-browser_id
whitelist ${HOME}/.tor-browser_is
whitelist ${HOME}/.tor-browser_it
whitelist ${HOME}/.tor-browser_ja
whitelist ${HOME}/.tor-browser_ka
whitelist ${HOME}/.tor-browser_ko
whitelist ${HOME}/.tor-browser_nb
whitelist ${HOME}/.tor-browser_nl
whitelist ${HOME}/.tor-browser_pl
whitelist ${HOME}/.tor-browser_pt-BR
whitelist ${HOME}/.tor-browser_ru
whitelist ${HOME}/.tor-browser_sv-SE
whitelist ${HOME}/.tor-browser_tr
whitelist ${HOME}/.tor-browser_vi
whitelist ${HOME}/.tor-browser_zh-CN
whitelist ${HOME}/.tor-browser_zh-TW

# Ignoring apparmor, tor browser is installed in user home directory using the binary archive distributed by Tor Foundation
ignore apparmor

# Redirect
include torbrowser-launcher.profile
