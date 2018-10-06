Installing Firejail
================================================================================

Install from distributions repositories (recommended)
-------------------------------------------------------------------------------
Some common Linux distributions to provide Firejail in their repositories are:
 - `Alpine`_
 - `Arch`_
 - `Debian`_
 - `Gentoo`_
 - `Ubuntu`_


*Notes:*

1. For Ubuntu users (or those who use derivatives like Linux Mint) who want to always have the latest version of Firejail, we also provide a `PPA`_
2. Ubuntu and Debian users: when installing Firejail from the repository or the PPA, you will probably also want to install the **firejail-profiles** package:

.. code-block:: bash

  sudo apt install firejail firejail-profiles


Install directly
--------------------------------------------------------------------------------
While we recommend installing from your Linux distribution's repositories, there
may be times you want to get Firejail directly from the developers.



.. _Alpine: https://pkgs.alpinelinux.org/packages?name=firejail
.. _Arch: https://www.archlinux.org/packages/community/x86_64/firejail/
.. _Debian: https://packages.debian.org/search?keywords=firejail&searchon=names&suite=all&section=all
.. _Gentoo: https://packages.gentoo.org/packages/sys-apps/firejail
.. _Ubuntu: https://packages.ubuntu.com/search?keywords=firejail&searchon=names&suite=all&section=all
.. _PPA: https://launchpad.net/~deki/+archive/ubuntu/firejail
