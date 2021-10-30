firejail_bash_completion = configure_file(
  configuration: {'SYSCONFDIR': sysconfdir},
  input: 'firejail.bash_completion.in',
  output: '@BASENAME@',
)
custom_target(manpage,
  build_by_default: true,
  capture: true,
  # BIG FAT FIXME: This will fail if -Dmanpage=false
  command: [gawk, '-f', preproc_awk,  '--', facilities, '@INPUT@'],
  input: firejail_bash_completion,
  install: true,
  install_dir: bashcompletiondir,
  output: 'firejail',
)

install_data('firecfg.bash_completion', 'firemon.bash_completion',
  install_dir: bashcompletiondir,
  rename: ['firecfg', 'firemon']
)
