# Firejail

Firejail is a SUID sandbox program that reduces the risk of security breaches by restricting
the running environment of untrusted applications using Linux namespaces, seccomp-bpf
and Linux capabilities. It allows a process and all its descendants to have their own private
view of the globally shared kernel resources, such as the network stack, process table, mount table.
Firejail can work in a SELinux or AppArmor environment, and it is integrated with Linux Control Groups.

Written in C with virtually no dependencies, the software runs on any Linux computer with a 3.x kernel
version or newer. It can sandbox any type of processes: servers, graphical applications, and even
user login sessions. The software includes sandbox profiles for a number of more common Linux programs,
such as Mozilla Firefox, Chromium, VLC, Transmission etc.

The sandbox is lightweight, the overhead is low. There are no complicated configuration files to edit,
no socket connections open, no daemons running in the background. All security features are
implemented directly in Linux kernel and available on any Linux computer. To start the sandbox,
prefix your command with “firejail”:

`````
$ firejail firefox            # starting Mozilla Firefox
$ firejail transmission-gtk   # starting Transmission BitTorrent 
$ firejail vlc                # starting VideoLAN Client
$ sudo firejail /etc/init.d/nginx start
`````
Project webpage: https://firejail.wordpress.com/

Download and Installation: https://firejail.wordpress.com/download-2/

Features: https://firejail.wordpress.com/features-3/

Documentation: https://firejail.wordpress.com/documentation-2/

FAQ: https://firejail.wordpress.com/support/frequently-asked-questions/

# Current development version: 0.9.37

## Symlink invocation

This is a small thing, but very convenient. Make a symbolic link (ln -s) to /usr/bin/firejail under
the name of the program you want to run, and put the link in the first $PATH position (for
example in /usr/local/bin). Example:
`````
$ which -a transmission-gtk 
/usr/bin/transmission-gtk

$ sudo ln -s /usr/bin/firejail /usr/local/bin/transmission-gtk

$ which -a transmission-gtk 
/usr/local/bin/transmission-gtk
/usr/bin/transmission-gtk
`````
We have in this moment two entries in $PATH for transmission. The first one is a symlink to firejail.
The second one is the real program. Starting transmission in this moment, invokes "firejail transmission-gtk"
`````
$ transmission-gtk
Redirecting symlink to /usr/bin/transmission-gtk
Reading profile /etc/firejail/transmission-gtk.profile
Reading profile /etc/firejail/disable-mgmt.inc
Reading profile /etc/firejail/disable-secret.inc
Reading profile /etc/firejail/disable-common.inc
Reading profile /etc/firejail/disable-devel.inc
Parent pid 19343, child pid 19344
Blacklist violations are logged to syslog
Child process initialized
`````


## IPv6 support:
`````
      --ip6=address
              Assign IPv6 addresses to the last network interface defined by a
              --net option.

              Example:
              $ firejail --net=eth0 --ip6=2001:0db8:0:f101::1/64 firefox

       --netfilter6=filename
              Enable the IPv6 network filter specified by filename in the  new
              network  namespace.  The  filter  file  format  is the format of
              ip6tables-save  and  ip6table-restore  commands.   New   network
              namespaces  are  created  using  --net  option. If a new network
              namespaces is not created, --netfilter6 option does nothing.

`````

## join command enhancements

`````
       --join-filesystem=name
              Join the mount namespace of the sandbox identified by  name.  By
              default  a /bin/bash shell is started after joining the sandbox.
              If a program is specified, the program is run  in  the  sandbox.
              This  command is available only to root user.  Security filters,
              cgroups and cpus configurations are not applied to  the  process
              joining the sandbox.

       --join-filesystem=pid
              Join  the  mount  namespace of the sandbox identified by process
              ID. By default a /bin/bash shell is started  after  joining  the
              sandbox.   If  a program is specified, the program is run in the
              sandbox. This command is available only to root user.   Security
              filters,  cgroups and cpus configurations are not applied to the
              process joining the sandbox.

      --join-network=name
              Join the network namespace of the sandbox identified by name. By
              default  a /bin/bash shell is started after joining the sandbox.
              If a program is specified, the program is run  in  the  sandbox.
              This  command is available only to root user.  Security filters,
              cgroups and cpus configurations are not applied to  the  process
              joining the sandbox.

       --join-network=pid
              Join  the network namespace of the sandbox identified by process
              ID. By default a /bin/bash shell is started  after  joining  the
              sandbox.   If  a program is specified, the program is run in the
              sandbox. This command is available only to root user.   Security
              filters,  cgroups and cpus configurations are not applied to the
              process joining the sandbox.

`````


## New profiles: KMail



