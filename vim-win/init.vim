" CUSTOM SHORTCUTS
" ================
" "*y - copy to clipboard
" "*p - paste from clipboard
" space-f  - helm style search
" space-F - TODO helm style search in multiple files (:vimgrep ‘searchstring’ **/*.cpp)
" space-h - TODO replace <from> <to> (:%s/from/to/g)
" space-z - NERDTreeToggle (toggle visibility)
" space-x - NERDTreeFind (locate current file in NERDTree)
" space-, - noh
" space-. - cclose

set encoding=utf-8
set nocompatible
filetype off

" Plugins
call plug#begin('$HOME/AppData/Local/nvim/plugged/')

Plug 'preservim/nerdtree'
Plug 'qpkorr/vim-bufkill'     " :BUN :BD :BW / :BB :BF :BA
Plug 'ctrlpvim/ctrlp.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'

call plug#end()

syntax on
colorscheme desert    " darkblue or zellner

" Tabs
set tabstop=4
set softtabstop=4
set expandtab       " Convert tabs to spaces
set shiftwidth=4    " Automatic indentation after e.g. { symbol

" Line numbers
set number relativenumber

" Width marker
set colorcolumn=80

" Always show commands
set showcmd

" Highlight cursor line
" set cursorline
" set cursorcolumn

" Filetype detection
filetype indent on

" Autocomplete wild menu
set wildmenu

" Split to the right/bottom, not default left/top
set splitbelow splitright

" Highlight matching brackets
set showmatch

" Default file browser (netrw) tweaks (from a YouTube talk)
" let g:netrw_banner=0         " remove banner
let g:netrw_browse_split=4   " open in prior window
let g:netrw_altv=1           " open splits to the right
let g:netrw_liststyle=3      " tree view

" Search tweaks
set incsearch       " Search as you type
set hlsearch        " highlight matches
set ignorecase
set smartcase

" Font
set guifont=Consolas:h10

" CtrlP default directory settings
" Start at the nearest ancestor of the current file that contains project
" markers like .git, .hg, .svn, etc.
let g:ctrlp_working_path_mode = 'ra'    " 'c' for directory of the current file
let g:ctrlp_root_markers = ['pom.xml', 'dub.json', 'dub.sdl', 'build.bat', '.gradle', '.idea', 'CMakeLists.txt']
" CtrlP ignores the following files and folders:
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|vscode)$',
  \ 'file': '\v\.(exe|so|dll|obj)$',
  \ }

" ==================
" My custom commands
" ==================
command CD_coding call ZK_GoToDirectory("$HOME/coding")
function ZK_GoToDirectory(dirpath)
    exe 'cd' a:dirpath
    NERDTree
endfunction
" Search inside current file with result list (https://vim.fandom.com/wiki/Search_using_quickfix_to_list_occurrences)
command -nargs=1 ZKfind :execute 'vimgrep '.expand(<f-args>).' '.expand('%') | :copen | :cc
nnoremap <C-j> :cnext<CR> :norm! zz<CR>
nnoremap <C-k> :cprev<CR> :norm! zz<CR>
nnoremap <C-h> :cfirst<CR> :norm! zt<CR>
nnoremap <C-l> :clast<CR> :norm! zz<CR>
nnoremap <space>f :ZKfind<space>
nnoremap <space>, :noh<CR>
nnoremap <space>. :cclose<CR>
nnoremap <space>z :NERDTreeToggle<CR>
nnoremap <space>x :NERDTreeFind<CR>

" =======================
" Stuff to run on startup
" =======================
autocmd VimEnter * call MyStartupActions()
function MyStartupActions()
    edit +setf\ vim $HOME/AppData/Local/nvim/init.vim
    call ZK_GoToDirectory("$HOME/coding")
endfunction

" =========
" COC stuff
" =========
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages (was =2 earlier)
set cmdheight=1

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

