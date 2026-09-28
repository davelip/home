syntax on                 " syntax highlighing
filetype on               " try to detect filetypes
filetype plugin on        " enable loading indent file for filetype
filetype indent on        " enable loading indent file for filetype

" Plugin nativi: caricati automaticamente da ~/.vim/pack/plugins/start/
" (gestiti come submodule git nel repo home)

" Leader definito PRIMA di ogni mapping che lo usa
let mapleader = ","
let g:mapleader = ","

if filereadable(expand("~/.vimrc.local.before"))
    source ~/.vimrc.local.before
endif

" ===================================
" Configuration
" ===================================
"Adapted from https://gist.github.com/JeffreyWay/6753834
"And from https://github.com/stephpy/vim-config/blob/master/.vimrc

"set noswapfile
set autoindent                  " always set autoindenting on
set autowrite  "Save on buffer switch
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set clipboard=unnamedplus       " usa la clipboard di sistema (Wayland/X11)
set copyindent                  " copy the previous indentation on autoindenting
set cursorline
set encoding=utf-8
set expandtab                   " expand tabs by default (overloadable per file type later)
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldlevel=0   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=marker   " fold based on indent level
set hidden
set history=256                 " keep 50 lines of command line history
set hlsearch                    " highlight matches
set ignorecase                  " ignore case when searching
set incsearch                  " do incremental searching
set laststatus=2               " Always show the statusline
set lazyredraw          " redraw only when we need to.http://dougblack.io/words/a-good-vimrc.html
set linespace=15
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set nobackup                   " delete backup
set noerrorbells         " don't beep
set novisualbell               " turn off visual bell
set t_vb=
set nowrap                      " don't wrap lines
set number                      " always show line numbers
set ruler                      " show the cursor position all the time
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4                " number of spaces to use for autoindenting
set showcmd                     "Show (partial) command in the status line
set showmatch           " highlight matching [{()}] http://dougblack.io/words/a-good-vimrc.html
set showmode                    " always show what mode we're currently editing in
set smartcase                   " ignore case if search pattern is all lowercase,
set smarttab
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set t_Co=256
set tabstop=4                   " a tab is four spaces
set tags=tags
set tags+=vendor.tags
set timeout timeoutlen=200 ttimeoutlen=100
set title                      " show title in console title bar
set ttyfast                    " smoother changes
set wildmenu           " visual autocomplete for command menu http://dougblack.io/words/a-good-vimrc.html
set wildignore+=*/vendor/**
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize

if has('python3')
    " https://github.com/globaleaks/GlobaLeaks/wiki/code-style-guidelines-for-globaleaks-backend-development
    set foldmethod=indent
    set foldlevel=99
    set textwidth=79
endif

" colorscheme: badwolf se presente in ~/.vim/colors/, altrimenti fallback
try
    colorscheme badwolf
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme molokai
endtry

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" ===================================
" Autocommands
" ===================================

"delete spaces at end of line
autocmd BufWritePre !*.xml silent! %s/[\r \t]\+$//
" Auto-remove trailing spaces
autocmd BufWritePre *.php :%s/\s\+$//e
" retab to replace tab by space when you write
autocmd BufWritePre *.php :set et|retab

autocmd BufNewFile,BufRead *.twig set filetype=twig
autocmd BufNewFile,BufRead *.less set filetype=less
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

" 20210927 - filetypes as typescriptreact (nativo in vim 9)
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" ===================================
" Plugin configuration
" ===================================

" fzf.vim (erede di Command-T / CtrlP) - richiede fzf da apt
set rtp+=/usr/share/doc/fzf/examples
nnoremap <silent> <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
map <leader>f :Rg<Space>

" netrw disattivato: l'explorer è NERDTree
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

autocmd StdinReadPre * let s:std_in=1
" vim senza argomenti → NERDTree
autocmd VimEnter * if !argc() && !exists('s:std_in') | NERDTree | endif
" vim <directory> → NERDTree su quella directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in')
      \ | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

nmap <C-n> :NERDTreeToggle<cr>
" @see http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
map <leader>r :NERDTreeFind<cr>

" Easy motion stuff
let g:EasyMotion_leader_key = '<Leader>'

" ===================================
" Mapping
" ===================================

" http://dougblack.io/words/a-good-vimrc.html
" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Down is really the next line
nnoremap j gj
nnoremap k gk

"Easy escaping to normal model
imap jj <esc>

"Auto change directory to match current file ,cd
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

" http://vim.wikia.com/wiki/Automatic_word_wrapping
nmap <leader>w :set wrap linebreak nolist<cr>

"easier window navigation
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l

"Load the current buffer in the default browser
nmap ,c :!xdg-open %<cr>

" Create split below
nmap :sp :rightbelow sp<cr>

nmap <Space> <PageDown>

" mapping ctags shortcut to t
nmap <leader>tj :tjump<CR>
nmap <leader>tp :tprevious<CR>
nmap <leader>tn :tnext<CR>

" Because there is a bundle which deactive it ...
map <leader>e :set expandtab<CR>

" Open splits
nmap vs :vsplit<cr>
nmap sp :split<cr>

" Create/edit file in the current directory
nmap :ed :edit %:p:h/

" Edit todo list for project
nmap ,todo :e todo.txt<cr>

" Useful to toggle paste mode"
set pastetoggle=<leader>p

highlight Search cterm=underline

" TMUX {{{
" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}

" @http://dougblack.io/words/a-good-vimrc.html Function {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd FileType ruby setlocal tabstop=2
    autocmd FileType ruby setlocal shiftwidth=2
    autocmd FileType ruby setlocal softtabstop=2
    autocmd FileType ruby setlocal commentstring=#\ %s
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufEnter *.zsh-theme setlocal filetype=zsh
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
    autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2
augroup END

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" strips trailing whitespace at the end of files.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" }}}

if filereadable(expand("~/.vimrc.local.after"))
    source ~/.vimrc.local.after
endif
