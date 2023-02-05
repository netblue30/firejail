# Firejail profile for cargo
# Description: The Rust package manager
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cargo.local
# Persistent global definitions
include globals.local

ignore read-only ${HOME}/.cargo/bin

noblacklist ${HOME}/.cargo/credentials
noblacklist ${HOME}/.cargo/credentials.toml

#whitelist ${HOME}/.cargo
#whitelist ${HOME}/.rustup

#private-bin cargo,rustc
private-etc @tls-ca,host.conf,magic,magic.mgc,rpc,services

memory-deny-write-execute

# Redirect
include build-systems-common.profile
