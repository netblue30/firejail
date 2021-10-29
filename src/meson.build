PREFIX = get_option('prefix')
BINDIR = PREFIX / get_option('bindir')
SYSCONFDIR = PREFIX / get_option('sysconfdir')
LIBDIR = PREFIX / get_option('libdir')

constants = {
  'PREFIX': PREFIX,
  'BINDIR': BINDIR,
  'SYSCONFDIR': SYSCONFDIR,
  'LIBDIR': LIBDIR,

  'VERSION': meson.project_version(),
  'VARDIR': '/var/lib/firejail',
}

c_args_constants = []
foreach name, value : constants
  c_args_constants += '-D@0@="@1@"'.format(name, value)
endforeach

# # # # # # # # # #

subdir('firecfg')
subdir('firejail')
subdir('firemon')
subdir('jailcheck')
subdir('profstats')
 
subdir('fbuilder')
subdir('fcopy')
subdir('fids')
subdir('fldd')
subdir('fnet')
subdir('fnetfilter')
subdir('fseccomp')
subdir('fsec-optimize')   
subdir('fsec-print')
subdir('fshaper')
subdir('ftee')
 
subdir('libpostexecseccomp')
#subdir('libtrace')
#subdir('libtracelog')
 
if get_option('man') and false
  subdir('man')
endif
 
#subdir('bash_completion')
#subdir('zsh_completion')

# # # # # # # # # #

# TODO: fsec-optimize OUTPUT
custom_target('seccomp',
  build_by_default: true,
  command: [fseccomp, 'default', '@OUTPUT@'],
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  output: 'seccomp',
)

# TODO: fsec-optimize OUTPUT
custom_target('seccomp.32',
  build_by_default: true,
  command: [fseccomp, 'secondary', '32', '@OUTPUT@'],
  install: true,
  install_dir: get_option('libdir') / meson.project_name(),
  output: 'seccomp.32',
)
