" Colors
    syntax enable   " enable syntax processing
    "set background=dark " for [dark|light] bg if using solarized
    colorscheme zenburn

" Spaces and Tabs
    set autoindent  "
    set smartindent "
    set tabstop=4   " number of visual spaces per TAB
    set shiftwidth=4    " number of spaces in TAB when editing
    set expandtab   " tabs are spaces

" UI Config
    set ruler   " show cursor coordinates in bottom right corner
    set number  " show line numbers
    set showcmd " show command in bottom bar
    set wildmenu    " visual autocomplete for command menu
    set showmatch   " highlight matching [{()}]

" Searching
    set incsearch   " search as characters are entered
    set hlsearch    " highlight matches
    " turn off search highlight
      nnoremap <leader><space> :nohlsearch<CR>

" Folding
    set foldenable  " enable folding
    set foldlevelstart=10   " open most folds by default
    set foldnestmax=10   " 10 nested fold max
    " space open/closes folds
      nnoremap <space> za
    set foldmethod=indent   " fold based on indent level

" Leader
    let mapleader=","   " leader is comma
    " swap : and ; to make colon commands easier to type
    nnoremap  ;  :
    "nnoremap  :  ;

" Misc
    set encoding=utf-8  " set encoding to utf-8
    " highlight last inserted text
      nnoremap gV `[v`]
    filetype plugin indent on

    " Make tabs, trailing whitespace, and non-breaking spaces visible
      exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
      set list

" vim-latexsuite plugin
    set grepprg=grep\ -nH\ $*
    let g:tex_flavor = "latex"
