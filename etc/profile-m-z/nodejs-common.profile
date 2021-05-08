# Firejail profile for Node.js
# Description: Asynchronous event-driven JavaScript runtime
# This file is overwritten after every install/update
# Persistent local customizations
include nodejs-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

ignore read-only ${HOME}/.npm-packages
ignore read-only ${HOME}/.npmrc
ignore read-only ${HOME}/.nvm
ignore read-only ${HOME}/.yarnrc

noblacklist ${HOME}/.node-gyp
noblacklist ${HOME}/.npm
noblacklist ${HOME}/.npmrc
noblacklist ${HOME}/.nvm
noblacklist ${HOME}/.yarn
noblacklist ${HOME}/.yarn-config
noblacklist ${HOME}/.yarncache
noblacklist ${HOME}/.yarnrc

ignore noexec ${HOME}

include allow-bin-sh.inc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# If you want whitelisting, change ${HOME}/Projects below to your node projects directory
# and add the next lines to your nodejs-common.local.
#mkdir ${HOME}/.node-gyp
#mkdir ${HOME}/.npm
#mkdir ${HOME}/.npm-packages
#mkfile ${HOME}/.npmrc
#mkdir ${HOME}/.nvm
#mkdir ${HOME}/.yarn
#mkdir ${HOME}/.yarn-config
#mkdir ${HOME}/.yarncache
#mkfile ${HOME}/.yarnrc
#whitelist ${HOME}/.node-gyp
#whitelist ${HOME}/.npm
#whitelist ${HOME}/.npm-packages
#whitelist ${HOME}/.npmrc
#whitelist ${HOME}/.nvm
#whitelist ${HOME}/.yarn
#whitelist ${HOME}/.yarn-config
#whitelist ${HOME}/.yarncache
#whitelist ${HOME}/.yarnrc
#whitelist ${HOME}/Projects
#include whitelist-common.inc

whitelist /usr/share/doc/node
whitelist /usr/share/nvm
whitelist /usr/share/systemtap/tapset/node.stp
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary
shell none

disable-mnt
private-dev
private-etc alternatives,ca-certificates,crypto-policies,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,login.defs,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
#private-tmp

dbus-user none
dbus-system none

# Add the next line to your nodejs-common.local if you prefer to disable gatsby telemetry.
#env GATSBY_TELEMETRY_DISABLED=1
