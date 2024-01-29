""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

syntax on                              " Enable syntax viewer

filetype plugin on                     " Enable filetype detection
filetype indent on                     " Enable per file type indentation

let g:indentLine_char = '⦙'            " Set the indent character
let mapleader=","                      " Change the leader character to a ,
let g:netrw_altv=1                     " Filebrowser open splits to the right
let g:netrw_banner=0                   " FileBrowser Disable banner
let g:netrw_liststyle=3                " Filebrowser tree view

set autoindent                         " enable auto indenting
set autoread                           " Autoread file on change
set background=dark                    " Make background dark for theming
set backspace=2                        " Set what we backspace past
set cindent                            " enable indeting in a c-style
set cmdheight=1                        " Set command bar to be 1 line high
set colorcolumn=80,100,120             " Mark columns
set completeopt=longest                " Auto completion auto add longest common string
set cursorline                         " Highlights the current line
set encoding=utf-8                     " Set the filetype encoding to utf-8
set expandtab                          " Change tab to space
set ff=unix                            " Default line endings
set fileformats=unix,dos               " File formats allowed
set foldlevel=99                       " Default is to have nothing folded
set foldmethod=indent                  " Set the method of folding to indentation
set gdefault                           " Enables find/replace for all by default
set hidden                             " Allows switching of buffers without saving
set hlsearch                           " Highlight search results
set ignorecase                         " Make search case insensitive
set incsearch                          " Allow incremental search
set laststatus=2                       " When must the status line be displayed
set lazyredraw                         " speed up the redraw behaviour
set list                               " Show the invisible characters
set magic                              " Enable regular expressions
set mouse=                             " Disable mouse
set nobackup                           " Disables the backup file
set noerrorbells                       " Remove error sound
set nomodeline                         " Disable modeline, security something
set nojoinspaces                       " Removes double space after punctuation
set splitbelow                         " Make new splits go to the bottom
set splitright                         " Make new splits go to the right
set nofoldenable                       " Switches off code folding
set noshowmode                         " Switch off the showing of the Mode
set noswapfile                         " Disables the swap file
set novisualbell                       " Remove error flash
set nowritebackup                      " Disable write backup
set number                             " Enables the line numbering
set number relativenumber              " turn relative line numbers on
set path+=**                           " search sub directories for files
set ruler                              " Enable the sizing at the bottom
set shiftwidth=2                       " Allows for backspace of 4 characters
set shiftround                         " Uses multiple of shiftwidth when indenting
set showcmd                            " show last used command
set showmatch                          " Highlight matching bracket
set smartcase                          " Allows case sensitive search if first letter is Uppercase
set smartindent                        " enable smart indenting
set smarttab                           " more tabbing
set so=5                               " Always have 5 lines around the cursor
set termencoding=utf-8                 " set the terminal encoding
set encoding=utf-8                     " set file encoding
set softtabstop=2                      " Tabbing in a line
set t_Co=256                           " Enable full colour support
set t_vb=                              " Disable beeping
set tabstop=2                          " Sets the tabstop to 4 characters
set timeoutlen=0                       " make esc behave instantly
set timeoutlen=1000 ttimeoutlen=0      " Make the exit of insert mode faster
set timeoutlen=500                     " Timeout length of key presses
set ttyfast                            " Sets rendering mode to be faster (slow on slow line)
set ttymouse=                          " Disable mouse
set whichwrap+=<,>,h,l                 " Set backspace behaviour"
set wildmenu                           " enable file menu for multi options
set wildmode=list:full                 " show list of autocomplete
set title

" Add options to ignore in lists
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Configuration and changes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle line number style
" Relative for normal mode, absolute for insert mode, or if not focused
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Specify the behavior when switching between buffers
" try
  " set switchbuf=useopen,usetab,newtab
  " set stal=2
" catch
" endtry

" autoreload .vimrc on file save
" autocmd! bufwritepost ~/.vimrc source ~/.vimrc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Keymapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcut to squash git commits
nnoremap <leader>s ciws<esc>

" Make level 1 heading
nnoremap <leader>1 yypVr=$

" Make level 2 heading
nnoremap <leader>2 yypVr-$

" Make level 3 heading
nnoremap <leader>3 yypVr~$

" Clear search term
nnoremap <leader><space> :noh<cr>

" Edit vimrc configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" Reload vimrc configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Make directions use screen and not lines
nnoremap <Up> gk
nnoremap <Down> gj
inoremap <Up> <C-O>gk
inoremap <Down> <C-O>gj

