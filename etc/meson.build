install_data(
  sources: ['firejail.config', 'ids.config', 'login.users'],
  install_dir: sysconfdir / project_name,
)

foreach dir : ['inc', 'net', 'profile-a-l', 'profile-m-z']
  install_subdir(dir,
    exclude_files: ['disable-common.inc'],
    install_dir: sysconfdir / project_name,
    strip_directory: true,
  )
endforeach

if get_option('busybox')
  #TODO: meson.add_install_script()
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
