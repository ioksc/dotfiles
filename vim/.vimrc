" ============================================================================
" VIM CONFIGURATION FILE
" ============================================================================

" ============================================================================
" SECTION 1: BASIC SETTINGS
" ============================================================================
set nocompatible                " Use Vim improvements over Vi
set encoding=utf-8              " UTF-8 encoding by default
set noshowmode                  " Don't show mode in command line
set lazyredraw                  " Reduce unnecessary redraws
set updatetime=100              " Faster updates for better experience
set ttyfast                     " Better performance on modern terminals
set regexpengine=0              " Use faster regex engine
set synmaxcol=300               " Increase syntax highlighting limit for long lines
set hidden                      " Allow changing buffers without saving
set clipboard^=unnamed,unnamedplus " Better clipboard integration
set title                       " Show filename in window title
set autoread                    " Reload files modified externally
set secure                      " Secure mode for modelines
set modelines=0                 " Disable modelines
set nomodeline                  " Disable modeline processing
set nospell                     " Disable spell checking by default
set cmdheight=2                 " Command line height for error messages

" ============================================================================
" SECTION 2: DIRECTORY AND FILE MANAGEMENT
" ============================================================================
set swapfile                    " Enable swap files for crash recovery
set directory=~/.vim/swap//     " Directory for .swp files (// uses full names)
set backup                      " Enable permanent backups
set backupdir=~/.vim/backup//   " Directory for backup files
set writebackup                 " Create temporary backup during saving
set undofile                    " Enable persistent undo history
set undodir=~/.vim/undodir      " Directory for undo files

" Create directories if they don't exist
for s:dir in ['.vim/swap', '.vim/backup', '.vim/undodir']
    if !isdirectory($HOME.'/'.s:dir)
        call mkdir($HOME.'/'.s:dir, 'p', 0700)
    endif
endfor
unlet s:dir

" ============================================================================
" SECTION 3: INTERFACE AND DISPLAY
" ============================================================================
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set cursorline                  " Highlight current line
set signcolumn=yes              " Always show sign column
set scrolloff=8                 " Keep 8 lines visible when scrolling
set sidescrolloff=8             " Horizontal margin when scrolling
set showmatch                   " Highlight matching brackets
set matchtime=1                 " Faster bracket matching highlight
set shortmess+=IcF              " Reduce startup messages
set list                        " Show special characters
set listchars=space:·,tab:▸-,trail:•,extends:→,precedes:←,nbsp:␣

" ============================================================================
" SECTION 4: EDITING AND FORMATTING
" ============================================================================
set expandtab                   " Convert tabs to spaces
set tabstop=4                   " Tab width
set softtabstop=4               " Virtual tab width
set shiftwidth=4                " Indentation width
set autoindent                  " Automatic indentation
set smartindent                 " Smart indentation
set formatoptions+=j            " Smart comment joining
set backspace=indent,eol,start  " Flexible backspace
set textwidth=0                 " No automatic line wrapping

" ============================================================================
" SECTION 5: SEARCH AND NAVIGATION
" ============================================================================
set incsearch                   " Incremental search
set hlsearch                    " Highlight search results
set ignorecase                  " Ignore case in searches
set smartcase                   " Case sensitive if uppercase used
set path+=**                    " Recursive search in subdirectories

