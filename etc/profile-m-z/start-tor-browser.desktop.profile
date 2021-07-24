# Firejail profile alias for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include start-tor-browser.desktop.local
# Persistent global definitions
# added by included profile
#include globals.local

nodeny  ${HOME}/.tor-browser*

allow  ${HOME}/.tor-browser-ar
allow  ${HOME}/.tor-browser-ca
allow  ${HOME}/.tor-browser-cs
allow  ${HOME}/.tor-browser-da
allow  ${HOME}/.tor-browser-de
allow  ${HOME}/.tor-browser-el
allow  ${HOME}/.tor-browser-en
allow  ${HOME}/.tor-browser-en-us
allow  ${HOME}/.tor-browser-es
allow  ${HOME}/.tor-browser-es-es
allow  ${HOME}/.tor-browser-fa
allow  ${HOME}/.tor-browser-fr
allow  ${HOME}/.tor-browser-ga-ie
allow  ${HOME}/.tor-browser-he
allow  ${HOME}/.tor-browser-hu
allow  ${HOME}/.tor-browser-id
allow  ${HOME}/.tor-browser-is
allow  ${HOME}/.tor-browser-it
allow  ${HOME}/.tor-browser-ja
allow  ${HOME}/.tor-browser-ka
allow  ${HOME}/.tor-browser-ko
allow  ${HOME}/.tor-browser-nb
allow  ${HOME}/.tor-browser-nl
allow  ${HOME}/.tor-browser-pl
allow  ${HOME}/.tor-browser-pt-br
allow  ${HOME}/.tor-browser-ru
allow  ${HOME}/.tor-browser-sv-se
allow  ${HOME}/.tor-browser-tr
allow  ${HOME}/.tor-browser-vi
allow  ${HOME}/.tor-browser-zh-cn
allow  ${HOME}/.tor-browser-zh-tw

allow  ${HOME}/.tor-browser_ar
allow  ${HOME}/.tor-browser_ca
allow  ${HOME}/.tor-browser_cs
allow  ${HOME}/.tor-browser_da
allow  ${HOME}/.tor-browser_de
allow  ${HOME}/.tor-browser_el
allow  ${HOME}/.tor-browser_en
allow  ${HOME}/.tor-browser_en_US
allow  ${HOME}/.tor-browser_es
allow  ${HOME}/.tor-browser_es-ES
allow  ${HOME}/.tor-browser_fa
allow  ${HOME}/.tor-browser_fr
allow  ${HOME}/.tor-browser_ga-IE
allow  ${HOME}/.tor-browser_he
allow  ${HOME}/.tor-browser_hu
allow  ${HOME}/.tor-browser_id
allow  ${HOME}/.tor-browser_is
allow  ${HOME}/.tor-browser_it
allow  ${HOME}/.tor-browser_ja
allow  ${HOME}/.tor-browser_ka
allow  ${HOME}/.tor-browser_ko
allow  ${HOME}/.tor-browser_nb
allow  ${HOME}/.tor-browser_nl
allow  ${HOME}/.tor-browser_pl
allow  ${HOME}/.tor-browser_pt-BR
allow  ${HOME}/.tor-browser_ru
allow  ${HOME}/.tor-browser_sv-SE
allow  ${HOME}/.tor-browser_tr
allow  ${HOME}/.tor-browser_vi
allow  ${HOME}/.tor-browser_zh-CN
allow  ${HOME}/.tor-browser_zh-TW

# Redirect
include torbrowser-launcher.profile
