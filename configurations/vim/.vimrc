syntax on                 " syntax highlighing
filetype on               " try to detect filetypes
filetype plugin on        " enable loading indent file for filetype
filetype indent on        " enable loading indent file for filetype

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

if filereadable(expand("~/.vimrc.local.before"))
    source ~/.vimrc.local.before
endif

if filereadable(expand("~/.vimrc.bundle"))
    source ~/.vimrc.bundle
else
    source ~/.vim/vimrc.bundle
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
set clipboard=unnamed
set copyindent                  " copy the previous indentation on autoindenting
set cursorline
set encoding=utf-8
set expandtab                   " expand tabs by default (overloadable per file type later)
set hidden
set history=256                 " keep 50 lines of command line history
set hlsearch
set ignorecase                  " ignore case when searching
set incsearch                  " do incremental searching
set laststatus=2               " Always show the statusline
set linespace=15
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set ls=2                       " Always show the statusline
set nobackup                   " delete backup
set nocompatible
set noerrorbells         " don't beep
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set novisualbell               " turn off visual bell
set nowrap                      " don't wrap lines
set number                      " always show line numbers
set ruler                      " show the cursor position all the time
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4                " number of spaces to use for autoindenting
set showcmd                     "Show (partial) command in the status line
set showmode                    " always show what mode we're currently editing in
set smartcase                   " ignore case if search pattern is all lowercase,
set smarttab
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set t_Co=256
set tabstop=4                   " a tab is four spaces
set tags=tags
set timeout timeoutlen=200 ttimeoutlen=100
set title                      " show title in console title bar
set ttyfast                    " smoother changes
set vb t_vb=".
set visualbell           " don't beep

"colorscheme vividchalk
colorscheme xoria256


" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" phpunit compilation
com! -nargs=* Phpunit make -c app <q-args> | cw

" ===================================
" Autocommands
" ===================================

"delete spaces at end of line
autocmd BufWritePre !*.xml silent! %s/[\r \t]\+$//
" Auto-remove trailing spaces
autocmd BufWritePre *.php :%s/\s\+$//e
" retab to replace tab by space when you write
autocmd BufWritePre *.php :set et|retab
" autocmd BufWritePre *.php :retab

autocmd BufNewFile,BufRead *.twig set filetype=twig
autocmd BufNewFile,BufRead *.less set filetype=less
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
 

" ===================================
" Bundles configuration
" ===================================

let g:miniBufExplorerAutoStart = 1
let g:miniBufExplorerHideWhenDiff = 1

let g:pdv_cfg_php4always=0 "using php5 doc tags

if has('ruby')
    nnoremap <silent> <C-P> :CommandT<CR>

    let g:CommandTMaxFiles=20000
    let g:CommandTAlwaysShowDotFiles=1
else
    let g:ctrlp_match_window_reversed=0
    let g:ctrlp_working_path_mode = 0

    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$\|cache$\|log$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.jpg$\|\.gif$\|\.png$',
                \ }
endif

let g:symfony_enable_shell_mapping = 1

set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize

" you can override it if you want a fileexplorer
" by default when opening vim on dir
if !exists("g:file_exporer_at_startup")
    let g:NERDTreeHijackNetrw=0

    " use 'vim' in your directory and it'll open a nerdtree automatically
    autocmd vimenter * if !argc() || argv() == ['.'] | NERDTree | endif

    " Disable netrw's autocmd, since we're ALWAYS using NERDTree
    runtime plugin/netRwPlugin.vim
    augroup FileExplorer
      au!
    augroup END
endif

let g:snipMate = {}
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['php'] = 'php,symfony2'

function MyTagContext()
    if filereadable(expand('%:p:h') . '/tags')
    return "\<c-x>\<c-]>"
    endif
    " no return will result in the evaluation of the next
    " configured context
endfunction
let g:SuperTabCompletionContexts =
    \ ['MyTagContext', 's:ContextText', 's:ContextDiscover']


" ===================================
" Mapping
" ===================================

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Down is really the next line
nnoremap j gj
nnoremap k gk

"Easy escaping to normal model
imap jj <esc>

"Auto change directory to match current file ,cd
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>

"Auto change directory to match current file ,cd
nnoremap ,cd :cd %:p:h<CR>:pwd<CR>
 
"easier window navigation
 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
 
"Resize vsplit
nmap <C-v> :vertical resize +5<cr>
nmap 25 :vertical resize 40<cr>
nmap 50 <c-w>=
nmap 75 :vertical resize 120<cr>
 
