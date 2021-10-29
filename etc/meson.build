install_data(
  sources: ['firejail.config', 'ids.config', 'login.users'],
  install_dir: get_option('sysconfdir') / meson.project_name(),
)

foreach dir : ['inc', 'net', 'profile-a-l', 'profile-m-z']
  install_subdir(dir,
    install_dir: get_option('sysconfdir') / meson.project_name(),
    strip_directory: true,
  )
endforeach

install_subdir('templates',
  install_dir: get_option('datadir') / 'doc' / meson.project_name(),
  strip_directory: true,
)

install_data('apparmor/firejail-default',
  install_dir: get_option('sysconfdir') / 'apparmor.d',
)
install_data('apparmor/firejail-local',
  install_dir: get_option('sysconfdir') / 'apparmor.d' / 'local',
  rename: 'firejail-default',
)
install_data('apparmor/firejail-base',
  install_dir: get_option('sysconfdir') / 'apparmor.d' / 'abstractions' / 'base.d',
)

# TODO: get_option('busybox') >> edit disable-common.inc
