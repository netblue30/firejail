Welcome to firejail, and thank you for your interest in contributing!

# Opening an issue:
We welcome issues, whether to ask a question, provide information, request a new profile or
feature, or to report a suspected bug or problem.

If you want to request a program profile that we don't already have, please add a comment in
our [dedicated issue](https://github.com/netblue30/firejail/issues/1139).

When submitting a bug report, please provide the following information so that
we can handle the report more easily:
 - firejail version. If you're not sure, open a terminal and type `firejail --version`.
 - Linux distribution (so that we can try to reproduce it, if necessary).
 - If you know that the problem did not exist in an earlier version of firejail, please mention it.
 - If you are reporting that a program does not work with firejail, please also run firejail with
 the `--noprofile` argument.
 For example, if `firejail firefox` does not work, please also run `firejail --noprofile firefox` and
 let us know if it runs correctly or not.
 - You may also try disabling various options provided in `/etc/firejail/<ProgramName.profile>` until you find out which one causes problems. It will significantly help to find solution for your issue.

We take security bugs very seriously. If you believe you have found one, please report it by
emailing us at netblue30@yahoo.com
