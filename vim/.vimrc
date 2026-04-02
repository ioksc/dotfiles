" ============================================================================
" VIM CONFIGURATION - OPTIMIZED VERSION
" ============================================================================

" --- Prevenir carga múltiple ---
if exists('g:vimrc_loaded')
    finish
endif
let g:vimrc_loaded = 1

" ============================================================================
" SECTION 1: CORE SETTINGS
" ============================================================================
set nocompatible
set encoding=utf-8
set hidden
set autoread
set secure
set modelines=0
if has('patch-8.1.1365')
    set modelineexpr
endif
set belloff=all

" ============================================================================
" SECTION 2: PLUGIN MANAGEMENT (vim-plug)
" ============================================================================
call plug#begin('~/.vim/plugged')

" Syntax & Language Support
Plug 'sheerun/vim-polyglot'
Plug 'wuelnerdotexe/vim-astro'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

" Linting & Formatting
Plug 'dense-analysis/ale'

" Git Integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" File Navigation
Plug 'preservim/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'tpope/vim-vinegar'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" UI & Appearance
Plug 'vim-airline/vim-airline'
Plug 'ioksc/vim-osaka-solarized-theme'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'sass', 'less', 'html', 'javascript', 'typescript', 'vue', 'astro']}

" Productivity
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }
Plug 'kshenoy/vim-signature'
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server', 'on': 'Bracey'}

call plug#end()

" ============================================================================
" SECTION 3: APPEARANCE AND UI
" ============================================================================
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
set t_Co=256

syntax enable
set background=dark
colorscheme osaka_solarized

set number
set relativenumber
set numberwidth=4
set cursorline
set signcolumn=yes
set laststatus=2
set noshowmode
set cmdheight=2
set title
set showmatch
set matchtime=2
set shortmess+=IcFs
set scrolloff=5
set sidescrolloff=5

" ============================================================================
" SECTION 4: EDITING AND FORMATTING
" ============================================================================
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set smarttab
set textwidth=0
set wrap
set linebreak
set backspace=indent,eol,start
set magic
set formatoptions-=t
set formatoptions+=croqnlj

" ============================================================================
" SECTION 5: SEARCH AND REPLACE
" ============================================================================
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

" ============================================================================
" SECTION 6: FILE MANAGEMENT
" ============================================================================
let s:vim_dirs = {
    \ 'swap': expand('~/.vim/swap'),
    \ 'backup': expand('~/.vim/backup'),
    \ 'undodir': expand('~/.vim/undodir')
    \ }

for [s:name, s:path] in items(s:vim_dirs)
    if !isdirectory(s:path)
        call mkdir(s:path, 'p', 0700)
    endif
endfor
unlet s:vim_dirs s:name s:path

set swapfile
set directory=~/.vim/swap//
set backup
set backupdir=~/.vim/backup//
set undofile
set undodir=~/.vim/undodir//
set undolevels=1000
set undoreload=10000

" Wildmenu settings
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.pyc,*.pyo,__pycache__,*.so,*.swp,*.zip
set wildignore+=*.git,*.hg,*.svn,node_modules,*.egg-info

" ============================================================================
" SECTION 7: PERFORMANCE
" ============================================================================
set lazyredraw
set updatetime=100
set timeoutlen=500
set ttimeoutlen=10
set synmaxcol=300

augroup large_file_optimization
    autocmd!
    autocmd BufReadPost * if line2byte(line("$") + 1) > 1000000 |
        \ setlocal syntax=OFF nocursorline norelativenumber eventignore+=FileType |
        \ endif
augroup END

" ============================================================================
" SECTION 8: SPLITS AND WINDOWS
" ============================================================================
set splitbelow
set splitright
set equalalways

" ============================================================================
" SECTION 9: PLUGIN CONFIGURATIONS
" ============================================================================

