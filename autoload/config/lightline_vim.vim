scriptencoding utf8

fu! config#lightline_vim#before()
  let g:lightline = {}
  " let g:lightline.colorscheme = 'gruvbox'
  " let g:lightline.colorscheme = 'seoul256'
  let g:lightline.colorscheme = 'solarized'

  let g:lightline.active = {}
  let g:lightline.active.left = [['mode', 'paste'], ['fugitive', 'readonly', 'filename', 'modified', 'ale']]
  let g:lightline.active.right = [['lineinfo'], ['fileformat', 'fileencoding', 'percent']]
  let g:lightline.inactive = {}
  let g:lightline.inactive.left = [['fugitive', 'readonly', 'filename', 'modified']]
  let g:lightline.inactive.right = [['lineinfo'], ['fileformat', 'fileencoding', 'percent']]
  let g:lightline.tabline = {
        \ 'left': [['tabs']],
        \ 'right': [['filetype']]
        \ }
  let g:lightline.tab = {
        \ 'active': [ 'tabnum', 'filename', 'modified' ],
        \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

  let g:lightline.component_function = {}
  let g:lightline.component_function.readonly = 'config#lightline_vim#readonly'
  let g:lightline.component_function.modified = 'config#lightline_vim#modified'
  let g:lightline.component_function.fugitive = 'config#lightline_vim#fugitive'
  let g:lightline.component_function.filename = 'config#lightline_vim#filename'
  let g:lightline.component_function.filetype = 'config#lightline_vim#filetype'
  let g:lightline.component_function.fileformat = 'config#lightline_vim#fileformat'
  let g:lightline.component_function.fileencoding = 'config#lightline_vim#file_encoding'
  let g:lightline.component_function.mode = 'config#lightline_vim#mode'
  let g:lightline.component_function.ale = 'config#lightline_vim#ale'

  " statusline separator
  if g:no_nerd_font
    let g:lightline.separator = {'left':  '', 'right': ''}
    let g:lightline.subseparator = {'left': '|', 'right': '|'}
    " tabline separator
    let g:lightline.tabline_separator = g:lightline.separator
    let g:lightline.tabline_subseparator = g:lightline.subseparator
  else
    let g:lightline.separator = {'left':  '', 'right': ''}
    let g:lightline.subseparator = {'left': '', 'right': ''}
    " tabline separator
    let g:lightline.tabline_separator = g:lightline.separator
    let g:lightline.tabline_subseparator = g:lightline.subseparator
  endif

  let g:lightline.enable = {
        \ 'statusline': 1,
        \ 'tabline': 1
        \ }

  if g:is_win_unix || (g:is_win && !g:is_gui)
    unlet g:lightline.colorscheme
  endif

  let g:tagbar_status_func = 'config#lightline_vim#tagbar_statusline'
endf

fu! config#lightline_vim#after()
  call lightline#update()
endf

" -------------------------------------

fu! config#lightline_vim#readonly()
  if g:no_nerd_font
    return &ft !~? 'help' && &readonly ? 'RO' : ''
  elseif !g:is_osx
    return &ft !~? 'help' && &readonly ? '' : ''
  else
    return &ft !~? 'help' && &readonly ? emoji#for('lock') : emoji#for('shamrock')
  endif
endf

fu! config#lightline_vim#modified()
  if g:no_nerd_font
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : ''
  elseif !g:is_osx
    return &ft =~ 'help' ? '' : &modified ? '✭' : &modifiable ? '' : ''
  else
    return &ft =~ 'help' ? '' : &modified ? emoji#for('small_orange_diamond')
          \ : &modifiable ? emoji#for('diamonds') : emoji#for('lock')
  endif
endf

fu! config#lightline_vim#fugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? ''.branch : ''
    en
  catch
  endtry
  return ''
endf

fu! config#lightline_vim#filename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ ('' != fname ? fname : '[No Name]')
endf

fu! config#lightline_vim#filetype()
  if exists('*config#vim_devicons#filetype')
    return config#vim_devicons#filetype()
  else
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  en
endf

fu! config#lightline_vim#fileformat()
  if exists('*config#vim_devicons#fileformat')
    return config#vim_devicons#fileformat()
  else
    return winwidth(0) > 70 ? &fileformat : ''
  endif
endf

fu! config#lightline_vim#file_encoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endf

fu! config#lightline_vim#mode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endf

fu! config#lightline_vim#ale()
  if exists('*config#ale#statusline')
    return config#ale#statusline()
  else
    return ''
  endif
endf

fu! config#lightline_vim#tagbar_statusline(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endf
