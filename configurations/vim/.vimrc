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
set showmatch           " highlight matching [{()}] http://dougblack.io/words/a-good-vimrc.html
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
set wildmenu           " visual autocomplete for command menu http://dougblack.io/words/a-good-vimrc.html

if has('python')
    " https://github.com/globaleaks/GlobaLeaks/wiki/code-style-guidelines-for-globaleaks-backend-development
    set foldmethod=indent
    set foldlevel=99
    set textwidth=79
endif

"colorscheme vividchalk
"colorscheme xoria256
colorscheme badwolf


" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

"" TBRemoved
""" phpunit compilation
""com! -nargs=* Phpunit make -c app <q-args> | cw

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
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapCTabSwitchWindows = 1

let g:pdv_cfg_php4always=0 "using php5 doc tags

if has('ruby')
    nnoremap <silent> <C-P> :CommandT<CR>

    let g:CommandTMaxFiles=20000
    let g:CommandTAlwaysShowDotFiles=1
else
    let g:ctrlp_match_window_reversed=0
    let g:ctrlp_working_path_mode = 0

    let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$\|cache$\|log$\|test\|node_modules\|vendor$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.jpg$\|\.gif$\|\.png\|.xls$',
                \ }
endif

"" TBRemoved
""let g:symfony_enable_shell_mapping = 1

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

let g:snipMate = { 'snippet_version' : 1 }
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

" http://dougblack.io/words/a-good-vimrc.html
" turn off search highlight 
nnoremap <leader><space> :nohlsearch<CR>
" space open/closes folds
nnoremap <space> za
" /http://dougblack.io/words/a-good-vimrc.html

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
 
" http://vim.wikia.com/wiki/Automatic_word_wrapping
nmap <leader>w :set wrap linebreak nolist<cr>

"easier window navigation
 
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
 
"Resize vsplit
"nmap <C-v> :vertical resize +5<cr>
"nmap 25 :vertical resize 40<cr>
"nmap 50 <c-w>=
"nmap 75 :vertical resize 120<cr>
 
nmap <C-n> :NERDTreeToggle<cr>

" @see http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
map <leader>r :NERDTreeFind<cr>

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

" CTRLP {{{
" CtrlP Stuff
 
" Familiar commands for file/symbol browsing
map <D-p> :CtrlP<cr>
map <D-r> :CtrlPBufTag<cr>
 
" I don't want to pull up these folders/files when calling CtrlP
set wildignore+=*/vendor/**
 
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

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
" Only if ag is installed
"let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" Easy motion stuff
let g:EasyMotion_leader_key = '<Leader>'

" Powerline (Fancy thingy at bottom stuff)
let g:Powerline_symbols = 'fancy'

" }}}


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

""""""""
" CALL "
""""""""

" Laravel {{{
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

" }}}


" @http://dougblack.io/words/a-good-vimrc.html Function {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    "autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
    "            \:call <SID>StripTrailingWhitespaces()
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

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
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
