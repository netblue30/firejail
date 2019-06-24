If you make a PR for new profiles or changeing profiles please do the following:
 - The ordering of options follow the rules descripted in [/usr/share/doc/firejail/profile.template](https://github.com/netblue30/firejail/blob/master/etc/templates/profile.template).  
   Hint: The profile-template is very new, if you install firejail with your package-manager, it maybe missing, therefore, and to follow the latest rules, it is recommended to use the template from the repository.
 - Order the arguments of options alphabetical, you can easy do this with the [sort.py](https://github.com/netblue30/firejail/tree/master/contrib/sort.py).  
 The path to it depends on your distro:
 
   | Distro | Path |
   | ------ | ---- |
   | Arch/Fedora | `/lib64/firejail/sort.py` |
   | Debian/Ubuntu/Mint | `/usr/lib/x86_64-linux-gnu/firejail/sort.py` |
   | local git clone | `contrib/sort.py` |

   Note also that the sort.py script exists only since firejail `0.9.61`.

If you have no idea how to do one of these, you can open the PR anyway.

See also [CONTRIBUTING.md](/CONTRIBUTING.md).
