If your PR isn't about profiles or you have no idea how to do one of these,
skip the following and go ahead with this PR.

If you submit a PR for new profiles or changing profiles, please do the
following:

- The ordering of options follow the rules described in
  [etc/templates/profile.template](../blob/master/etc/templates/profile.template)
  (/usr/share/doc/firejail/profile.template when installed).
- Order the arguments of options alphabetically. You can easily do this with
  [sort.py](../blob/master/contrib/sort.py).

  The path to it depends on your distro:

  | Distro | Path |
  | ------ | ---- |
  | Arch/Fedora | `/usr/lib64/firejail/sort.py` |
  | Debian/Ubuntu/Mint | `/usr/lib/x86_64-linux-gnu/firejail/sort.py` |
  | local git clone | `contrib/sort.py` |

See also [CONTRIBUTING.md](../blob/master/CONTRIBUTING.md).
