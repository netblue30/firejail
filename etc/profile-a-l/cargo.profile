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

mkdir ${HOME}/.cargo
whitelist ${HOME}/.cargo
whitelist ${HOME}/.rustup

#private-bin cargo,rustc
private-etc alternatives,ca-certificates,crypto-policies,group,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,magic,magic.mgc,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl

memory-deny-write-execute

# Redirect
include build-systems-common.profile
