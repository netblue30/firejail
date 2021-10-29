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
  install_dir: get_option('libdir') / meson.project_name(),
  install_mode: 'rwx--x--x',
)
