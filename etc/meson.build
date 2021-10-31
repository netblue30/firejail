install_data('firejail.config', 'ids.config', 'login.users',
  install_dir: sysconfdir / project_name,
)

foreach dir : ['inc', 'net', 'profile-a-l', 'profile-m-z']
  install_subdir(dir,
    exclude_files: ['disable-common.inc'],
    install_dir: sysconfdir / project_name,
    strip_directory: true,
  )
endforeach

if get_option('busybox-workaround')
  meson.add_install_script(sh.path(), '-e', '-c',
'''
disable_common_inc="$MESON_INSTALL_DESTDIR_PREFIX/$1/firejail/disable-common.inc"
cat >"$disable_common_inc" <<\EOF
# Workaround for systems where common UNIX utilities are symlinks to busybox.
# If this is not your case you can remove -Dbusybox-workaround=true from
# meson setup options, for added security.
noblacklist ${PATH}/busybox
noblacklist ${PATH}/crontab
noblacklist ${PATH}/mount
noblacklist ${PATH}/nc
noblacklist ${PATH}/su
noblacklist ${PATH}/sudo
noblacklist ${PATH}/umount

EOF
cat >>"$disable_common_inc" <"$2"
''', '--', sysconfdir, meson.current_source_dir() / 'inc/disable-common.inc',
  )
else
  install_data('inc/disable-common.inc',
    install_dir: sysconfdir / project_name,
  )
endif

install_subdir('templates',
  install_dir: docdir,
  strip_directory: true,
)

if get_option('apparmor')
  install_data('apparmor/firejail-default',
    install_dir: sysconfdir / 'apparmor.d',
  )
  install_data('apparmor/firejail-local',
    install_dir: sysconfdir / 'apparmor.d' / 'local',
    rename: 'firejail-default',
  )
  install_data('apparmor/firejail-base',
    install_dir: sysconfdir / 'apparmor.d' / 'abstractions' / 'base.d',
  )
endif