" Wild menu settings
set wildmenu                    " Enhanced completion menu
set wildmode=longest:full,full  " Better completion behavior
set wildignore+=*/node_modules/*,*/.git/*,*.pyc,*/__pycache__/*,*.o,*.class,*.log
set completeopt=menuone,noselect,noinsert

" ============================================================================
" SECTION 6: PERFORMANCE OPTIMIZATIONS
" ============================================================================
set timeoutlen=500              " Key combination timeout
set ttimeoutlen=10              " Terminal key code timeout

" Performance optimization for large files
autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 |
    \ syntax clear | set nocursorline | endif

" ============================================================================
" SECTION 7: PLUGIN MANAGEMENT (vim-plug)
" ============================================================================
call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'        " Syntax highlighting
Plug 'dense-analysis/ale', {'for': ['python', 'javascript', 'typescript', 'go', 'c', 'cpp', 'sh', 'json','']} " Linting
Plug 'tpope/vim-fugitive'          " Git integration
Plug 'airblade/vim-gitgutter'      " Git signs
Plug 'preservim/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']} " File explorer
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy search
Plug 'junegunn/fzf.vim'            " Vim integration
Plug 'vim-airline/vim-airline'     " Status bar
Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'sass', 'less', 'html', 'javascript', 'typescript', 'vim']} " CSS colors
Plug 'Exafunction/codeium.vim', { 'branch': 'main' } " AI autocomplete
Plug 'kshenoy/vim-signature'       " Mark management
Plug 'ioksc/vim-osaka-solarized-theme' " Custom theme
Plug 'ryanoasis/vim-devicons'      " Icons
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' } " Go support
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
call plug#end()

" ============================================================================
" SECTION 8: APPEARANCE
" ============================================================================
if has('termguicolors')
    set termguicolors
endif
set t_Co=256
syntax on
set background=dark
colorscheme osaka_solarized

" ============================================================================
" SECTION 9: PLUGIN CONFIGURATIONS
" ============================================================================

" NERDTree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 3
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = ['^node_modules$', '\.pyc$', '^__pycache__$', '\.git$']
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" GitGutter configuration
let g:gitgutter_max_signs = 1000
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_enabled = 1
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 1

" ALE configuration
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 500
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_linters = {
    \ 'sh': ['shellcheck'],
    \ 'python': ['pyrefly','ruff'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint', 'tsserver'],
    \ 'css': ['stylelint'],
    \ 'html': ['htmlhint'],
    \ 'go': ['gopls', 'golangci-lint'],
    \ 'c': ['clang','cppcheck'],
    \ 'cpp': ['clang','cppcheck'],
    \ }

let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'python': ['ruff','ruff_format'],
    \ 'javascript': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ 'css': ['prettier', 'stylelint'],
    \ 'html': ['prettier'],
    \ 'markdown': ['prettier'],
    \ 'go': ['goimports','golines'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'sh': ['shfmt'],
    \ 'json': ['jq'],
    \ }

let g:ale_c_cc_options = '-std=c11 -Wall'
let g:ale_cpp_cc_options = '-std=c++17 -Wall'
let g:ale_c_cppcheck_options = '--enable=style,performance,portability --suppress=missingIncludeSystem'
let g:ale_cpp_cppcheck_options = '--enable=style,performance,portability --suppress=missingIncludeSystem'

let g:ale_go_goimports_executable = '/home/ioksc/go/bin/goimports'
let g:ale_go_golines_executable = '/home/ioksc/go/bin/golines'
let g:ale_go_golines_options = '-m 80'
let g:ale_go_gopls_executable = '/home/ioksc/go/bin/gopls'
let g:ale_go_golangci_lint_executable = '/home/ioksc/go/bin/golangci-lint'
let g:ale_go_golangci_lint_options = '--fast --enable=revive --enable=godot'
let g:ale_go_golangci_lint_package = 1
let g:ale_go_gofmt_options = '-s'
let g:ale_go_govet_options = ''

" Airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized_osaka'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1

" FZF configuration
let g:fzf_layout = {'window': {'width': 0.9, 'height': 0.8}}
let g:fzf_preview_window = ['right:50%']
let g:fzf_buffers_jump = 1
let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-s': 'split',
    \ 'ctrl-v': 'vsplit'
    \ }

let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

" Codeium configuration
let g:codeium_enabled = 1
let g:codeium_disable_bindings = 0
let g:codeium_idle_delay = 75

" vim-go configuration
let g:go_fmt_command = "goimports"
let g:go_fmt_autosave = 1
let g:go_imports_autosave = 1
let g:go_mod_fmt_autosave = 1
let g:go_fmt_fail_silently = 0
let g:go_fmt_experimental = 0
let g:go_auto_type_info = 0
let g:go_auto_sameids = 0
let g:go_updatetime = 800
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
let g:go_rename_command = 'gopls'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_doc_popup_window = 1
let g:go_doc_keywordprg_enabled = 1
let g:go_test_show_name = 1
let g:go_test_timeout = '10s'
let g:go_test_prepend_name = 1
let g:go_debug_windows = {
    \ 'vars':  'leftabove 35vnew',
    \ 'stack': 'leftabove 20new',
\ }
let g:go_template_autocreate = 1
let g:go_template_file = "main.go"
let g:go_template_use_pkg = 1

" ============================================================================
" SECTION 10: KEY MAPPINGS
" ============================================================================

" Leader key
let mapleader=","

" General shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>e :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>/ :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>b :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bd<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Visual line navigation
nnoremap j gj
nnoremap k gk

" Visual mode indentation
vnoremap < <gv
vnoremap > >gv

" Plugin mappings
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>s :Buffers<CR>
nnoremap <leader>x :ALEFix<CR>

" Git mappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>

" ALE navigation
nmap [e <Plug>(ale_previous_wrap)
nmap ]e <Plug>(ale_next_wrap)

" Project search
nnoremap <leader>/ :Rg<CR>
nnoremap ,go :-1read /home/ioksc/.vim/templates/skeleton.go<CR>6jci"

" Go-specific mappings
augroup go_mappings
    autocmd!
    " Basic commands
    autocmd FileType go nnoremap <buffer> <leader>gr :GoRun<CR>
    autocmd FileType go nnoremap <buffer> <leader>gb :GoBuild<CR>
    autocmd FileType go nnoremap <buffer> <leader>gt :GoTest<CR>
    autocmd FileType go nnoremap <buffer> <leader>gtf :GoTestFunc<CR>
    autocmd FileType go nnoremap <buffer> <leader>gc :GoCoverage<CR>
    autocmd FileType go nnoremap <buffer> <leader>gct :GoCoverageToggle<CR>
    autocmd FileType go nnoremap <buffer> <leader>grs :!go run %<CR>

    " Code navigation
    autocmd FileType go nnoremap <buffer> <leader>gd :GoDef<CR>
    autocmd FileType go nnoremap <buffer> <leader>gv :GoDefSplit<CR>
    autocmd FileType go nnoremap <buffer> <leader>gts :GoDefTab<CR>
    autocmd FileType go nnoremap <buffer> <leader>gi :GoInfo<CR>
    autocmd FileType go nnoremap <buffer> <leader>grf :GoReferrers<CR>
    autocmd FileType go nnoremap <buffer> <leader>gim :GoImplements<CR>

    " Refactoring
    autocmd FileType go nnoremap <buffer> <leader>grn :GoRename<CR>
    autocmd FileType go nnoremap <buffer> <leader>gfs :GoFillStruct<CR>
    autocmd FileType go nnoremap <buffer> <leader>gie :GoIfErr<CR>
    autocmd FileType go nnoremap <buffer> <leader>gke :GoKeyify<CR>

    " Documentation
    autocmd FileType go nnoremap <buffer> <leader>gdo :GoDoc<CR>
    autocmd FileType go nnoremap <buffer> <leader>gdb :GoDocBrowser<CR>

    " File navigation
    autocmd FileType go nnoremap <buffer> <leader>ga :GoAlternate<CR>

    " Linting and errors
    autocmd FileType go nnoremap <buffer> <leader>gvet :GoVet<CR>
    autocmd FileType go nnoremap <buffer> <leader>gme :GoMetaLinter<CR>
    autocmd FileType go nnoremap <buffer> <leader>gch :GoChannelPeers<CR>
    autocmd FileType go nnoremap <buffer> <leader>gca :GoCallers<CR>
    autocmd FileType go nnoremap <buffer> <leader>gce :GoCallees<CR>
    autocmd FileType go nnoremap <buffer> <leader>gic :GoInstallBinaries<CR>
augroup END

" ============================================================================
" SECTION 11: CUSTOM COMMANDS
" ============================================================================
command! -nargs=0 Sudo w !sudo tee % >/dev/null
command! -nargs=0 Format :ALEFix
command! -nargs=0 Config :e $MYVIMRC
command! -nargs=0 Reload :source $MYVIMRC

" Go commands
command! -nargs=0 GoSetup :GoInstallBinaries
command! -nargs=0 GoUpdate :GoUpdateBinaries
command! -nargs=0 GoMod :!go mod tidy
command! -nargs=0 GoBench :!go test -bench=.

" ============================================================================
" SECTION 12: AUTOCOMMANDS
" ============================================================================

" Format and cleanup
augroup format_cleanup
    autocmd!
    " Prevent automatic comments on new lines
    autocmd BufRead,BufNewFile * setlocal formatoptions-=cro
    " Remove trailing whitespace
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Cursor position
augroup cursor_position
    autocmd!
    " Restore cursor position
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" File monitoring
augroup file_monitoring
    autocmd!
    " Reload buffer automatically if changed
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() != 'c' && !bufexists("[Command Line]") |
        \   checktime |
        \ endif
    " Notification when file changes externally
    autocmd FileChangedShellPost *
        \ echohl WarningMsg |
        \ echo "File changed on disk. Buffer reloaded." |
        \ echohl None
augroup END

" Filetype specific settings
augroup filetype_specific
    autocmd!
    autocmd FileType python setlocal textwidth=88 colorcolumn=89
    autocmd FileType javascript,typescript,html,css,json
        \ setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType markdown setlocal spell spelllang=es,en
    autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 textwidth=100 colorcolumn=101
    autocmd FileType go setlocal formatoptions+=cro
    autocmd FileType go setlocal comments=s1:/*,mb:*,ex:*/,://
    autocmd FileType go setlocal commentstring=//\ %s
