# Firejail profile for Node.js
# Description: Asynchronous event-driven JavaScript runtime
# This file is overwritten after every install/update
# Persistent local customizations
include nodejs-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

# Note: gulp, node-gyp, npm, npx, pnpm, pnpx, semver and yarn are all node scripts
# using the `#!/usr/bin/env node` shebang. By sandboxing node the full
# node.js stack will be firejailed. The only exception is nvm, which is implemented
# as a sourced shell function, not an executable binary. Hence it is not
# directly firejailable. You can work around this by sandboxing the programs
# used by nvm: curl, sha256sum, tar and wget. We have comments in these
# profiles on how to enable nvm support via local overrides.

blacklist ${RUNUSER}

ignore read-only ${HOME}/.npm-packages
ignore read-only ${HOME}/.npmrc
ignore read-only ${HOME}/.nvm
ignore read-only ${HOME}/.yarnrc

noblacklist ${HOME}/.local/share/pnpm
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
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

# If you want whitelisting, change ${HOME}/Projects below to your node projects directory
# and add the next lines to your nodejs-common.local.
#mkdir ${HOME}/.local/share/pnpm
#mkdir ${HOME}/.node-gyp
#mkdir ${HOME}/.npm
#mkdir ${HOME}/.npm-packages
#mkfile ${HOME}/.npmrc
#mkdir ${HOME}/.nvm
#mkdir ${HOME}/.yarn
#mkdir ${HOME}/.yarn-config
#mkdir ${HOME}/.yarncache
#mkfile ${HOME}/.yarnrc
#whitelist ${HOME}/.local/share/pnpm
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
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
seccomp.block-secondary

disable-mnt
private-dev
private-etc @tls-ca,@x11,host.conf,mime.types,rpc,services
#private-tmp

dbus-user none
dbus-system none

# Add the next line to your nodejs-common.local if you prefer to disable gatsby telemetry.
#env GATSBY_TELEMETRY_DISABLED=1
restrict-namespaces