" Tab Controls
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<cr>
map <C-i> :tabnext<cr>

" Clear Whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Base64 things
vnoremap <leader>64d c<c-r>=system('base64 --decode', @")<cr><esc>
vnoremap <leader>64e c<c-r>=system('base64', @")<cr><esc>

" Make ctrl + direction switch between tabs/buffers
map <C-Up> <C-w>k
map <C-Left> :bp<cr>
map <C-Right> :bn<cr>
map <C-Down> <C-w>j
imap <C-Up> <C-O><C-w>k
imap <C-Left> <C-O>:bp<cr>
imap <C-Right> <C-O>:bn<cr>
imap <C-Down> <C-O><C-w>j

" Remap start of line to be first non-blank character
map 0 ^

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Force filetype
autocmd BufRead,BufNewFile *.md set filetype=markdown
au BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead .envrc set syntax=bash

" Enable spell check on file types (and name)
autocmd BufNewFile,BufRead README setlocal spell spelllang=en_gb
autocmd FileType md,rst,text setlocal spell spelllang=en_gb

" Set specific line lengths for filetypes
autocmd FileType py setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Make more python things coloured
autocmd BufRead,BufNewFile *.py let python_highlight_all=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plug Plugins installation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'dense-analysis/ale'
Plug 'dikiaap/minimalist'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-python/python-syntax'
Plug 'webdevel/tabulous'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'towolf/vim-helm'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-endwise'
Plug 'severin-lemaignan/vim-minimap'
Plug 'joshdick/onedark.vim'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme changes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:onedark_termcolors = 256
set termguicolors
try
  " colorscheme monokai
  " colorscheme minimalist
  colorscheme onedark
  catch
endtry

" Completely disable background colour
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
highlight ColorColumn ctermbg=235

" autocmd BufEnter * colorscheme default
" autocmd BufEnter *.php colorscheme Tomorrow-Night
" autocmd BufEnter *.py colorscheme Tomorrow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Minimap:

let g:minimap_highlight='Visual'

" NerdTree options:
let g:minimap_show='<leader>ms'
let g:minimap_update='<leader>mu'
let g:minimap_close='<leader>mc'
let g:minimap_toggle='<leader>mt'

" Open the tree
map <C-o> :NERDTree<CR>

" Make the tree open on launch
" autocmd VimEnter * NERDTree | wincmd p

" Invert the tree on ctrl + tab
" nnoremap <C-t> :NERDTreeToggle<CR>

" Make vim close if only the tree is open
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open quick switcher
map <C-p> :Files<CR>
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" ALE settings, trim whitespace on save, ignore mypy
let g:ale_linters_ignore = {
      \ 'python': ['mypy', 'flake8'],
      \}

let g:ale_echo_msg_error_str = 'ERR'
let g:ale_echo_msg_warning_str = 'WARN'
let g:ale_echo_msg_format = '[%linter%] %severity%: [%code%] %s'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spellcheck configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:merlin_spell_check_enabled = 0

function! ToggleSpellCheckMode()
  if s:merlin_spell_check_enabled
    setlocal nospell
    let s:merlin_spell_check_enabled = 0
  else
    setlocal spell spelllang=en_gb
    let s:merlin_spell_check_enabled = 1
  endif
endfunction

map <C-s> :call ToggleSpellCheckMode()<cr>
inoremap <C-s> <C-o>:call ToggleSpellCheckMode()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear all whitespace at the end of a line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.sh,*.md,*.ts,*.html,*.yaml,*.rst :call CleanExtraSpaces()
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a file based on file type
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! CompileRun()
exec "w"
if &filetype == 'c'
    exec "!gcc % -o %<"
    exec "!time ./%<"
elseif &filetype == 'cpp'
    exec "!g++ % -o %<"
    exec "!time ./%<"
elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %"
elseif &filetype == 'sh'
    exec "!time bash %"
elseif &filetype == 'python'
    exec "!time python3 %"
elseif &filetype == 'html'
    exec "!google-chrome % &"
elseif &filetype == 'go'
    exec "!go build %<"
    exec "!time go run %"
elseif &filetype == 'matlab'
    exec "!time octave %"
endif
endfunc

map <F5> :call CompileRun()<CR>
imap <F5> <Esc>:call CompileRun()<CR>
vmap <F5> <Esc>:call CompileRun()<CR>

