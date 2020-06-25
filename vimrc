syntax enable
syntax on                              " Enable the syntax highlighting
filetype plugin indent on              " Allow indenting, and file type detection

let mapleader=","                      " Change the leader character to a ,

"set modelines=0                       " I cannot remember
set nocompatible                       " Disable the vi backwards compatibility
set number                             " Enables the line numbering
set tabstop=2                          " Sets the tabstop to 4 characters
set shiftwidth=2                       " Allows for backspace of 4 characters
set softtabstop=2                      " Tabbing in a line
set expandtab                          " Change tab to space
set smarttab                           " more tabbing
set autoindent                         " enable auto indenting
set cindent                            " enable indeting in a c-style
"set mouse=a                            " Allow mouse support
set encoding=utf-8                     " Set the filetype encoding to utf-8
set noshowmode                         " Switch off the showing of the Mode
set ignorecase                         " Make search case insensitive
set hidden                             " Allows switching of buffers without saving
set ttyfast                            " Sets rendering mode to be faster (slow on slow line)
set backspace=indent,eol,start         " What we backspace over?
set cursorline                         " Highlights the current line
"set title                              " Changes the terminal title
set smartcase                          " Allows case sensitive search if first letter is Uppercase
set incsearch                          " Searches while typing
set hlsearch                           " Cannot remember
set noswapfile                         " Disables the swap file
set nobackup                           " Disables the backup file
set nofoldenable                       " Switches off code folding
"set relativenumber                     " Enables relative numbering for ease of copy
set gdefault                           " Enables find/replace for all by default
set ff=unix                            " Default line endings
set fileformats=unix,dos               " File formats allowed
"set backupdir=~/.vim/backup//          " Where must the backups be
"set directory=~/.vim/swap//            " Where must the swap directory be
"set undodir=~/.vim/undo//              " Where must the undo directory be
set guifont="Hack:12"                   " What font should we try use
set laststatus=2                        " When must the status line be displayed
set list                               " Show the invisible characters
set listchars=tab:→→,trail:°           " What should the invisibles be shown as
"set listchars=tab:→→,eol:¬,trail:°     " What should the invisibles be shown as
set ruler                              " Enable the sizing at the bottom
colorscheme molokai                    " What should the colorscheme be
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

nnoremap <leader>top :-1read $HOME/.vim/snippets/top.py<CR>

" Switch the paste toggle
set pastetoggle=<F4>

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

" Allow both ways of quiting
nnoremap ; :

" Clear Whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Specify the file type
autocmd BufRead,BufNewFile *.md set filetype=md
au BufNewFile,BufRead *.json set filetype=json

set background=dark
hi User1 ctermfg=Black ctermbg=DarkGray
hi User2 ctermfg=Cyan ctermbg=Black
hi User3 ctermfg=Red ctermbg=Black
hi User4 ctermfg=Blue ctermbg=Black
hi User5 ctermfg=Green ctermbg=Black
hi User6 ctermfg=White ctermbg=Black

function! SetColour()
    if &modified == 1
        hi User1 ctermfg=Black ctermbg=Red
    else
        hi User1 ctermfg=White ctermbg=DarkGray
    endif
endfunction

" Write out the mode
function! GetMode()
    if mode() == "i"
        return "❰INSERT❱"
    endif
    if mode() == "n"
        return "❰NORMAL❱"
    endif
    if mode() == "R"
        return "❰REPLACE❱"
    endif
    if mode() == "v"
        return "❰VISUAL❱"
    endif
    if mode() == "V"
        return "❰V-LINE❱"
    endif
    if mode() == ""
        return "❰V-BLCK❱"
    endif

    return mode()
endfunction

" Change status line colours
set statusline=%1*%{GetMode()}%*\ %-(%m%t%)%=%2*%y%*\ %3*%c,%l%*\ %p%%  " What should the status line be

" Colour Events
au InsertEnter  * hi User1 ctermfg=Black ctermbg=Green
au InsertLeave  * call SetColour()
au BufWritePost  * call SetColour()

autocmd BufWritePre *.scala :%s/\s\+$//e
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal softtabstop=4

" Make the exit of insert mode faster
set timeoutlen=1000 ttimeoutlen=0


set completeopt=menuone,longest
set magic
set autoread
let g:python_highlight_all = 1
