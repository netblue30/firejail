# Firejail profile for bundle
# Description: Ruby Dependency Management
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bundle.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.bundle

# Allow ruby (blacklisted by disable-interpreters.inc)
include allow-ruby.inc

mkdir ${HOME}/.bundle
whitelist ${HOME}/.bundle
whitelist /usr/share/gems
whitelist /usr/share/ruby
whitelist /usr/share/rubygems

private-bin bundle,bundler,ruby,ruby-mri

# Redirect
include build-systems-common.profile
