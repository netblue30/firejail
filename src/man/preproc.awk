#!/usr/bin/gawk -E

# Copyright (c) 2019-2024 rusty-snake
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

BEGIN {
	macros[0] = 0
	for (arg in ARGV) {
		if (ARGV[arg] ~ /^-D[A-Z0-9_]+$/) {
			macros[length(macros) + 1] = substr(ARGV[arg], 3)
		}
		ARGV[arg] = ""
	}

	include = 1
}
/^#ifdef [A-Z0-9_]+$/ {
	macro = substr($0, 8)
	for (i in macros) {
		if (macros[i] == macro) {
			include = 1
			next
		}
	}
	include = 0
}
/^#if 0$/ {
	include = 0
	next
}
/^#endif$/ {
	include = 1
	next
}
{
	if (include)
		print
}
