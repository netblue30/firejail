# libtrace/libtracelog do not compile with shared_library(), instead we
# directly call the compiler. Therefore we need additional flags which
# are set otherwise by meson.
c_args_libtrace = ['-Wall', '-O2', '-shared', '-fPIC', '-Wl,-z,relro']
#c_args_libtrace += ['-O' + get_option('optimization')]
if get_option('werror')
  c_args_libtrace += ['-Werror']
endif

# # # # # # # # # #

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
subdir('libtrace')
subdir('libtracelog')

# MANPAGES
if get_option('manpage')
  subdir('man')
endif

# COMPLETIONDIRS
subdir('bash_completion')
subdir('zsh_completion')

# # # # # # # # # #

build_make_compile_seccmop_filters_sh = files('build-make-compile-seccomp-filters.sh')
custom_target('seccomp filters',
  build_by_default: true,
  command: [build_make_compile_seccmop_filters_sh, fseccomp, fsec_optimize, '@OUTDIR@'],
  install: true,
  install_dir: libdir_firejail,
  output: [
    'seccomp',
    'seccomp.debug',
    'seccomp.32',
    'seccomp.block_secondary',
    'seccomp.mdwx',
    'seccomp.mdwx.32',
  ],
)
