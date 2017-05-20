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

" Splits
    " Navigation using Ctrl+j, etc
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>

    " Open new panes to the right and bottom
    set splitbelow
    set splitright

" Statusline
    set laststatus=2    "always show status bar

    function! GitBranch()
      return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
    endfunction

    function! StatuslineGit()
      let l:branchname = GitBranch()
      return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
    endfunction

    set statusline=
    set statusline+=%#PmenuSel#
    set statusline+=%{StatuslineGit()}
    set statusline+=%#LineNr#
    set statusline+=\ %f
    set statusline+=%m\
    set statusline+=%=
    set statusline+=%#CursorColumn#
    set statusline+=\ %y
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\[%{&fileformat}\]
    set statusline+=\ %p%%
    set statusline+=\ %l:%c
    set statusline+=\ 

" Leader
    let mapleader=","   " leader is comma
    " swap : and ; to make colon commands easier to type
    nnoremap  ;  :
    "nnoremap  :  ;

" Searching
    set incsearch   " search as characters are entered
    set hlsearch    " highlight matches
    " turn off search highlight
      nnoremap <leader><space> :nohlsearch<CR>
    "let g:ackprg = 'ag --nogroup --nocolor --column'
    let g:ackprg = 'ag --vimgrep'

" Folding
    set foldenable  " enable folding
    set foldlevelstart=10   " open most folds by default
    set foldnestmax=10   " 10 nested fold max
    " space open/closes folds
      nnoremap <space> za
    set foldmethod=indent   " fold based on indent level

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

" Vimux plugin
    " Prompt for a command to run map
    map <Leader>vp :VimuxPromptCommand<CR>
    map <Leader>vm :VimuxPromptCommand("make ")<CR>
    " Inspect runner pane map
    map <Leader>vi :VimuxInspectRunner<CR>
    " Interrupt any command running in the runner pane map
    map <Leader>vs :VimuxInterruptRunner<CR>
    " Run last command
    map <Leader>vl :VimuxRunLastCommand<CR>
    " Close vim tmux runner opened by VimuxRunCommand
    map <Leader>vq :VimuxCloseRunner<CR>

    let VimuxUseNearest = 1
