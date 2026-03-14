" Disable compatibility with vi editor in order to use modern Vim features
set nocompatible

" Setup leader symbol
nnoremap <SPACE> <Nop>
let mapleader=" "

" Enable mouse support 
set mouse=a

" Enable syntax
syntax enable

" Configure indentation
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set textwidth=80

" Highlight current line
set cursorline
:highlight Cursorline cterm=bold ctermbg=black

" Enable highlight search pattern
set hlsearch

" Enable smartcase search sensitivity
set ignorecase
set smartcase

" Enable relative line numbers
set number
set relativenumber

" Show the matching part of pairs [] {} and ()
set showmatch

" Remove trailing whitespace from Python, JavaScript, TypeScript, JSX, TSX, CSS, HTML and Rust files
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.ts :%s/\s\+$//e
autocmd BufWritePre *.jsx :%s/\s\+$//e
autocmd BufWritePre *.tsx :%s/\s\+$//e
autocmd BufWritePre *.css :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.rs :%s/\s\+$//e

" Enable color themes
if !has('gui_running')
	set t_Co=256
endif

" Enable true colors support
set termguicolors

" Colorscheme
colorscheme shine

set updatetime=800
set showmode

" Configure status line
set laststatus=2
set statusline=%f\
set statusline+=%h%w%m%r\
set statusline+=%=
set statusline+=%(%l,%c%V\ %=\ %P%)

" Show type definitions (probably works with C and some others)
nnoremap K :ptag <cword><CR>

" Search
" Vim has native feature for following path.
" Simply put the cursor on path and press gf.
" If you want to go to definition in the same file
" vim also has native feature for it. Put cursor on
" variable/function etc and press gd.

" Search all subdirectories
set path+=$PWD/**
" Visual menu for command completion
set wildmenu

" wildignore only removes entries from the wildmenu
" after entries have been found; it does not change search times
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/build/**,*.pyc,*.o
set wildignorecase

set gp=git\ grep\ -n

" Should contain space after :grep
nnoremap <leader>sfg :grep 

" Just press Enter after performing grep search and it
" will automatically run :copen
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" Merge conflicts
" 1. Run 'git config --global merge.tool vimdiff' to assign merge tool to vimdiff app
" 2. Run 'git config --global mergetool.keepBackup false' to disable backup files
" 3. Checkout to the branch you want to merge something in and run 'git merge'.
" 4. Then run 'git mergetool'.
" 5. To accept changes you can write 'diffget N' where N is the number of window with
" corresponding changes.
nnoremap <leader>dvc :!git mergetool<CR> 

" File navigation

" List all previously opened files available in the buffer
" Should contain space after :b
nnoremap <leader>? :b 

" Open prev file in the buffer
nnoremap <leader>, :bp <CR>

" Open next file in the buffer
nnoremap <leader>. :bp <CR>

" Search for file
" Should contain space after :find
nnoremap <leader>sf :find 

" Search with inline path
" Should contain space after :e
nnoremap <leader>sp :e 
set suffixesadd+=.py,.js,.jsx,.ts,.tsx,.c,.h,.cpp,.json,.rs,.cs

" Multiline editing
" Select multiple lines in visual mode
" and press <leader>aa. Then you can add
" any prefix you want and press ESC.
" To remove prefix select lines in visual
" mode in a way that the last selection
" captures the whole prefix you want to remove.
" Press <leader>ar which will select prefix for
" each row. Then press x which will remove prefix.
" Can be used for commenting.
vnoremap <leader>aa <C-v>A
vnoremap <leader>ar <C-v>

" Autocompletion alias
inoremap <S-Tab> <C-n>
set complete=.,w,b,u,t

" Disable top banner
let g:netrw_banner = 0

" Setup cursor appearance for different modes
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" Netrw setup
nnoremap <leader>e :Explore<CR>
nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>h :Hexplore<CR>

function! NetrwMapping()
  " Mark a file
  nmap <buffer> <TAB> mf         
  
  " Unmark all marked files
  nmap <buffer> <Leader><TAB> mu 
  
  " Current browsing directory becomes markfile target
  nmap <buffer> <S-TAB> mt       
  
  " Create a new file
  nmap <buffer> ff %    

  " Create a new directory
  nmap <buffer> fd d             
  
  " Edit file/directory name
  nmap <buffer> fe R            

  " Delete file or empty directory
  nmap <buffer> fr D             

  " Copy marked files to marked-file target directory
  nmap <buffer> fc mc         

  " After you mark your files you can put the cursor in a directory
  " and this will assign the target directory and copy in one step
  nmap <buffer> fC mtmc          

  " Move marked files to marked-file target directory
  nmap <buffer> fx mm            
  
  " Same thing as fC but for moving files
  nmap <buffer> fX mtmm          
  
  " Run external shell command on marked files
  nmap <buffer> f; mx            
  
  " Bookmark current directory
  nmap <buffer> fb mb            
  
  " Go to previous bookmarked directory
  nmap <buffer> fbg gb           
  
  " Remove most recent bookmark
  nmap <buffer> fbr mB           
  
  " Show a list of marked files
  nmap <buffer> flm :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR> 
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

" Setup git branch in status line
function! GitBranch()
  let branch = system("git -C " . expand('%:p:h') . " branch --show-current 2>/dev/null")
  return substitute(branch, '\n', '', '')
endfunction

set statusline+=\ [%{GitBranch()}]

" LSP CONFIG

" To install without plugin manager:
" 1. mkdir -p ~/.vim/pack/lsp/start
" 2. cd ~/.vim/pack/lsp/start
" 3. git clone https://github.com/prabirshrestha/vim-lsp.git

" Lsp for rust.
" Install rust-analyzer globally: rustup component add rust-analyzer
if executable('rust-analyzer')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'rust-analyzer',
      \ 'cmd': {server_info->['rust-analyzer']},
      \ 'allowlist': ['rust'],
      \ })
endif

" Lsp for JS/TS.
" Install language server globally: npm install -g typescript typescript-language-server
if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'ts-lsp',
      \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
      \ 'allowlist': ['javascript','javascriptreact','typescript','typescriptreact'],
      \ })
endif

" Go to definition
nnoremap gd :LspDefinition<CR>

" Show references to the word under the cursor
nnoremap gr :LspReferences<CR>

" Show type information (hover)
nnoremap K :LspHover<CR>

" Rename symbol
nnoremap <leader>rn :LspRename<CR>

" Code action
nnoremap <leader>ca :LspCodeAction<CR>

" Show lsp errors in current file
nnoremap <leader>si :LspDocumentDiagnostics<CR>

" Apply formatting
nnoremap <leader>fm :LspDocumentFormat<CR>
