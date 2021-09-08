# Firejail profile for cargo
# Description: The Rust package manager
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include cargo.local
# Persistent global definitions
include globals.local

private-bin cmake

memory-deny-write-execute

# Redirect
include build-systems-common.profile
