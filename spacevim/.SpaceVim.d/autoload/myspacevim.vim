function! myspacevim#before() abort
  call SpaceVim#logger#info('myspacevim#before called')

  " let g:neoformat_typescriptreact_eslint = {
  "       \ 'exe': 'eslint_d',
  "       \ 'args': ['--ext', '.js,.jsx,.ts,.tsx', "%:p"],
  "       \ 'stdin': 1
  "       \ }
  " let g:neoformat_enabled_typescriptreact = ['eslint']
  " let g:neoformat_typescript_eslint = {
  "       \ 'exe': 'eslint_d',
  "       \ 'args': ['--ext', '.js,.jsx,.ts,.tsx', "%:p"],
  "       \ 'stdin': 1
  "       \ }
  " let g:neoformat_enabled_typescript = ['eslint']
  " let g:neoformat_javascript_eslint = {
  "       \ 'exe': 'eslint_d',
  "       \ 'args': ['--ext', '.js,.jsx,.ts,.tsx', "%:p"],
  "       \ 'stdin': 1
  "       \ }
  " let g:neoformat_enabled_javascript = ['eslint']

endfunction

function! myspacevim#after() abort
  call SpaceVim#logger#info('myspacevim#after called')

  set timeoutlen=50

  set wrap
endfunction
