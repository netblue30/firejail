#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2026 Firejail Authors
# License GPL v2

set -eu

readonly LYXAUTH_PATH='${RUNUSER}/lyxauth'
readonly WHITELIST_PROFILE='../../etc/inc/whitelist-runuser-common.inc'
readonly DISABLE_X11_PROFILE='../../etc/inc/disable-x11.inc'

grep -Fx "whitelist ${LYXAUTH_PATH}" "$WHITELIST_PROFILE"
grep -Fx "blacklist ${LYXAUTH_PATH}" "$DISABLE_X11_PROFILE"
