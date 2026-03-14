" Disable compatibility with vi editor
" in order to use modern Vim features
set nocompatible

" Setup leader symbol
nnoremap <SPACE> <Nop>
let mapleader=" "

" Show type definitions (probably works with C and some others)
nnoremap K :ptag <cword><CR>

" Search
" Vim has native feature for following path.
" Simply put the cursor on path and press gf.
" If you want to go to definition in the same file
" vim also has native feature for it. Put cursor on
" variable/function etc and press gd.
set path+=$PWD/**      " Search all subdirectories
set wildmenu           " Visual menu for command completion
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

" Files navigation
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

" Disable top banner
let g:netrw_banner = 0

" Setup cursor appearance for different modes
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" Cosmetic setup
colorscheme morning
syntax enable
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set number
set autoindent
set updatetime=800
set relativenumber
set showmode
set laststatus=2                    " Always show status line
set statusline=%f\                  " Show filename
set statusline+=%h%w%m%r\           " Show flags
set statusline+=%=                  " Align right
set statusline+=%(%l,%c%V\ %=\ %P%) " Show ruler

" Netrw setup start
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
" Netrw setup end

" Git branch in status line
function! GitBranch()
  let branch = system("git -C " . expand('%:p:h') . " branch --show-current 2>/dev/null")
  return substitute(branch, '\n', '', '')
endfunction

set statusline+=\ [%{GitBranch()}]
