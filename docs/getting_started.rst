.. _getting_started:

Getting Started with Firejail
================================================================================

A brief overview of Firejail, how to install it, and some common uses.

What is Firejail?
--------------------------------------------------------------------------------
Firejail is a sandbox program for Linux that aims to do three things:

1. Reduce the risk of security breaches by isolating and `sandboxing`_ programs.
2. Integrate well with other existing technology like SELinux or AppArmor.
3. Be easy to use, with very little consumption of computer resources.

Traditional Linux sandboxes have offered fine-grained control for users, but
often at the cost of being difficult to configure and use. In contrast, there is
no *difficult* in Firejail, at least no *SELinux-difficult*. For us, the
user always comes first. We want Firejail to be simple to use, powerful but not
complicated.


Quick install tips
--------------------------------------------------------------------------------
As with many other Linux programs, it's best to check if Firejail is present in
your distribution's repositories and install from there, unless you need a
specific version. Many distributions, such as Arch, Debian, Gentoo, and Ubuntu,
provide Firejail.

We also provide pre-built packages of the `latest release`_ and
`latest long-term support (LTS) release`_ on our Sourceforge download page.

.. _sandboxing: https://en.wikipedia.org/wiki/Sandbox_(computer_security)
.. _latest release: https://sourceforge.net/projects/firejail/files/firejail/
.. _latest long-term support (LTS) release: https://sourceforge.net/projects/firejail/files/LTS/
