" --------------------------------
" Basic settings
" --------------------------------

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
set smartindent

" Spelling checking
set spelllang=en_us
set spell

" Highlight current line
set cursorline
highlight Cursorline cterm=bold ctermbg=black

" Enable highlight search pattern
set hlsearch

" Enable smart case search sensitivity
set ignorecase
set smartcase

" Enable relative line numbers
set number
set relativenumber

" Show the matching part of pairs [] {} and ()
set showmatch

" How long Vim waits (in milliseconds) before triggering certain idle events
set updatetime=800

" Disable top banner
let g:netrw_banner = 0

" Setup cursor appearance for different modes
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" Auto completion alias
inoremap <S-Tab> <C-n>
set complete=.,w,b,u,t

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

" --------------------------------
" Theme settings
" --------------------------------

" Enable color themes
if !has('gui_running')
	set t_Co=256
endif

" Enable true colors support
set termguicolors

" Theme
colorscheme shine

" --------------------------------
" Status line settings
" --------------------------------

" Always show status line
set laststatus=2

" Displays the current Vim mode in the status line
set showmode

" Show path to current file
set statusline=%f

" Split on the left and right
set statusline+=%=

" Show row and col info
set statusline+=%(%l,%c%V\ %=\ %P%)

" Show currently opened file type
set statusline+=\ %y

" Show if buffer is read-only
set statusline+=\ %r

" Line number info
set statusline+=\ %l/%L

" Setup git branch in status line
function! UpdateGitBranch()
  let dir = expand('%:p:h')
  if finddir('.git', dir . ';') != ''
    let b:git_branch = substitute(system('git -C ' . dir . ' branch --show-current'), '\n', '', '')
  else
    let b:git_branch = ''
  endif
endfunction

augroup gitbranch
  autocmd!
  autocmd BufEnter,DirChanged * call UpdateGitBranch()
augroup END

let &statusline .= '  %{get(b:, "git_branch", "")}'

" --------------------------------
" Search settings
" --------------------------------

" Search all sub directories
set path+=$PWD/**

" Visual menu for command completion
set wildmenu

" wildignore only removes entries from the wildmenu
" after entries have been found; it does not change search times
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/build/**,*.pyc,*.o
set wildignorecase

" Set grep search to git grep
set gp=git\ grep\ -n

" Search for grep in all project files
" Should contain space after :grep
nnoremap <leader>sfg :grep 

" Search for current word under the cursor in all project files
nnoremap <leader>sfgc :grep! <C-R><C-W>

" Just press Enter after performing grep search and it
" will automatically run :copen
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" --------------------------------
" Resolving merge conflicts settings
" --------------------------------

" 1. Run 'git config --global merge.tool vimdiff' to assign merge tool to vimdiff app
" 2. Run 'git config --global mergetool.keepBackup false' to disable backup files
" 3. Checkout to the branch you want to merge something in and run 'git merge'.
" 4. Then run 'git mergetool'.
" 5. To accept changes you can write 'diffget N' where N is the number of window with
" corresponding changes.
nnoremap <leader>dvm :!git mergetool<CR>

" --------------------------------
" Git file changes
" --------------------------------

" After using this binding, put cursor on file path and press gf to open the file
nnoremap <leader>dv :cexpr system('git diff --name-only')<CR>:copen<CR>

" Revert all changes for the current file
nnoremap <leader>dvr :!git restore %<CR>:e!<CR>

" Show diff for the current file
function! GitFileDiff()
  " Get Git repo root
  let root = systemlist('git rev-parse --show-toplevel')[0]

  " Compute file path relative to repo root
  let f = substitute(expand('%:p'), root.'/', '', '')

  " Save the original file name
  let original_name = expand('%:t')

  " Open vertical split for HEAD version
  vert new
  setlocal buftype=nofile
  setlocal bufhidden=wipe

  " Temporarily set buffer name for syntax detection
  execute 'file HEAD:' . original_name

  " Load HEAD version silently
  execute 'silent! read !git show HEAD:' . f
  1delete

  " Detect filetype
  filetype detect

  " Enable diff mode
  diffthis
  wincmd p
  diffthis
endfunction

nnoremap <leader>dvf :call GitFileDiff()<CR>

" --------------------------------
" File explorer settings
" --------------------------------

" Netrw setup
nnoremap <leader>e :Explore<CR>

" Splits
" Split window from the current file
nnoremap <leader>v :Vexplore<CR>

" Increase size of the current split window
nnoremap <leader>> :vertical resize +10<CR>

" Decrease size of the current split window
nnoremap <leader>< :vertical resize -10<CR>

" Make all split windows equal size
nnoremap <leader>= :wincmd =<CR>

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

" List all previously opened files available in the buffer
" Should contain space after :b
" It will use wildmenu to display recent files in buffer
" nnoremap <leader>? :b 

" Or we can use ls to see the latest files
" It can be more convenient because it shows file numbers that
" you can use to jump to them
nnoremap <leader>? :ls!<CR>:b<Space>

" Open prev file in the buffer
nnoremap <leader>, :bp <CR>

" Open next file in the buffer
nnoremap <leader>. :bn <CR>

" Search for file
" Should contain space after :find
nnoremap <leader>sf :find 

" Search in files with entering path
" Should contain space after :e
nnoremap <leader>sp :e 
set suffixesadd+=.py,.js,.jsx,.ts,.tsx,.c,.h,.cpp,.json,.rs,.cs

" --------------------------------
" Language specific settings
" --------------------------------

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

" Show references to the word under the cursor in the current file
nnoremap gr :LspReferences<CR>

" Show type information (hover)
nnoremap K :LspHover<CR>

" Rename all occurrences of the symbol in the current file
nnoremap <leader>rn :LspRename<CR>

" Code action
nnoremap <leader>ca :LspCodeAction<CR>

" Show LSP errors in the current file
nnoremap <leader>si :LspDocumentDiagnostics<CR>

" Apply formatting for the current file
nnoremap <leader>fm :LspDocumentFormat<CR>

" Remove trailing whitespace from JavaScript, TypeScript, JSX, TSX, CSS, HTML and Rust files
autocmd BufWritePre *.js :%s/\s\+$//e
autocmd BufWritePre *.ts :%s/\s\+$//e
autocmd BufWritePre *.jsx :%s/\s\+$//e
autocmd BufWritePre *.tsx :%s/\s\+$//e
autocmd BufWritePre *.css :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.rs :%s/\s\+$//e