augroup END

" Assembly filetype
augroup asm_filetype
    autocmd!
    autocmd BufNewFile,BufRead *.asm setfiletype nasm
augroup END

" ============================================================================
" SECTION 13: PYTHON AND VIRTUAL ENVIRONMENTS
" ============================================================================
if has('python3')
    " Automatically detect active virtual environment
    if !empty($VIRTUAL_ENV)
        let g:python3_host_prog = $VIRTUAL_ENV . '/bin/python'
    endif
endif

" Optional configuration for using uv with ALE
" let g:ale_python_ruff_executable = 'uv run ruff'
" let g:ale_python_isort_executable = 'uv run isort'
" let g:ale_python_mypy_executable = 'uv run mypy'

" ============================================================================
" SECTION 14: GO ERROR HANDLING
" ============================================================================
augroup go_errors
    autocmd!
    " Open quickfix automatically if there are errors
    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost    l* nested lwindow
    " Close quickfix if no errors
    autocmd BufWinEnter quickfix setlocal nowrap
augroup END

" Function to show Go errors more clearly
function! s:GoErrorsToggle()
    if getqflist() == []
        echo "No Go errors"
    else
        copen
    endif
endfunction

" ============================================================================
" SECTION 15: MISCELLANEOUS
" ============================================================================
xnoremap <leader>gc  :<C-u>'<-1put ='/*'<CR>:'>+1put ='*/'<CR>

if executable('rg')
    set grepprg=rg\ --vimgrep\ --hidden\ --smart-case
    set grepformat=%f:%l:%c:%m
endif

" inoremap <c-y> <cmd>call augment#Accept()<cr>
