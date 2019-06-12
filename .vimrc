"REMEMBER TO INSTALL VIM SURROUND!!!!!
colo ron
set number relativenumber
augroup numbertoggle
autocmd!
autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set wildmode=full
"doesn't lose register when pasting using viwp. Use viwd if you want to overright register
xnoremap p pgvy
"set statusline=%f "displays file name
set statusline="%f%m%r%h%w [%Y] [0x%02.2B]%< %F%=%4v,%4l %3p%% of %L"
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set backspace=indent,eol,start
syntax enable           " enable syntax processing
set showcmd             " show command in bottom bar
set cursorline          " highlight current line
filetype indent on      " load filetype-specific indent files
set wildmenu            " visual autocomplete for command menu
"set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set fillchars+=vert:│ " changes the panel colours
hi VertSplit ctermbg=NONE guibg=NONE


"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
"turn off search highlight
"nnoremap <leader><space> :nohlsearch<CR>
"inoremap <BS> <Nop>
"inoremap <Del> <Nop>
"if $TERM_PROGRAM =~ "iTerm"
"  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
"  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
"endif

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>





if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" plugins
let g:HardMode_level = 'wannabe'
let g:HardMode_hardmodeMsg = "Don't use this!"
autocmd VimEnter,BufNewFile,BufReadPost * silent! call HardMode()
