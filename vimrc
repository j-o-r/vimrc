" -----------------------------------------------------------------------
scriptencoding utf-8
" vim-plug plugin manager :PlugInstall
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')
" @see autoload/plug.vim for syntax and other goodies
  " https://github.com/vim-syntastic/syntastic
  Plug 'https://github.com/vim-syntastic/syntastic.git'
  " ycm https://github.com/valloric/youcompleteme
  Plug 'https://github.com/Valloric/YouCompleteMe.git'
  " JsDoc https://github.com/heavenshell/vim-jsdoc
  Plug 'https://github.com/heavenshell/vim-jsdoc.git'
  " https://github.com/majutsushi/tagbar
  Plug 'https://github.com/majutsushi/tagbar.git'
  " rust-lang https://github.com/rust-lang/rust.vim
  Plug 'https://github.com/rust-lang/rust.vim.git'
  " https://github.com/tpope/vim-fugitive
call plug#end()
" MINIMAL SET UP
" Set shell mode for VIM
set shell=/bin/bash
" set cryptionmethod to blowfish2 standard
" http://vim.wikia.com/wiki/Encryption
set cm=blowfish2
" backup / swap settings
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backupfiles//
set backup
set writebackup
set encoding=utf-8
"more characters will be sent to the screen for redrawing
set ttyfast
" time waited for key press(es) to complete. It makes for a faster key response
set ttimeout
set ttimeoutlen=50
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Show vim mode (--INSERT-- --VIUAL-- etc)
set showmode
" Display incomplete commands
set showcmd
" hide buffers instead of closing them even if they contain unwritten changes
set hidden
" set background color mode (for better contrast)
" set background=dark
colo github
" Autointending on
set autoindent
" set tab to spaces
set expandtab
" a tab is 2 spaces
set tabstop=2
" indentation with 2 spaces
set shiftwidth=2
" Disable soft wrap for lines
set nowrap
" Display line numbers
set number
" Highlight current line
set cursorline
" Display text width column
set colorcolumn=81
" new splis will be at the bottom or the right side of the screen
set splitbelow
set splitright
" Incremental search
set incsearch
" highlight search
set hlsearch
set wildmenu
set wildmode=longest:full,full

" Always display status line
set laststatus=2

set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %y
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" ----- CUSTOM THINGIES ---
" To see those nifty chars
" set listchars=nbsp:☠,tab:▸␣
set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
" use `:set` list to see them
" or `:set list!` to not see them

" Append modeline after last line in buffer.
function! AppendModeline()
  let l:modeline = " vim: set ts=2 sw=2 et :"
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
" type '\ml tp append the inline conf to the file
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
syntax on
" set clipboard=unnamedplus
" :FormatJson format the current JSON buffer
command FormatJson execute "%!python -m json.tool"
" type :Diff to show a diff of unsaved changes
command ShowDiff execute 'w !git diff --no-index % -'
" trim all spaces from line endings (trailing)
autocmd BufWritePre * %s/\s\+$//e

" e.g. :Shell cargo +nightly clippy
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize ' . line('$')
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
" Plugin settings
" --------------
" syntastic
" let g:syntastic_java_javac_classpath = "/home/jd/Android/Sdk/platforms/android-22/*.jar"
" let g:syntastic_html_tidy_ignore_errors = [ 'proprietary attribute', 'trimming empty ', 'is not recognized!', 'discarding unexpected' ]
let g:syntastic_rust_checkers = ['cargo']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:ycm_filetype_blacklist = { 'rust': 1 }
" let g:syntastic_debug = 17
" set verbosefile=syntastic.log
" set verbose=15

" jsdoc conf : http://vimawesome.com/plugin/vim-jsdoc
let g:jsdoc_enable_es6=1
let g:jsdoc_allow_input_prompt=1

let g:rustfmt_autosave = 1
nmap <F8> :TagbarToggle<CR>
" vim: set ts=2 sw=2 et :
