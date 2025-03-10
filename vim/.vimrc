" 1. General Settings
set nocompatible              " Asegura que Vim use sus mejoras sobre Vi
set encoding=utf-8            " Codificación UTF-8 por defecto
filetype plugin indent on     " Habilita detección de tipo de archivo e indentación

" Performance optimizations
set lazyredraw                          " Reduce redibujado innecesario
set updatetime=250                      " Tiempo más rápido para eventos (antes 300)
set ttyfast                             " Mejora rendimiento en terminales modernas
set cursorline                          " Resalta la línea actual
set regexpengine=1                      " Usa el motor de expresiones regulares más rápido (antes 2)
set synmaxcol=200                       " Limita resaltado de sintaxis en líneas largas
set number relativenumber               " Números de línea absolutos y relativos combinados
set mouse=a                             " Habilita el ratón en todos los modos
set splitbelow splitright               " Splits más intuitivos
set hidden                              " Permite cambiar buffers sin guardar
set noswapfile nobackup nowritebackup   " Desactiva archivos de respaldo
set clipboard+=unnamedplus              " Usa el portapapeles del sistema
set scrolloff=5                         " Margen de líneas visibles al desplazar
set showmatch matchtime=2               " Resalta paréntesis coincidentes
set path+=**                            " Búsqueda recursiva en subdirectorios
set shortmess+=c                        " Evita mensajes innecesarios
set signcolumn=yes                      " Siempre muestra la columna de signos

" Wildmenu improvements
set wildmenu                            " Menú de autocompletado mejorado
set wildmode=longest:full,full          " Completado más largo primero, luego completo
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/.git/*,*/node_modules/*,*.pyc " Ignora archivos innecesarios

" Search and Indentation
set incsearch hlsearch         " Búsqueda incremental con resaltado
set ignorecase smartcase       " Búsqueda sensible a mayúsculas solo si se usan
set expandtab tabstop=4 softtabstop=4 shiftwidth=4 " 4 espacios para tabs
set autoindent smartindent     " Indentación automática e inteligente
set formatoptions+=j           " Une comentarios de manera inteligente
set backspace=indent,eol,start " Retroceso más flexible
set list
set listchars=space:·,tab:▸-,trail:•

" 2. Plugin Management (vim-plug)
call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'                             " Resaltado de sintaxis
Plug 'dense-analysis/ale', {'for': ['python', 'javascript', 'typescript']} " Linting
Plug 'tpope/vim-fugitive'                               " Integración con Git
Plug 'airblade/vim-gitgutter'                           " Signos de Git
Plug 'preservim/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind']} " Explorador de archivos
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Búsqueda difusa
Plug 'junegunn/fzf.vim'                                 " Integración con Vim
Plug 'vim-airline/vim-airline'                          " Barra de estado
Plug 'ap/vim-css-color', {'for': ['css', 'scss', 'sass', 'bash', 'less']} " Colores en CSS
Plug 'Exafunction/codeium.vim', { 'branch': 'main' }    " Autocompletado IA
Plug 'mileszs/ack.vim'                                  " Búsqueda avanzada
Plug 'kshenoy/vim-signature'                            " Gestión de marcas
Plug 'ioksc/vim-osaka-solarized-theme'                  " Tema personalizado
Plug 'ryanoasis/vim-devicons'                           " Iconos
call plug#end()

" 3. Appearance
if has('termguicolors')         " Usa colores verdaderos si está disponible
    set termguicolors
endif
syntax on                       " Activa resaltado de sintaxis
set background=dark             " Fondo oscuro
colorscheme osaka_solarized     " Tema personalizado

" 4. Plugin Configurations
" NERDTree
let g:NERDTreeShowHidden=1            " Muestra archivos ocultos
let g:NERDTreeQuitOnOpen=1            " Cierra NERDTree al abrir un archivo
let g:NERDTreeMinimalUI=1             " Interfaz mínima
let g:NERDTreeDirArrowExpandable='+'  " Iconos simplificados
let g:NERDTreeDirArrowCollapsible='-'

" GitGutter
let g:gitgutter_max_signs=500   " Limita signos para mejor rendimiento
let g:gitgutter_sign_added='+'  " Signos personalizados
let g:gitgutter_sign_modified='~'
let g:gitgutter_sign_removed='-'

" ALE
let g:ale_lint_on_text_changed='never' " Lint solo en eventos específicos
let g:ale_lint_on_insert_leave=1       " Lint al salir del modo inserción
let g:ale_lint_on_save=1               " Lint al guardar
let g:ale_fix_on_save=1                " Corrige al guardar
let g:ale_sign_error='✘'               " Signos personalizados
let g:ale_sign_warning='⚠'
let g:ale_linters = {'python': ['ruff'], 'javascript': ['eslint']}
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'], 'python': ['ruff', 'isort'], 'javascript': ['prettier', 'eslint']}

" Airline
let g:airline_powerline_fonts=1             " Usa fuentes Powerline
let g:airline_theme='solarized_osaka'       " Tema personalizado
let g:airline#extensions#ale#enabled=1      " Integra ALE
let g:airline#extensions#tabline#enabled=1  " Muestra pestañas
let g:airline#extensions#tabline#formatter='unique_tail'  " Formato simplificado

" FZF
let g:fzf_layout={'window': {'width': 0.9, 'height': 0.8}} " Ventana optimizada
let g:fzf_preview_window=['right:50%'] " Vista previa a la derecha
let g:fzf_buffers_jump=1               " Salta a buffers existentes

" 5. Key Mappings
let mapleader=","

nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>
nnoremap <leader>/ :nohlsearch<CR>

nnoremap <leader>b :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bd<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>s :Buffers<CR>
nnoremap <leader>x :ALEFix<CR>

nnoremap <leader>gs :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>

nmap [e <Plug>(ale_previous_wrap)
nmap ]e <Plug>(ale_next_wrap)

" 6. Commands
command! -nargs=0 Sudo w !sudo tee % >/dev/null

" 7. Autocommands
augroup vimrc_autocmds
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e " Elimina espacios al final al guardar
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif " Regresa a la última posición
augroup END

" Test  UV

" Detectar el entorno virtual de uv dinámicamente
" function! SetupPythonEnv()
"     let l:venv_path = finddir('.venv', getcwd() . ';')
"     if l:venv_path != ''
"         let l:python_path = l:venv_path . '/bin/python'
"         if executable(l:python_path)
"             let g:python3_host_prog = l:python_path  " Define el intérprete para Vim
"             let $PATH = l:venv_path . '/bin:' . $PATH  " Añade bin al PATH
"             echom "Usando entorno virtual de uv en: " . l:python_path
"         endif
"     else
"         echom "No se encontró entorno virtual .venv en el proyecto"
"     endif
" endfunction

" Ejecutar al abrir un archivo Python
" augroup python_env
"     autocmd!
"     autocmd FileType python call SetupPythonEnv()
" augroup END
let g:ale_python_ruff_executable = 'uv run ruff'
let g:ale_python_isort_executable = 'uv run isort'

