# Firejail profile for elixir
# Description: Elixir-lang
quiet
# This file is overwritten after every install/update
# Persistent local customizations
include elixir.local
# Persistent global definitions
include globals.local

# Note: mix and most other tools are shell scripts
# using the `#!/usr/bin/env elixir` shebang.
# yet, mix will download some binaries even if they are available,
# unless you opt out via the env vars bellow.
# NOTE: EXCEPT `iex` is also a shell script but it will
#       invoke elixir from deep paths, so it IS NOT covered!!!

# opt-out of downloading binaries, if your dist provides them
#env MIX_REBAR3=/usr/bin/rebar3

include elixir-common.inc
