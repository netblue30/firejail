# Security Policy

## Supported Versions

Unless explicitly stated otherwise, we only support the latest released version
(and the current development version) of firejail, which should be the one in
the following page:

* <https://github.com/netblue30/firejail/releases/latest>

Versions older than the latest usually have outdated profiles and may contain
bugs and security vulnerabilities that were already fixed in a later version.

See [Installing](README.md#installing) for distribution-specific instructions
and recommendations.

If the firejail version in your distribution is older than the latest released
version (and at least a few days have passed since the release), please contact
the maintainers for your distribution and request an update to the relevant
package(s).

In the meantime, you can [build and install](README.md#building) the current
development version.

See also [CONTRIBUTING.md](CONTRIBUTING.md).

Released versions are listed in the table below, which is mostly intended for
historical reference and may be outdated and/or incomplete.

| Version | Supported by us    | EOL                | Supported by distribution                                                         |
| ------- | ------------------ | ------------------ | --------------------------------------------------------------------------------- |
| 0.9.78  | :heavy_check_mark: |                    |                                                                                   |
| 0.9.76  | :x:                |                    |                                                                                   |
| 0.9.74  | :x:                |                    |                                                                                   |
| 0.9.72  | :x:                |                    | :white_check_mark: Debian 11 **backports**, Debian 12, Ubuntu 24.04 LTS           |
| 0.9.70  | :x:                |                    |                                                                                   |
| 0.9.68  | :x:                |                    |                                                                                   |
| 0.9.66  | :x:                |                    | :white_check_mark: Ubuntu 22.04 LTS                                               |
| 0.9.64  | :x:                |                    | :white_check_mark: Debian 11                                                      |
| 0.9.62  | :x:                |                    | :white_check_mark: Ubuntu 20.04 LTS                                               |
| 0.9.60  | :x:                | 29 Dec 2019        |                                                                                   |
| 0.9.58  | :x:                |                    |                                                                                   |
| 0.9.56  | :x:                | 27 Jan 2019        |                                                                                   |
| 0.9.54  | :x:                | 18 Sep 2018        |                                                                                   |
| 0.9.52  | :x:                |                    | :white_check_mark: Ubuntu 18.04 LTS                                               |
| 0.9.50  | :x:                | 12 Dec 2017        |                                                                                   |
| 0.9.48  | :x:                | 09 Sep 2017        |                                                                                   |
| 0.9.46  | :x:                | 12 Jun 2017        |                                                                                   |
| 0.9.44  | :x:                |                    |                                                                                   |
| 0.9.42  | :x:                | 22 Oct 2016        |                                                                                   |
| 0.9.40  | :x:                | 09 Sep 2016        |                                                                                   |
| 0.9.38  | :x:                | 31 May 2016        |                                                                                   |
| <0.9.38 | :x:                | Before 05 Feb 2016 |                                                                                   |

Note: Even if a distribution version is still supported, it doesn't mean that
the individual package for firejail is well maintained. Be careful with older
distributions!

## Security vulnerabilities

We take security bugs very seriously.

If you believe you have found one, please report it to:

* <netblue30@protonmail.com>
