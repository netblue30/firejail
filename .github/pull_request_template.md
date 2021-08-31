If your PR isn't about profiles or you have no idea how to do one of these, skip the following and go ahead with this PR.

If you submit a PR for new profiles or changing profiles, please do the following:
 - The ordering of options follow the rules described in [/usr/share/doc/firejail/profile.template](https://github.com/netblue30/firejail/blob/master/etc/templates/profile.template).  
   > Hint: The profile-template is very new. If you install firejail with your package manager, it may be missing. In order to follow the latest rules, it is recommended to use the template from the repository.
 - Order the arguments of options alphabetically. You can easily do this with [sort.py](https://github.com/netblue30/firejail/tree/master/contrib/sort.py).  
 The path to it depends on your distro:

   | Distro | Path |
   | ------ | ---- |
   | Arch/Fedora | `/usr/lib64/firejail/sort.py` |
   | Debian/Ubuntu/Mint | `/usr/lib/x86_64-linux-gnu/firejail/sort.py` |
   | local git clone | `contrib/sort.py` |

   Note also that the sort.py script exists only since firejail `0.9.61`.

See also [CONTRIBUTING.md](/CONTRIBUTING.md).
