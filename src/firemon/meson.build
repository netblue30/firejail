firemon_sources = [
  'firemon.c',
  'apparmor.c',
  'arp.c',
  'caps.c',
  'cgroup.c',
  'cpu.c',
  'interface.c',
  'list.c',
  'netstats.c',
  'procevent.c',
  'route.c',
  'seccomp.c',
  'top.c',
  'tree.c',
  'usage.c',
  'x11.c',

  '../lib/common.c',
  '../lib/pid.c',
]

executable('firemon', firemon_sources,
  install: true,

  c_args: [
    c_args, constants, facilities,
  ],
)
