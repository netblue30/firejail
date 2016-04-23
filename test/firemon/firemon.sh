#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2016 Firejail Authors
# License GPL v2

echo "TESTING: firemon --seccomp (test/firemon/seccomp.exp)"
./seccomp.exp

echo "TESTING: firemon --caps (test/firemon/caps.exp)"
./caps.exp