nmap <C-n> :NERDTreeToggle<cr>

"Load the current buffer in Chrome
nmap ,c :!open -a Google\ Chrome<cr>
 
" Create split below
nmap :sp :rightbelow sp<cr>
 
" Quickly go forward or backward to buffer
nmap :bp :BufSurfBack<cr>
nmap :bn :BufSurfForward<cr>
 
" Laravel framework commons
nmap <leader>lr :e app/routes.php<cr>
nmap <leader>lca :e app/config/app.php<cr>81Gf(%O
nmap <leader>lcd :e app/config/database.php<cr>
nmap <leader>lc :e composer.json<cr>

imap <buffer> <leader>ns <C-O>:call PhpInsertUse()<CR>
map <buffer> <leader>ns :call PhpInsertUse()<CR>

nmap <Space> <PageDown>

nmap <leader>sl :SessionList<CR>
nmap <leader>ss :SessionSave<CR>

map <leader>i :TlistToggle<CR>
map <leader>f :Ack
map <leader>te :Phpunit %<CR>

" This will align params by using align vim bundle
nmap <leader>d :call PhpDocSingle()<CR><ESC>jv/\/<CR>kkk<leader>tsp<CR>
vnoremap <leader>d :call PhpDocRange()<CR>

" mapping ctags shortcut to t
nmap <leader>tj :tjump<CR>
nmap <leader>tp :tprevious<CR>
nmap <leader>tn :tnext<CR>
nnoremap <leader><space> :noh<cr>
"map <C-l> <C-]> " If you use mac, uncomment it.

imap <leader>ns <C-O>:call PhpInsertUse()<CR>
map <leader>ns :call PhpInsertUse()<CR>

imap <leader>ne <C-O>:call PhpExpandClass()<CR>
map <leader>ne :call PhpExpandClass()<CR>

nmap <leader>gst :Gstatus<CR>
nmap <leader>gco :Gread<CR>
nmap <leader>gbl :Gblame<CR>
nmap <leader>gbr :Gbrowse<CR>

" Because there is a bundle which deactive it ...
map <leader>e :set expandtab<CR>
" If you don't want to have validation
map <leader>s :SyntasticToggleMode<CR>

" CtrlP Stuff
 
" Familiar commands for file/symbol browsing
map <D-p> :CtrlP<cr>
map <D-r> :CtrlPBufTag<cr>
 
" I don't want to pull up these folders/files when calling CtrlP
set wildignore+=*/vendor/**
set wildignore+=*/public/forum/**
 
" Open splits
nmap vs :vsplit<cr>
nmap sp :split<cr>
 
" Create/edit file in the current directory
nmap :ed :edit %:p:h/
 
" Edit todo list for project
nmap ,todo :e todo.txt<cr>

" Useful to toggle paste mode"
set pastetoggle=<leader>p

set tags+=vendor.tags

if filereadable(expand("~/.vimrc.local.after"))
    source ~/.vimrc.local.after
endif

highlight Search cterm=underline
 

" Easy motion stuff
let g:EasyMotion_leader_key = '<Leader>'
 
" Powerline (Fancy thingy at bottom stuff)
let g:Powerline_symbols = 'fancy'
 
"""""""""""""""""
" Abbreviations "
"""""""""""""""""

abbrev pft PHPUnit_Framework_TestCase
 
abbrev gm !php artisan generate:model
abbrev gc !php artisan generate:controller
abbrev gmig !php artisan generate:migration
 
 
""""""""
" CALL "
""""""""

" Concept - load underlying class for Laravel
function! FacadeLookup()
    let facade = input('Facade Name: ')
    let classes = {
\       'Form': 'Html/FormBuilder.php',
\       'Html': 'Html/HtmlBuilder.php',
\       'File': 'Filesystem/Filesystem.php',
\       'Eloquent': 'Database/Eloquent/Model.php'
\   }
 
    execute ":edit vendor/laravel/framework/src/Illuminate/" . classes[facade]
endfunction
nmap ,lf :call FacadeLookup()<cr>
 
" Prepare a new PHP class
function! Class()
    let name = input('Class name? ')
    let namespace = input('Any Namespace? ')
 
    if strlen(namespace)
        exec 'normal i<?php namespace ' . namespace . ';
    else
        exec 'normal i<?php
    endif
 
    " Open class
    exec 'normal iclass ' . name . ' {^M}^[O^['
    
    exec 'normal i^M    public function __construct()^M{^M ^M}^['
endfunction
nmap ,1  :call Class()<cr>
