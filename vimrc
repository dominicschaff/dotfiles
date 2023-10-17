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
set timeoutlen=0               " make esc behave instantly
set colorcolumn=80,100,120
" Enable folding
nnoremap <space> za

" turn hybrid line numbers on
:set number relativenumber
:set nu rnu

" File browser Settings
let g:netrw_banner=0                   " Disable banner
let g:netrw_altv=1                     " open splits to the right
let g:netrw_liststyle=3                " tree view

set pastetoggle=<F2>

" Setup some keymaps

" Shortcut to squash git commits

nnoremap <leader>s ciws<esc>

" Make level 1 heading
nnoremap <leader>1 yypVr=$

" Make level 2 heading
nnoremap <leader>2 yypVr-$

" Make level 3 heading
nnoremap <leader>3 yypVr^$

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

" Base64 things
vnoremap <leader>64d c<c-r>=system('base64 --decode', @")<cr><esc>
vnoremap <leader>64e c<c-r>=system('base64', @")<cr><esc>

" Specify the file type
autocmd BufRead,BufNewFile *.md set filetype=markdown
au BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead .envrc set syntax=bash
autocmd BufNewFile,BufRead *.rst set spell spelllang=en_gb
autocmd BufNewFile,BufRead *.md set spell spelllang=en_gb
autocmd BufNewFile,BufRead README set spell spelllang=en_gb

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
"Plug 'tomasr/molokai'
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
call plug#end()


set foldmethod=indent
set foldlevel=99

set t_Co=256
let python_highlight_all=1
syntax on
colorscheme minimalist
"colorscheme molokai

" NerdTree options:
map <C-o> :NERDTree<CR>
" autocmd VimEnter * NERDTree | wincmd p
nnoremap <C-t> :NERDTreeToggle<CR>
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif


map <C-p> :Files<CR>
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

let g:ale_fixers = {'*': ['trim_whitespace']}
let g:ale_fix_on_save = 1
let g:ale_linters_ignore = {
      \ 'python': ['mypy'],
      \}

let g:SimpylFold_docstring_preview=1

autocmd FileType py setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
let g:indentLine_char = '⦙'
"set mouse=
"set ttymouse=


" Tab Controls:
map <leader>tn :tabnew<cr>
map <leader>t<leader> :tabnext<cr>
map <leader>tc :tabclose<cr>
map <C-i> :tabnext<cr>
