" ============================================================================
" Last Updated: 19-09-2024
" ============================================================================

" -----------------------------
" 1. Configuración Básica
" -----------------------------
set nocompatible 
set encoding=utf-8
set number relativenumber
set mouse=a
set hidden
set noswapfile
set clipboard=unnamedplus
set scrolloff=5   
set showmatch 

" -----------------------------
" 2. Rendimiento
" -----------------------------
set lazyredraw
set ttyfast
set updatetime=300

" -----------------------------
" 3. Búsqueda e Indentación
" -----------------------------
set incsearch hlsearch ignorecase smartcase
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set autoindent smartindent

" --------------------------------
" 4. Gestión de Plugins (vim-plug)
" --------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Sintaxis y lenguajes
Plug 'sheerun/vim-polyglot'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Utilidades
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Apariencia
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'


" Búsqueda avanzada
Plug 'mileszs/ack.vim'

call plug#end()

" -----------------------------
" 5. Configuración de Apariencia
" -----------------------------
syntax on
set background=dark
colorscheme onedark
" -----------------------------
" 6. Configuración de Plugins
" -----------------------------

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

" Airline
let g:airline#extensions#tabline#enabled = 1

" GitGutter
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '~-'

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" Ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'  " Usa ag si está disponible
endif

" -----------------------------
" 7. Mapeos de Teclas
" -----------------------------
let mapleader = "\<Space>"

" NERDTree
" <C-n>: Abre/cierra el explorador de archivos NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Movimiento entre ventanas
" <C-J>: Mueve el cursor a la ventana inferior
" <C-K>: Mueve el cursor a la ventana superior
" <C-L>: Mueve el cursor a la ventana derecha
" <C-H>: Mueve el cursor a la ventana izquierda
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" FZF
" <C-p>: Abre el buscador de archivos FZF
" <leader>b: Abre el buscador de buffers FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>

" Utilidades
" <leader>w: Guarda el archivo actual
" <leader>q: Cierra el buffer actual
" <leader>e: Abre el archivo de configuración de Vim
" <leader>r: Recarga el archivo de configuración de Vim
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :e $MYVIMRC<CR>
nnoremap <leader>r :source $MYVIMRC<CR>

