" ----------------------------------------
"
" Reusable functions
"
" ----------------------------------------

function! s:TruncatePath(path, max)
  if strlen(a:path) <= a:max
    return a:path
  endif
  return '…' . strpart(a:path, strlen(a:path) - a:max + 1)
endfunction

" ----------------------------------------
"
" Basic settings
"
" ----------------------------------------

" Disable compatibility with vi editor in order to use modern Vim features.
set nocompatible

" Setup leader symbol. This is the button that you press before
" using another combo keybinding.
nnoremap <SPACE> <Nop>
let mapleader=" "

" Enable mouse support.
set mouse=a

" Enable syntax highlighting.
syntax enable

" Configure indentation.
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set textwidth=100
set smartindent

" Use tabs for Makefile since required.
autocmd FileType make setlocal noexpandtab

" Use 2 spaces for JS/TS and their JSX variants.
autocmd FileType javascript,typescript,javascriptreact,typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Spell checking.
set spelllang=en_us
set spell

" Highlight current line which mouse is on.
set cursorline
highlight Cursorline cterm=bold ctermbg=black

" Enable highlight search pattern.
set hlsearch

" Enable smart case search sensitivity.
set ignorecase
set smartcase

" Enable relative line numbers.
set number
set relativenumber

" Show the matching part of pairs [] {} and ().
set showmatch

" How long Vim waits (in milliseconds) before triggering certain idle events.
set updatetime=800

" Setup cursor appearance for different modes.
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" Auto completion alias. Press Shift-Tab in Insert mode to
" view auto completion options. It does not rely on LSP.
inoremap <S-Tab> <C-n>
set complete=.,w,b,u,t

" Multi line editing.
" Select multiple lines in visual mode
" and press <leader>aa. Then you can add
" any prefix you want and press Escape.
" To remove prefix select lines in visual
" mode in a way that the last selection
" captures the whole prefix you want to remove.
" Press <leader>ar which will select prefix for
" each row. Then press x which will remove prefix.
" Can be used for commenting.
vnoremap <leader>aa <C-v>A
vnoremap <leader>ar <C-v>

" Refresh file. Useful if for any reason
" lps warnings are cached.
nnoremap <leader>rr :e!<CR>

" ----------------------------------------
"
" Code aliases
"
" ----------------------------------------

" Ctrl + l alias for Browser console.log API.
inoremap <C-l> console.log()<Left>

" Ctrl + p alias for Rust's println! macro.
inoremap <C-p> println!()<Left>

" ----------------------------------------
"
" Theme settings
"
" ----------------------------------------

" Enable color themes.
if !has('gui_running')
	set t_Co=256
endif

" Enable true colors support.
set termguicolors

" Set theme.
" Light.
colorscheme shine
" Dark.
" colorscheme habamax

" ----------------------------------------
"
" Status line settings
"
" ----------------------------------------

" Always show status line.
set laststatus=2

" Displays the current Vim mode in the status line.
set showmode

" Show path to current file.
set statusline=%f

" Split on the left and right.
set statusline+=%=

" Show row and col info.
set statusline+=%(%l,%c%V\ %=\ %P%)

" Show currently opened file extension.
set statusline+=\ %y

" Show if buffer is read-only.
set statusline+=\ %r

" Show how many matches we have for the current search
" pattern in the current file when we use ?<something>.
function! StatusLineSearchCount()
  if !v:hlsearch
    return ''
  endif
  let sc = searchcount({ 'maxcount': 0 })
  if empty(sc) || sc.total == 0
    return ''
  endif
  return printf('[%d/%d]', sc.current, sc.total)
endfunction
set statusline+=\ %{StatusLineSearchCount()}

" Setup git branch in status line.
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
let &statusline .= ' %{empty(get(b:, "git_branch", "")) ? "" : " " . get(b:, "git_branch")}'

" ----------------------------------------
"
" Search settings
"
" ----------------------------------------

