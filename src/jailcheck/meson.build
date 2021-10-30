jailcheck_sources = [
  'main.c',
  'access.c',
  'apparmor.c',
  'network.c',
  'noexec.c',
  'seccomp.c',
  'sysfiles.c',
  'utils.c',
  'virtual.c',

  '../lib/common.c',
  '../lib/pid.c',
] 

executable('jailcheck', jailcheck_sources,
  install: true,
  
  c_args: [  
    c_args, constants, facilities,
  ],
) 
