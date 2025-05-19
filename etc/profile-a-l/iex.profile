# Firejail profile for iex
# Description: Elixir-lang interactive repl
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include iex.local
# Persistent global definitions
include globals.local

# iex is just a shell script that fork into elixir, but it will
# always use full path, bypassing firejail unless itself
# is already jailed.

include elixir-common.inc