" Set absolute path to be able to search in all sub directories.
set path+=$PWD/**

" Visual menu for command completion.
set wildmenu

" 'wildignore' only removes entries from the wildmenu
" after entries have been found. It does not change search times.
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/build/**,*.pyc,*.o

" Make file search case insensitive.
set wildignorecase

" Search for a file.
" This setting should contain space after :find so you
" don't need to specify it manually after <leader>sf.
nnoremap <leader>sf :find 

" Search in files with entering path.
" This setting should contain space after :e so you
" don't need to specify it manually after <leader>sp.
nnoremap <leader>sp :e 

" Automatically add file extensions when searching for files.
set suffixesadd+=.py,.js,.jsx,.ts,.tsx,.c,.h,.cpp,.json,.rs,.css,.scss

" Set grep search tool to 'git grep'.
set gp=git\ grep\ -n

" Search for sub string in all project files.
nnoremap <leader>sg :grep ""<Left>

" Search for current word under the cursor in all project files.
nnoremap <leader>sgc :grep! <C-R><C-W>

" Just press Enter after performing grep search and it
" will automatically run :copen
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" ----------------------------------------
"
" Resolving merge conflicts settings
"
" ----------------------------------------

" 1. Merge branch into target branch.
" 2. Then run 'git mergetool' manually from terminal or open vim and run <leader>dvm.
" 3. To accept changes you can write ':diffget N' where N is the number of window with
"    corresponding changes.
nnoremap <leader>dvm :!git mergetool<CR> 

" ----------------------------------------
"
" Git file changes
"
" ----------------------------------------

" Keep track of all changed file after we opened one.
let s:git_changed_files = []

function! s:OpenGitChangedFileFromPopup(id, result)
  if a:result <= 0
    return
  endif
  let file = s:git_changed_files[a:result - 1]
  execute 'edit ' . fnameescape(file)
endfunction

function! GitChangedFilesPopup()
  let s:git_changed_files = systemlist('git diff --name-only')
  if empty(s:git_changed_files)
    echo "No changed files"
    return
  endif
  let display = map(copy(s:git_changed_files), 's:TruncatePath(v:val, 60)')
  call popup_menu(display, {
        \ 'title': 'Changed files',
        \ 'callback': function('s:OpenGitChangedFileFromPopup'),
        \ 'filter': 'popup_filter_menu',
        \ 'mapping': 1,
        \ })
endfunction
nnoremap <leader>dv :call GitChangedFilesPopup()<CR>

" Revert all changes for the current file.
nnoremap <leader>dvr :!git restore %<CR>:e!<CR>

" Show diff for the current file.
function! GitFileDiff()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  let f = substitute(expand('%:p'), root.'/', '', '')
  let original_name = expand('%:t')
  vert new
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  execute 'file HEAD:' . original_name
  execute 'silent! read !git show HEAD:' . f
  " Delete the first line of the HEAD file that might contain
  " an empty line or some metadata.
  1delete
  filetype detect
  diffthis
  wincmd p
  diffthis
endfunction
nnoremap <leader>dvf :call GitFileDiff()<CR>

" ----------------------------------------
"
" File explorer settings
"
" ----------------------------------------

" Open native Vim netrw file explorer.
nnoremap <leader>e :Explore<CR>

" Enable relative line numbers inside netrw so it's easier to jump to the
" specific file/folder.
let g:netrw_bufsettings = 'noma nomod rnu nowrap ro nobl'

" You need to run all these commands from netrw file explorer.
function! NetrwMapping()
  " Mark a file. You need this for further file manipulations like
  " file deletion/moving/copying.
  nmap <buffer> <TAB> mf         
  
  " Unmark all marked files.
  nmap <buffer> <Leader><TAB> mu 
  
  " Current directory under the cursor becomes the target.
  " You need this to mark some directory where you want to
  " move/copy marked files in.
  nmap <buffer> <S-TAB> mt       
  
  " Create a new file.
  nmap <buffer> ff %    

  " Create a new directory.
  nmap <buffer> fd d             
  
  " Edit file/directory name.
  nmap <buffer> fe R            

  " Delete file or empty directory.
  nmap <buffer> fr D             

  " Copy marked files to target directory.
  nmap <buffer> fc mc         

  " After you mark your files you can put the cursor in a directory
  " and this will assign the target directory and copy in one step.
  nmap <buffer> fC mtmc          

  " Move marked files to target directory.
  nmap <buffer> fx mm            
  
  " Same thing as fC but for moving files.
  nmap <buffer> fX mtmm          
  
  " Run external shell command on marked files.
  nmap <buffer> f; mx            
  
  " Bookmark current directory.
  nmap <buffer> fb mb            
  
  " Go to previous bookmarked directory.
  nmap <buffer> fbg gb           
  
  " Remove most recent bookmark.
  nmap <buffer> fbr mB           
  
  " Show a list of marked files.
  nmap <buffer> flm :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR> 
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

" Disable top banner (I in netrw to show back).
let g:netrw_banner = 0

" ----------------------------------------
"
" Opened file settings
"
" ----------------------------------------

" Split window from the current file.
nnoremap <leader>v :Vexplore<CR>

" Increase size of the current split window.
nnoremap <leader>> :vertical resize +10<CR>

" Decrease size of the current split window.
nnoremap <leader>< :vertical resize -10<CR>

" Make all split windows equal size.
nnoremap <leader>= :wincmd =<CR>

" Open a new tab from the current file.
" You can jump to a specific tab with Ngt
" where N is a number of tab.
nnoremap <leader>t :tab split<CR>

" ----------------------------------------
"
" Previously opened files
"
" ----------------------------------------

function! ListFileBuffers()
  let max_items = 10
  let path_max_width = 50
  let buffers = getbufinfo({'buflisted': 1})
  call sort(buffers, {a, b -> b.lastused - a.lastused})
  let items = []
  let filtered = []
  for b in buffers
    if filereadable(b.name)
      call add(filtered, b)
    endif
  endfor
  let filtered = filtered[:max_items - 1]
  for b in filtered
    let path = fnamemodify(b.name, ':.')
    let path = s:TruncatePath(path, path_max_width)
    call add(items, path)
  endfor
  if empty(items)
    echo "No file buffers"
    return
  endif
  call popup_menu(items, {
        \ 'title': 'Previous files',
        \ 'callback': {id, result ->
        \   result > 0 ? execute('buffer ' . filtered[result - 1].bufnr) : 0
        \ }
        \ })
endfunction
command! LsFiles call ListFileBuffers()
nnoremap <leader>? :LsFiles<CR>

" ----------------------------------------
"
" Language specific settings
"
" ----------------------------------------

" You need to install a language server for desired language
" since Vim cannot support all languages out of the box.

" LSP configuration.
" Install LSP plugin:
" 1. mkdir -p ~/.vim/pack/lsp/start
" 2. cd ~/.vim/pack/lsp/start
" 3. git clone https://github.com/prabirshrestha/vim-lsp.git

" Lsp for Rust.
" Install rust-analyzer globally: rustup component add rust-analyzer
" or in any other way that is applicable for your OS.
if executable('rust-analyzer')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'rust-analyzer',
      \ 'cmd': {server_info->['rust-analyzer']},
      \ 'allowlist': ['rust'],
      \ })
endif

" Lsp for JS/TS.
" Install language server globally: npm install -g typescript typescript-language-server.
if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'ts-lsp',
      \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
      \ 'allowlist': ['javascript','javascriptreact','typescript','typescriptreact'],
      \ })
endif

" Go to definition. Place your cursor on variable/function or anything else
" and run this command.
nnoremap gd :LspDefinition<CR>

" Show type information (hover).
nnoremap K :LspHover<CR>

" Code action. For example, if you have a missing import, you can
" put your cursor over it and press <leader>ca and select autoimport option.
nnoremap <leader>ca :LspCodeAction<CR>
" Make the code actions list to be a floating window.
let g:lsp_code_action_ui = 'float'

" Show LSP errors in the current file.
nnoremap <leader>si :e!<CR>:LspDocumentDiagnostics<CR>

" Apply formatting for the current file.
nnoremap <leader>fm :w<CR>:e!<CR>:LspDocumentFormat<CR>

" You can check more LSP specific actions in the vim-lsp plugin documentation.
