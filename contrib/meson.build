contrib_scripts = [
  'fix_private-bin.py',
  'fjclip.py',
  'fjdisplay.py',
  'fj-mkdeb.py',
  'fjresize.py',
  'gdb-firejail.sh',
  'jail_prober.py',
  'sort.py',
  'syscalls.sh',
  'update_deb.sh',
]
install_data(contrib_scripts,
  install_dir: libdir_firejail,
  install_mode: 'rwxr-xr-x',
)

install_data('vim/ftdetect/firejail.vim',
  install_dir: datadir / 'vim' / 'vimfiles' / 'ftdetect',
)
install_data('syntax/files/firejail.vim.in',
  install_dir: datadir / 'vim' / 'vimfiles' / 'syntax',
)
