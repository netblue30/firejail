#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2024 Firejail Authors
# License GPL v2

echo -e "#include <errno.h>\n#include <attr/xattr.h>" | \
    cpp -dD | \
    grep "^#define E" | \
    sed -e '{s/#define \(.*\) .*/\t"\1", \1,/g}'
