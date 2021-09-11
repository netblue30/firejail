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

#whitelist ${HOME}/.bundle
#whitelist ${HOME}/.gem
#whitelist ${HOME}/.local/share/gem
whitelist /usr/share/gems
whitelist /usr/share/ruby
whitelist /usr/share/rubygems

# Redirect
include build-systems-common.profile
