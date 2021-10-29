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

# TODO: apparmor
