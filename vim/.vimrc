set nocompatible
set encoding=utf-8
filetype plugin indent on

" Performance optimizations
set lazyredraw
set updatetime=500
set cursorline
set regexpengine=2

set number
set relativenumber
set mouse=a

set splitbelow
set splitright

set hidden
set noswapfile
set nobackup
set nowritebackup

set clipboard=unnamed
set scrolloff=5
set showmatch matchtime=2
set path+=**
set shortmess+=c
set signcolumn=yes

" Wildmenu improvements
"
set wildmenu
set wildmode=longest:full,full
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.git/*,*/node_modules/*,*.pyc

" 3. Search and Indentation
set incsearch
set hlsearch
set ignorecase
set smartcase
set expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set autoindent smartindent
set formatoptions+=j
set backspace=indent,eol,start

" 4. Plugin Management (vim-plug)
"
" Auto-install vim-plug
" let data_dir = '~/.vim'
" if empty(glob(data_dir . '/autoload/plug.vim'))
"   silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" endif

call plug#begin('~/.vim/plugged')

" Essential plugins with lazy loading
Plug 'sheerun/vim-polyglot'                                                       " Syntax highlighting
Plug 'dense-analysis/ale', {'for': ['python', 'javascript', 'typescript']}
Plug 'tpope/vim-fugitive'                                                         " Git integration
Plug 'airblade/vim-gitgutter'                                                     " Git signs
Plug 'preservim/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'                                                    " Status line
Plug 'ap/vim-css-color', { 'for': ['css', 'scss', 'sass', 'less'] }
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }                              " AI completion
Plug 'mileszs/ack.vim'                                                            " Search
Plug 'kshenoy/vim-signature'                                                      " Marks
Plug 'ioksc/vim-osaka-solarized-theme'                                            " My Color scheme
Plug 'ryanoasis/vim-devicons'                                                     " Icons

call plug#end()

" 5. Appearance
" -----------------------------
if exists('+termguicolors')
    set termguicolors
endif

syntax enable
set background=dark
colorscheme osaka_solarized

" 6. Plugin Configurations
" -----------------------------
" NERDTree
let g:NERDTReeUpdateOnCursorHold = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
" let g:NERDTreeWinPos = "right"

" GitGutter optimizations
let g:gitgutter_max_signs = 500
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_preview_win_floating = 1
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0

" ALE optimizations
let g:ale_lint_delay = 200
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

let g:ale_linters = {
\   'python': ['pylint', 'flake8'],
\   'javascript': ['eslint'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'javascript': ['prettier', 'eslint'],
\}

" Airline optimizations
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline#extesions#tabline#show_buffers = 0
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized_osaka'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_skip_empty_sections = 1

" FZF optimizations
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" -----------------------------
" 7. Key Mappings
" -----------------------------
let mapleader = " "

" General mappings
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <silent> <leader>I :PlugInstall<CR>

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Buffer navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Plugin mappings
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>f :ALEFix<CR>

" ALE navigation
nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)

" Git mappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" 8. Commands
" -----------------------------
command! -nargs=0 Sudo w !sudo tee % >/dev/null

" 9. Autocommands
" -----------------------------
augroup vimrc_autocmds
    autocmd!
    " Automatically remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e

    " Return to last edit position when opening files
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " Faster startup
    autocmd VimEnter * redraw!
augroup END


" End of configuration
nnoremap <leader>sh :0read $HOME/.vim/templates/skeleton.bash<CR>4ja

