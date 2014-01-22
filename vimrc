"====[ Indent and tab options ]======
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set incsearch

set encoding=utf-8

set ruler
filetype plugin indent on
syntax on
set number
let mapleader=","

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======

    exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
        set list


"====[ Swap : and ; to make colon commands easier to type ]======

"    nnoremap  ;  :
"    nnoremap  :  ;

"====[ Highlight just the 81st column of wide lines...
"highlight ColourColumn ctermbg=magneta
"call matchadd('ColourColumn', '\%81v', 100)

"====[ vim-latexsuite plugin ]=====
filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
