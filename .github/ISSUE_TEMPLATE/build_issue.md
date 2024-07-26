---
name: Build issue
about: There is an issue when trying to build the project from source
title: 'build: '
labels: ''
assignees: ''

---

<!--
See the following links for help with formatting:

https://guides.github.com/features/mastering-markdown/
https://docs.github.com/en/github/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax
-->

### Description

_Describe the bug_

### Steps to Reproduce

<!--
Note: If the output is too long to embed it into the comment, you can post it
in a gist at <https://gist.github.com/> and link it here or upload the build
log as a file.

Note: Make sure to include the exact command-line used for all commands and to
include the full output of ./configure.

Feel free to include only the errors in the make output if they are
self-explanatory (for example, with `make >/dev/null`).
-->

_Post the commands used to reproduce the issue and their output_

Example:

```console
$ ./configure --prefix=/usr --enable-apparmor
checking for gcc... gcc
checking whether the C compiler works... yes
[...]
$ make
make -C src/lib
gcc [...]
[...]
```

_If ./configure fails, include the output of config.log_

Example:

```console
$ cat config.log
This file contains any messages produced by compilers while
running configure, to aid debugging if configure makes a mistake.
[...]
```

### Additional context

_(Optional) Any other detail that may help to understand/debug the problem_

### Environment

- Name/version/arch of the Linux kernel (e.g. the output of `uname -srm`)
- Name/version of the Linux distribution (e.g. "Ubuntu 20.04" or "Arch Linux")
- Name/version of the C compiler (e.g. "gcc 14.1.1-1")
- Name/version of the libc (e.g. "glibc 2.40-1")
- Version of the Linux API headers (e.g. "linux-api-headers 6.10-1" on Arch Linux)
- Version of the source code being built (e.g. the output of `git rev-parse HEAD`)
