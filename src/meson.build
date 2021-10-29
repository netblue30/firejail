PREFIX = get_option('prefix')
BINDIR = PREFIX / get_option('bindir')
SYSCONFDIR = PREFIX / get_option('sysconfdir')
LIBDIR = PREFIX / get_option('libdir')

constants = {
  'PREFIX': PREFIX,
  'BINDIR': BINDIR,
  # WTF
  'SYSCONFDIR': SYSCONFDIR / meson.project_name(),
  'LIBDIR': LIBDIR,

  'VERSION': meson.project_version(),
  'VARDIR': '/var/lib/firejail',
}

c_args_constants = []
foreach name, value : constants
  c_args_constants += '-D@0@="@1@"'.format(name, value)
endforeach

# # # # # # # # # #

libdir_firejail = get_option('libdir') / meson.project_name()
sbox_apps_non_dumpable_perms = 'rwx--x--x'

# APPS
subdir('firecfg')
subdir('firejail')
subdir('firemon')
subdir('jailcheck')
subdir('profstats')

# SBOX_APPS
subdir('fbuilder')
subdir('fids')
subdir('ftee')

# SBOX_APPS_NON_DUMPABLE
subdir('fcopy')
subdir('fldd')
subdir('fnet')
subdir('fnetfilter')
subdir('fseccomp')
subdir('fsec-optimize')   
subdir('fsec-print')
subdir('fshaper')

# MYLIBS
subdir('libpostexecseccomp')
#subdir('libtrace')
#subdir('libtracelog')

# MANPAGES
if get_option('man') and false
  subdir('man')
endif

# COMPLETIONDIRS
#subdir('bash_completion')
#subdir('zsh_completion')

# # # # # # # # # #

# TODO: fsec-optimize OUTPUT (add_install_script ?)
custom_target('seccomp',
  build_by_default: true,
  command: [fseccomp, 'default', '@OUTPUT@'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp',
)

# TODO: fsec-optimize OUTPUT
custom_target('seccomp.debug',
  build_by_default: true,
  command: [fseccomp, 'default', '@OUTPUT@', 'allow-debuggers'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp.debug',
)

# TODO: fsec-optimize OUTPUT
custom_target('seccomp.32',
  build_by_default: true,
  command: [fseccomp, 'secondary', '32', '@OUTPUT@'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp.32',
)

custom_target('seccomp.block_secondary',
  build_by_default: true,
  command: [fseccomp, 'secondary', 'block', '@OUTPUT@'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp.block_secondary',
)

custom_target('seccomp.mdwx',
  build_by_default: true,
  command: [fseccomp, 'memory-deny-write-execute', '@OUTPUT@'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp.mdwx',
)

custom_target('seccomp.mdwx.32',
  build_by_default: true,
  command: [fseccomp, 'memory-deny-write-execute.32', '@OUTPUT@'],
  install: true,
  install_dir: libdir_firejail,
  output: 'seccomp.mdwx.32',
)
