fseccomp_sources = [
  'main.c',
  'protocol.c',
  'seccomp.c',  
  'seccomp_file.c',
  'seccomp_secondary.c',
                          
  '../lib/common.c',       
  '../lib/errno.c',
  '../lib/syscall.c',
]
fseccomp = executable('fseccomp', fseccomp_sources,
  install: true,
  install_dir: libdir_firejail,
  install_mode: sbox_apps_non_dumpable_perms,

  c_args: [
    c_args, constants, facilities,
  ],
)
