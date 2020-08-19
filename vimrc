let mapleader=","                      " Change the leader character to a ,

set number                             " Enables the line numbering
set tabstop=2                          " Sets the tabstop to 4 characters
set shiftwidth=2                       " Allows for backspace of 4 characters
set softtabstop=2                      " Tabbing in a line
set expandtab                          " Change tab to space
set smarttab                           " more tabbing
set autoindent                         " enable auto indenting
set cindent                            " enable indeting in a c-style
set encoding=utf-8                     " Set the filetype encoding to utf-8
set noshowmode                         " Switch off the showing of the Mode
set ignorecase                         " Make search case insensitive
set hidden                             " Allows switching of buffers without saving
set ttyfast                            " Sets rendering mode to be faster (slow on slow line)
set cursorline                         " Highlights the current line
set smartcase                          " Allows case sensitive search if first letter is Uppercase
set hlsearch                           " Cannot remember
set noswapfile                         " Disables the swap file
set nobackup                           " Disables the backup file
set nofoldenable                       " Switches off code folding
set gdefault                           " Enables find/replace for all by default
set ff=unix                            " Default line endings
set fileformats=unix,dos               " File formats allowed
set laststatus=2                        " When must the status line be displayed
set list                               " Show the invisible characters
set ruler                              " Enable the sizing at the bottom
set showcmd                            " show last used command
set lazyredraw                         " speed up the redraw behaviour
set showmatch                          " Highlight matching bracket
set path+=**                           " search sub directories for files
set wildmenu                           " enable file menu for multi options

" File browser Settings
let g:netrw_banner=0                   " Disable banner
let g:netrw_altv=1                     " open splits to the right
let g:netrw_liststyle=3                " tree view

" Setup some keymaps

" Make level 1 heading
nnoremap <leader>1 yypVr=

" Make level 2 heading
nnoremap <leader>2 yypVr-

" Clear search term
nnoremap <leader><space> :noh<cr>

" Make directions use screen and not lines
nnoremap <Up> gk
nnoremap <Down> gj

" Remap the quit
nnoremap qq :q<cr>
nnoremap qa :qa<cr>

" Clear Whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Specify the file type
autocmd BufRead,BufNewFile *.md set filetype=md
au BufNewFile,BufRead *.json set filetype=json

autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal softtabstop=4

" Make the exit of insert mode faster
set timeoutlen=1000 ttimeoutlen=0


set completeopt=menuone,longest
set magic
set autoread

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
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'tomasr/molokai'
Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'
Plug 'mileszs/ack.vim'
Plug 'dense-analysis/ale'
call plug#end()


map <C-p> :Files<CR>
map <C-o> :NERDTreeToggle<CR>
colorscheme molokai
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fix_on_save = 1

set mouse=
set ttymouse=
