set encoding=utf-8
set nocompatible
syntax on
set number relativenumber      " Display relative line numbers
set showcmd                    " Always show commands
set wildmenu                   " Autocomplete wild menu
set splitbelow splitright      " Split to the right/bottom, not default left/bottom
set showmatch                  " Highlight matching brackets

" Tabs
set tabstop=4                  " Displayed visual length of tab byte
set softtabstop=4              " Visual indentation length when TAB is pressed
set expandtab                  " Convert tabs to spaces
set shiftwidth=4               " Automatic indentation after e.g. { symbol
filetype indent on

" Search tweaks
set incsearch
set hlsearch
set ignorecase
set smartcase

" Default file browser (netrw) tweaks (from a YouTube talk)
" Run :Vexplore to open vertical window.
let g:netrw_banner=0           " Remove banner
let g:netrw_browse_split=4     " Open in prior window
let g:netrw_altv=1             " Open splits to the right
let g:netrw_liststyle=3        " Tree view
let g:netrw_winsize = 25       " Set window width to 25 characters

" Plugins (vim-plug manager is used, run :PlugInstall to install all plugins)
call plug#begin('$HOME/.local/share/nvim/site/autoload/')
Plug 'mg979/vim-visual-multi', {'branch': 'master'}        " C-n - next occurrence, C-up/down - multicursor
Plug 'vim-airline/vim-airline'                             " Configured below
Plug 'easymotion/vim-easymotion'                           " Space-s, configured below
Plug 'nvim-lua/plenary.nvim'                               " Dependency required by Telescope (see next line)
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
call plug#end()

" Key bindings
nnoremap <SPACE> <Nop>             " Remove all previous mappings to SPACE key...
let mapleader=" "                  " ... and use SPACE key as leader key.
nnoremap <leader>a :Vexplore<CR>

" Airline customization
let g:airline_section_z="%p%% | %l:%c"    " %p%% - percentage, %L - total number of lines

" Easymotion configuraton
let g:EasyMotion_do_mapping = 0        " Disable default mappings
nmap s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Telescope configuration
nnoremap <leader>q <cmd>Telescope find_files<cr>
nnoremap <leader>w <cmd>Telescope live_grep<cr>
nnoremap <leader>e <cmd>Telescope buffers<cr>
nnoremap <leader>r <cmd>Telescope help_tags<cr>

colorscheme desert

