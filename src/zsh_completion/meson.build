firejail_zsh_completion = configure_file(
  configuration: {'SYSCONFDIR': sysconfdir},
  input: '_firejail.in',
  output: 'firejail.zsh_completion',
)
custom_target('firejail.zsh_completion',
  build_by_default: true,
  capture: true,
  # BIG FAT FIXME: This will fail if -Dmanpage=false
  command: [gawk, '-f', preproc_awk,  '--', facilities, '@INPUT@'],
  input: firejail_zsh_completion,
  install: true,
  install_dir: zshcompletiondir,
  output: '_firejail',
)