" --- ALE ---
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_python_auto_virtualenv = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_linters = {
    \ 'go': ['golangci-lint', 'gopls'],
    \ 'python': ['ruff'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint', 'tsserver']
    \ }

let g:ale_fixers = {
    \ 'python': ['ruff', 'ruff_format'],
    \ 'go': ['gofmt', 'goimports'],
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ 'json': ['prettier'],
    \ 'html': ['prettier'],
    \ 'css': ['prettier']
    \ }

" --- vim-go ---
let g:go_fmt_command = 'goimports'
let g:go_metalinter_autosave = 0
let g:go_list_type = 'quickfix'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_type_info = 1

" --- NERDTree ---
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.git$', 'node_modules']
let g:NERDTreeQuitOnOpen = 1

" --- FZF ---
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" --- Airline ---
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 0

" --- GitGutter ---
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" --- Codeium ---
let g:codeium_disable_bindings = 0
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
imap <C-;> <Cmd>call codeium#CycleCompletions(1)<CR>
imap <C-,> <Cmd>call codeium#CycleCompletions(-1)<CR>
imap <C-x> <Cmd>call codeium#Clear()<CR>

" ============================================================================
" SECTION 10: PYTHON & VIRTUALENV
" ============================================================================
" 1. Intentar detectar el entorno de uv (.venv) en el directorio actual
let s:venv_path = getcwd() . '/.venv/bin/python'

if executable(s:venv_path)
    " Si existe .venv, usamos ese Python para todo
    let g:python3_host_prog = s:venv_path
    let g:ale_python_executable = s:venv_path
    " Esto obliga a ALE a buscar ruff/flake8 dentro del .venv
    let g:ale_python_auto_virtualenv = 1
else
    " Si no hay .venv, usamos el Python de Arch (del sistema)
    " Nota: En Arch, esto suele ser /usr/bin/python
    let g:python3_host_prog = '/usr/bin/python'
    let g:ale_python_executable = '/usr/bin/python'
endif
" 2. Configuración específica para los linters de ALE
" Esto asegura que ALE use el ejecutable del entorno virtual para Ruff
let g:ale_python_ruff_executable = 'uv'
let g:ale_python_ruff_use_global = 0
let g:ale_python_ruff_options = 'run ruff'
let g:ale_python_ruff_format_options = 'run ruff'
" Ejecutar el archivo actual con uv en un terminal (Vim estándar)
nnoremap <leader>k :!uv run python3 %<CR>
" ============================================================================
" SECTION 11: KEY MAPPINGS
" ============================================================================
let mapleader = ' '
let maplocalleader = ','

" File operations
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

" Search
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>/ :set hlsearch!<CR>

" Buffer management
nnoremap <leader>bd :bd<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bl :buffers<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Better indenting
vnoremap < <gv
vnoremap > >gv

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Plugin shortcuts
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>

" Git shortcuts
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git log<CR>
nnoremap <leader>gd :Gdiff<CR>

" ALE shortcuts
nmap <silent> <leader>aj :ALENext<CR>
nmap <silent> <leader>ak :ALEPrevious<CR>
nmap <silent> <leader>af :ALEFix<CR>
nmap <silent> <leader>ad :ALEDetail<CR>

" Quick edits
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Template shortcuts
nnoremap <localleader>py :execute 'read ' . expand('~/.vim/templates/skeleton.py')<CR>
nnoremap <localleader>go :execute 'read ' . expand('~/.vim/templates/skeleton.go')<CR>
nnoremap <localleader>js :execute 'read ' . expand('~/.vim/templates/skeleton.js')<CR>
nnoremap <localleader>html :execute 'read ' . expand('~/.vim/templates/skeleton.html')<CR>

" Utility shortcuts
nnoremap <leader>cr :ClearRegisters<CR>
nnoremap <leader>ss :setlocal spell!<CR>
nnoremap <leader>W :%s/\s\+$//e<CR>

" ============================================================================
" SECTION 12: CUSTOM COMMANDS
" ============================================================================
command! ClearRegisters call ClearAllRegisters()
command! Reload source $MYVIMRC
command! -nargs=1 TemplateNew call CreateFromTemplate(<f-args>)
command! MakeTags !ctags -R .
command! TrimWhitespace :%s/\s\+$//e

" ============================================================================
" SECTION 13: AUTOCOMMANDS
" ============================================================================

" Templates
augroup templates_system
    autocmd!
    autocmd BufNewFile *.go silent! execute '0read ' . expand('~/.vim/templates/skeleton.go') | 7
    autocmd BufNewFile *.py silent! execute '0read ' . expand('~/.vim/templates/skeleton.py') | $
    autocmd BufNewFile *.js silent! execute '0read ' . expand('~/.vim/templates/skeleton.js') | $
    autocmd BufNewFile *.html silent! execute '0read ' . expand('~/.vim/templates/skeleton.html') | $
augroup END

" File monitoring
augroup file_monitoring
    autocmd!
    autocmd FocusGained,BufEnter * if mode() ==# 'n' && getcmdwintype() == '' | checktime | endif
augroup END

" Auto-save
augroup auto_save
    autocmd!
    autocmd FocusLost,WinLeave * if &modified && !&readonly && expand('%') != '' && &buftype == '' | silent! update | endif
augroup END

" Restore cursor position
augroup restore_cursor
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END

" Highlight on yank
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=200}
augroup END

" File type specific settings
augroup filetype_settings
    autocmd!
    autocmd FileType python setlocal colorcolumn=88
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4
    autocmd FileType javascript,typescript,json,html,css,vue setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType yaml,yml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal wrap linebreak spell spelllang=es,en
    autocmd FileType gitcommit setlocal spell spelllang=es,en
augroup END

" ============================================================================
" SECTION 14: FUNCTIONS
" ============================================================================

" Clear all registers
function! ClearAllRegisters()
    let l:regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"='
    for l:r in split(l:regs, '\zs')
        call setreg(l:r, [])
    endfor
    redraw!
    echo "Registros limpiados."
endfunction

" Create file from template
function! CreateFromTemplate(template_name)
    let l:template_path = expand('~/.vim/templates/skeleton.' . a:template_name)
    if filereadable(l:template_path)
        execute 'read ' . l:template_path
    else
        echohl ErrorMsg
        echo "Template no encontrado: " . l:template_path
        echohl None
    endif
endfunction

" Toggle relative number
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction

command! ToggleRelNumber call ToggleRelativeNumber()
nnoremap <leader>rn :ToggleRelNumber<CR>

" ============================================================================
" SECTION 15: STATUS LINE (fallback si airline falla)
" ============================================================================
if !exists('g:loaded_airline')
    set statusline=%f\ %m%r%h%w
    set statusline+=%=
    set statusline+=%y\
    set statusline+=%{&fileencoding?&fileencoding:&encoding}
    set statusline+=\ [%{&fileformat}]
    set statusline+=\ %p%%
    set statusline+=\ %l:%c
endif

" ============================================================================
" END OF CONFIGURATION
" ============================================================================
