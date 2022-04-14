" Plugins to install
" Vim surround
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

tnoremap ` <esc>
tnoremap <esc> <C-\><C-n>
" <install supertab>

" delete without yanking
nnoremap <leader>d "_d"
vnoremap <leader>d "_d"

"replace selected text with default register (without yanking it)
nnoremap <leader>p viw"0p
vnoremap <leader>p "0p

" copy current directory into the unamed buffer
:nmap cp :let @" = expand("%:h")<cr>


" update vim
noremap <leader>s :source ~/.vimrc<cr>
" Better window navigation
noremap <leader>h <C-w>h
noremap <leader>j <C-w>j
noremap <leader>k <C-w>k
noremap <leader>l <C-w>l
" Better window paning
noremap <leader>H <C-w>H
noremap <leader>J <C-w>J
noremap <leader>K <C-w>K
noremap <leader>L <C-w>L
" Better window paning resize
noremap <leader>+ <C-w>+
noremap <leader>- <C-w>-
noremap <leader>< <C-w>>
noremap <leader>> <C-w><


" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>


"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
"turn off search highlight
"nnoremap <leader><space> :nohlsearch<CR>

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
