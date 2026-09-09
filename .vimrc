" -----------------------------------------------------------
"
" REUSABLE VARIABLES START
"
" -----------------------------------------------------------

let s:popup_list_max_items = 20
let s:popup_list_max_width = 70

" -----------------------------------------------------------
"
" REUSABLE VARIABLES END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" REUSABLE FUNCTIONS START
"
" -----------------------------------------------------------

function! s:TruncatePath(path)
  if strlen(a:path) <= s:popup_list_max_width
    return a:path
  endif
  return '…' . strpart(a:path, strlen(a:path) - s:popup_list_max_width + 1)
endfunction

function! s:ShowPopupMenu(title, items, callback)
  if empty(a:items)
    echo "No items"
    return
  endif
  call popup_menu(a:items, {
        \ 'title': a:title,
        \ 'minwidth': s:popup_list_max_width,
        \ 'maxwidth': s:popup_list_max_width,
        \ 'padding': [2,1,1,2],
        \ 'border': [0,0,0,0],
        \ 'callback': a:callback,
        \ 'filter': 'popup_filter_menu',
        \ 'mapping': 1,
        \ })
endfunction

" -----------------------------------------------------------
"
" REUSABLE FUNCTIONS END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" BASIC SETTINGS START
"
" -----------------------------------------------------------

" Disable compatibility with vi editor in order to use
" modern Vim features.
set nocompatible

" Setup leader symbol. This is the button that you press
" before using another combo keybinding.
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

" How long Vim waits (in milliseconds) before triggering
" certain idle events.
set updatetime=800

" Setup cursor appearance for different modes.
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"

" Auto completion alias. Press Shift-Tab in Insert mode to
" view auto completion options. It does not rely on LSP.
inoremap <S-Tab> <C-n>
set complete=.,w,b,u,t

" Refresh without cursor reset.
nnoremap <leader>rr :call <SID>RefreshPreserveCursor()<CR>
function! s:RefreshPreserveCursor()
    let view = winsaveview()
    edit!
    call winrestview(view)
endfunction

" Refresh buffer on save.
" Use it if for some reason LSP errors
" persist after you fixed them.
augroup reload_preserve_cursor
  autocmd!
  autocmd BufWritePost * call <SID>RefreshPreserveCursor()
augroup END

" Auto-reload files changed outside Vim
" Useful when switching between terminal tools, git operations,
" generators, tests.
set autoread
augroup auto_checktime
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

" Split window vertically from the current file.
nnoremap <leader>v :Vexplore<CR>

" Split window horizontally from the current file.
nnoremap <leader>h :Hexplore<CR>

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

" -----------------------------------------------------------
"
" BASIC SETTINGS END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" MULTI LINE EDITING START
"
" -----------------------------------------------------------

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

" -----------------------------------------------------------
"
" MULTI LINE EDITING END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" STATUS LINE START
"
" -----------------------------------------------------------

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
let &statusline .= ' %{empty(get(b:, "git_branch", "")) ? "" : "⎇ " . get(b:, "git_branch")}'

" -----------------------------------------------------------
"
" STATUS LINE END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" THEME SETTINGS START
"
" -----------------------------------------------------------

" Enable color themes.
if !has('gui_running')
	set t_Co=256
endif

" Enable true colors support.
set termguicolors

" Set theme.
colorscheme habamax

" Set background type.
set background=dark

" Remove color from spelling mistake words and make them
" default color and underlined.
 augroup SpellColorFix
 autocmd!
     autocmd ColorScheme * highlight! clear SpellBad
     autocmd ColorScheme * highlight! clear SpellCap
     autocmd ColorScheme * highlight! clear SpellRare
     autocmd ColorScheme * highlight! clear SpellLocal
     autocmd ColorScheme * highlight! SpellBad
        \ term=underline cterm=underline gui=underline ctermfg=NONE
        \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
     autocmd ColorScheme * highlight! SpellCap
        \ term=underline cterm=underline gui=underline ctermfg=NONE
        \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
     autocmd ColorScheme * highlight! SpellRare
        \ term=underline cterm=underline gui=underline ctermfg=NONE
        \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
     autocmd ColorScheme * highlight! SpellLocal
        \ term=underline cterm=underline gui=underline ctermfg=NONE
        \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
 augroup END
 highlight! clear SpellBad
 highlight! SpellBad
    \ term=underline cterm=underline gui=underline ctermfg=NONE
    \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
 highlight! SpellCap
    \ term=underline cterm=underline gui=underline ctermfg=NONE
    \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
 highlight! SpellRare
    \ term=underline cterm=underline gui=underline ctermfg=NONE
    \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE
 highlight! SpellLocal
    \ term=underline cterm=underline gui=underline ctermfg=NONE
    \ ctermbg=NONE guifg=NONE guibg=NONE guisp=NONE

" Override the background color.
highlight Normal guibg=#1f2029 ctermbg=235

" Override status line background color for active window.
highlight StatusLine guibg=#2b2c3a guifg=#939393 ctermbg=17 ctermfg=15

" Override status line background color for inactive window.
highlight StatusLineNC guibg=#1d1e27 guifg=#555555 ctermbg=234 ctermfg=240

" Popup window styles
highlight Pmenu guibg=#2b2c3a guifg=#939393 ctermbg=17 ctermfg=246
highlight PmenuSel guibg=#3d3f52 guifg=#ffffff ctermbg=60 ctermfg=15 gui=bold
highlight PmenuSbar guibg=#1d1e27 ctermbg=234
highlight PmenuThumb guibg=#555555 ctermbg=240

highlight VertSplit guibg=#1f2029 guifg=#3d3f52 ctermbg=235 ctermfg=60

" Tab line styles
highlight TabLineSel  guibg=#3a3c4f guifg=#a8a8a8 ctermbg=60 ctermfg=15 gui=bold
highlight TabLine     guibg=#262838 guifg=#6b6b6b ctermbg=236 ctermfg=242
highlight TabLineFill guibg=#26272f ctermbg=236

" -----------------------------------------------------------
"
" THEME SETTINGS END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" SEARCH START
"
" -----------------------------------------------------------

" Set absolute path to be able to search in all
" sub directories.
set path+=$PWD/**

" Visual menu for command completion.
set wildmenu

" 'wildignore' only removes entries from the wildmenu
" after entries have been found. It does not change
" search times.
set wildignore+=**/node_modules/**,**/dist/**,**/.git/**,**/build/**,*.pyc,*.o

" Make file search case insensitive.
set wildignorecase

" Search for a file.
" This setting should contain space after :find so you
" don't need to specify it manually after <leader>sf.
nnoremap <leader>sf :find 

" Search for files with entering path.
" This setting should contain space after :e so you
" don't need to specify it manually after <leader>sp.
nnoremap <leader>sp :e 

" Automatically add file extensions when searching
" for files.
set suffixesadd+=.py,.js,.jsx,.ts,.tsx,.c,.h,.cpp,.json,.rs,.css,.scss

" Set grep search tool to 'git grep'.
set gp=git\ grep\ -n

" Search for sub string in all project files.
nnoremap <leader>sg :grep ""<Left>

" Search for current word under the cursor in all
" project files.
nnoremap <leader>sgc :grep! -w -- <C-R><C-W>

" Search for exact word (user-typed) in all project files.
nnoremap <leader>sgw :grep! -w -- ""<Left>

" Just press Enter after performing grep search and it
" will automatically run :copen
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" Put the cursor on a word and use * to highlight all exact
" word matches in the current buffer.
nnoremap * /\C\<\V<C-r><C-w>\><CR>

" Replace the exact occurrences of the word under the cursor
" in the current file with confirmation.
nnoremap <leader>rw :%s/\C\<\V<C-r><C-w>\>//gc<Left><Left><Left>

" -----------------------------------------------------------
"
" SEARCH END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" GIT START
"
" -----------------------------------------------------------

" -----------------------------------------------------------
" MERGE CONFLICTS START
" -----------------------------------------------------------

" 1. Merge branch into target branch.
" 2. Then run 'git mergetool' manually from terminal or open
"    vim and run <leader>dvm.
" 3. To accept changes you can write ':diffget N' where N is
"    the number of window with corresponding changes.
nnoremap <leader>dvm :!git mergetool<CR> 

" -----------------------------------------------------------
" MERGE CONFLICTS END
" -----------------------------------------------------------

" -----------------------------------------------------------
" CHANGED FILES START
" -----------------------------------------------------------

" Keep track of all changed file after we opened one.
let s:git_changed_files = []
let s:git_root = ''

function! s:OpenGitChangedFileFromPopup(id, result)
  if a:result <= 0
    return
  endif
  let file = s:git_changed_files[a:result - 1]
  execute 'edit ' . fnameescape(s:git_root . '/' . file)
endfunction

function! GitChangedFilesPopup()
  let s:git_changed_files = systemlist('git diff --name-only')
  let s:git_root = get(systemlist('git rev-parse --show-toplevel'), 0, '')
  if empty(s:git_changed_files)
    echo "No changed files"
    return
  endif
  let filtered = s:git_changed_files[:s:popup_list_max_items - 1]
  let display = map(copy(filtered), {_, v -> s:TruncatePath(v)})
  call s:ShowPopupMenu('Changed files', display, function('s:OpenGitChangedFileFromPopup'))
endfunction
nnoremap <leader>dv :call GitChangedFilesPopup()<CR>

" Revert all changes for the current file.
nnoremap <leader>dvr :!git restore %<CR>:e!<CR>

" Show diff for the current file.
function! GitFileDiff()
  let root = get(systemlist('git rev-parse --show-toplevel'), 0, '')
  if empty(root)
    echo "Not in git repository"
    return
  endif
  
  let f = substitute(expand('%:p'), root . '/', '', '')
  let cur_syntax = &syntax
  
  vert new
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  execute 'file ' . fnameescape('HEAD:' . f)
  execute 'silent! read !git show HEAD:' . shellescape(f)
  1delete
  
  if !empty(cur_syntax)
    execute 'setlocal syntax=' . cur_syntax
  endif
  
  let b:lsp_diagnostics_enabled = 0
  if exists('*lsp#disable_diagnostics_for_buffer')
    call lsp#disable_diagnostics_for_buffer(bufnr('%'))
  endif
  
  setlocal nomodifiable readonly
  diffthis
  wincmd p
  diffthis
endfunction
nnoremap <leader>dvf :call GitFileDiff()<CR>

" -----------------------------------------------------------
" CHANGED FILES END
" -----------------------------------------------------------

" -----------------------------------------------------------
" CHANGED LINES START
" Show changed lines in the left gutter.
" -----------------------------------------------------------

" Define the sign symbols shown in the gutter. Guards
" prevent redefining them if vimrc is re-sourced while
" they already exist.
if empty(sign_getdefined('GitSignAdd'))
  sign define GitSignAdd    text=+ texthl=GitSignAdd
endif
if empty(sign_getdefined('GitSignChange'))
  sign define GitSignChange text=~ texthl=GitSignChange
endif
if empty(sign_getdefined('GitSignDelete'))
  sign define GitSignDelete text=- texthl=GitSignDelete
endif

" Set gutter symbol colors for the initial load.
highlight GitSignAdd    guifg=#50fa7b ctermfg=84  guibg=#1f2029 ctermbg=235
highlight GitSignChange guifg=#f1fa8c ctermfg=228 guibg=#1f2029 ctermbg=235
highlight GitSignDelete guifg=#ff5555 ctermfg=203 guibg=#1f2029 ctermbg=235

" Re-apply colors whenever the color scheme changes,
" since colorscheme commands reset all highlight groups.
autocmd ColorScheme * highlight GitSignAdd    guifg=#50fa7b ctermfg=84  guibg=#1f2029 ctermbg=235
autocmd ColorScheme * highlight GitSignChange guifg=#f1fa8c ctermfg=228 guibg=#1f2029 ctermbg=235
autocmd ColorScheme * highlight GitSignDelete guifg=#ff5555 ctermfg=203 guibg=#1f2029 ctermbg=235

function! s:UpdateGitSigns()
  let bufnr    = bufnr('%')
  let filepath = expand('%:p')

  " Clear all previously placed signs for this buffer
  " before re-computing.
  call sign_unplace('GitSigns', {'buffer': bufnr})

  " Skip non-file buffers (e.g. netrw, help) and files
  " outside a git repo.
  if empty(filepath) || !filereadable(filepath)
    return
  endif
  if empty(finddir('.git', fnamemodify(filepath, ':h') . ';'))
    return
  endif

  " Get the unified diff between HEAD and the working copy.
  let diff = systemlist('git diff HEAD -- ' . shellescape(filepath))
  if empty(diff)
    return
  endif

  " State variables for walking the diff hunk by hunk.
  
  " whether we are currently inside a hunk
  let in_hunk    = 0
  
  " current line number in the new file
  let cur_line   = 0
  
  " first line of the current hunk in the new file
  let hunk_start = 0
  
  " line numbers of added lines collected in the hunk
  let hunk_adds  = []
  
  " count of deleted lines in the hunk
  let hunk_dels  = 0

  " Append a sentinel hunk header so the last real hunk
  " is always flushed.
  for line in (diff + ['@@ @@'])
    if line =~# '^@@'
      " Flush the previous hunk: classify each added line
      " as either a Change (it has a paired deletion) or
      " a pure Add.
      if in_hunk && (!empty(hunk_adds) || hunk_dels > 0)
        let mods = min([len(hunk_adds), hunk_dels])
        for i in range(len(hunk_adds))
          let sname = i < mods ? 'GitSignChange' : 'GitSignAdd'
          call sign_place(0, 'GitSigns', sname, bufnr, {'lnum': hunk_adds[i]})
        endfor
        " If there were more deletions than additions, mark
        " the hunk start line with a Delete sign (the deleted
        " lines have no new-file line).
        if hunk_dels > len(hunk_adds)
          call sign_place(0, 'GitSigns', 'GitSignDelete', bufnr, {'lnum': max([1, hunk_start])})
        endif
      endif

      " Parse the new-file start line from the @@
      " header, e.g. '@@ -1,4 +3,7 @@'.
      let m = matchlist(line, '^@@ -\d\+\%(,\d*\)\? +\(\d\+\)\%(,\d*\)\? @@')
      if !empty(m)
        let in_hunk    = 1
        let cur_line   = str2nr(m[1])
        let hunk_start = cur_line
        let hunk_adds  = []
        let hunk_dels  = 0
      endif

    elseif in_hunk
      " Walk each diff line: '+' is an addition, '-' is a
      " deletion, ' ' is context (unchanged) — all advance
      " the new-file line counter except deletions, which
      " have no corresponding line in the new file.
      if line[0] ==# '+'
        call add(hunk_adds, cur_line)
        let cur_line += 1
      elseif line[0] ==# '-'
        let hunk_dels += 1
      elseif line[0] ==# ' '
        let cur_line += 1
      endif
    endif
  endfor
endfunction

" Refresh signs whenever the buffer is entered, saved, or
" the cursor rests. timer_start(0, ...) defers the call
" to after the current event completes, avoiding any flicker
" or interference with other autocmds.
augroup GitSigns
  autocmd!
  autocmd BufEnter,BufWritePost,CursorHold,CursorHoldI *
        \ call timer_start(0, {-> s:UpdateGitSigns()})
augroup END

" Keep sign column always visible
" Prevents text shifting left/right when Git signs appear/disappear.
set signcolumn=yes

" -----------------------------------------------------------
" CHANGED LINES END
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" GIT END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" FILE EXPLORER START
"
" -----------------------------------------------------------

" Open native Vim netrw file explorer.
nnoremap <leader>e :Explore<CR>

" Enable relative line numbers inside netrw so it's easier
" to jump to the specific file/folder.
let g:netrw_bufsettings = 'noma nomod rnu nowrap ro nobl'

" Copy or move marked files/dirs to a path you type
" (with completion).
" If the destination already has an item with the same name,
" prompts to overwrite, rename, skip, or cancel the whole
" operation.
function! s:MoveOrCopy(is_move)
  let l:marked = netrw#Expose("netrwmarkfilelist")
  if empty(l:marked)
    echo "No files marked (press <Tab> to mark files/dirs first)"
    return
  endif

  let l:dest = input(a:is_move ? 'Move to: ' : 'Copy to: ', b:netrw_curdir . '/', 'dir')
  redraw
  if empty(l:dest)
    echo "Cancelled (no destination given)"
    return
  endif
  if !isdirectory(l:dest)
    call mkdir(l:dest, 'p')
  endif
  let l:dest = substitute(fnamemodify(l:dest, ':p'), '/$', '', '')

  let l:cmd = a:is_move ? 'mv' : 'cp -r'
  let l:errors = []
  let l:copied = 0

  for f in l:marked
    " Normalize to a full path: if netrw gave us a bare filename,
    " prefix it with the current netrw directory.
    let l:src = f
    if l:src !~# '^/'
      let l:src = b:netrw_curdir . '/' . l:src
    endif
    let l:src = substitute(l:src, '/$', '', '')
    let l:basename = fnamemodify(l:src, ':t')

    let l:target = l:dest . '/' . l:basename

    " Check for a name conflict at the destination.
    if isdirectory(l:target) || filereadable(l:target)
      let l:choice = confirm(l:basename . ' already exists in destination.',
            \ "&Overwrite\n&Rename\n&Skip\n&Cancel all", 3)
      if l:choice == 0 || l:choice == 4
        echo "Cancelled remaining operations"
        break
      elseif l:choice == 3
        call add(l:errors, l:src . ' -> skipped (already exists)')
        continue
      elseif l:choice == 2
        let l:newname = input('New name: ', l:basename)
        redraw
        if empty(l:newname)
          call add(l:errors, l:src . ' -> skipped (no name given)')
          continue
        endif
        let l:target = l:dest . '/' . l:newname
      endif
      " choice == 1 (Overwrite) falls through and uses the original l:target
    endif

    let l:full_cmd = l:cmd . ' ' . shellescape(l:src) . ' ' . shellescape(l:target)
    let l:output = system(l:full_cmd)
    if v:shell_error != 0
      call add(l:errors, l:src . ' failed: ' . substitute(l:output, '\n', ' ', 'g'))
    else
      let l:copied += 1
    endif
  endfor

  normal mu
  edit!

  if l:copied > 0
    echo (a:is_move ? 'Moved ' : 'Copied ') . l:copied . ' item(s) to ' . l:dest
  endif
  if !empty(l:errors)
    echohl ErrorMsg
    echo join(l:errors, "\n")
    echohl None
  endif
endfunction

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
  " Commented out since moved to MoveOrCopy.
  " nmap <buffer> <S-TAB> mt

  " Create a new file.
  nmap <buffer> ff %    

  " Create a new directory.
  nmap <buffer> fd d             
  
  " Edit file/directory name.
  nmap <buffer> fe R            

  " Delete file/directory.
  nmap <buffer> fr D             

  " Copy marked files to target directory.
  " Commented out because default netrw moves just
  " a contents of directories but not dirs itself.
  " Migrated to MoveOrCopy.
  " nmap <buffer> fc mc

  " Move marked files to target directory.
  " Commented out for consistency with MoveOrCopy.
  " nmap <buffer> fx mm

  " Copy marked files/directories. You'll be prompted to select
  " a destination.
  nmap <buffer> fc :call <SID>MoveOrCopy(0)<CR>

  " Move marked files/directories. You'll be prompted to select
  " a destination.
  nmap <buffer> fx :call <SID>MoveOrCopy(1)<CR>

  " Run external shell command on marked files.
  nmap <buffer> f; mx            
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

" Disable top banner (I in netrw to show back).
let g:netrw_banner = 0

" Tree-style directory listing instead of the flat list.
" let g:netrw_liststyle = 3

" Sets the split width percentage for Vexplore/Hexplore so
" it doesn't default to 50%.
" let g:netrw_winsize = 25

" -----------------------------------------------------------
"
" FILE EXPLORER END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" VISITED FILES START
"
" Opens a popup with all previously visited files.
"
" -----------------------------------------------------------

function! ListFileBuffers()
  let buffers = getbufinfo({'buflisted': 1})
  call sort(buffers, {a, b -> b.lastused - a.lastused})
  let items = []
  for b in buffers
    if filereadable(b.name)
      call add(items, b)
    endif
  endfor
  let filtered = items[:s:popup_list_max_items - 1]
  let display = map(copy(filtered), {_, b -> s:TruncatePath(fnamemodify(b.name, ':.'))})
  call s:ShowPopupMenu('Previous files', display, {id, result ->
        \ result > 0 ? execute('buffer ' . filtered[result - 1].bufnr) : 0
        \ })
endfunction
command! LsFiles call ListFileBuffers()
nnoremap <leader>? :LsFiles<CR>

" -----------------------------------------------------------
"
" VISITED FILES END
"
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" LANGUAGE SPECIFIC START
"
" You need to install a language server for desired language
" since Vim cannot support all languages out of the box.
"
" LSP configuration.
" Install LSP plugin:
" 1. mkdir -p ~/.vim/pack/lsp/start
" 2. cd ~/.vim/pack/lsp/start
" 3. git clone https://github.com/prabirshrestha/vim-lsp.git
"
" You can check more LSP specific actions in the vim-lsp
" plugin documentation.
"
" -----------------------------------------------------------

" Go to definition. Place your cursor on variable/function
" or anything else and use `gd`.
nnoremap gd :LspDefinition<CR>

" Show type information (hover).
nnoremap K :LspHover<CR>

" Code action. For example, if you have a missing import,
" you can put your cursor over it and press <leader>ca
" and select autoimport option.
nnoremap <leader>ca :LspCodeAction<CR>

" Make the code actions list to be a floating window.
let g:lsp_code_action_ui = 'float'

" Show LSP errors in the current file.
nnoremap <leader>si :e!<CR>:LspDocumentDiagnostics<CR>

" Apply formatting for the current file.
nnoremap <leader>fm :w<CR>:e!<CR>:LspDocumentFormat<CR>

" Disable LSP diagnostics while in insert mode.
let g:lsp_diagnostics_echo_cursor = 0
let g:lsp_diagnostics_float_cursor = 0

" Disable code action indicator that appears on the left
" side of the line (A>).
let g:lsp_document_code_action_signs_enabled = 0

" LSP autocompletion.
set omnifunc=lsp#omni#complete
set completeopt=menu,menuone,noselect

" Trigger completion (Ctrl + x).
inoremap <C-x> <C-x><C-o>

" Confirm selection safely with Tab.
inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

" -----------------------------------------------------------
" RUST START
" -----------------------------------------------------------

" Install rust-analyzer globally:
" `rustup component add rust-analyzer` or in any other way
" that is applicable for your OS.
if executable('rust-analyzer')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'rust-analyzer',
      \ 'cmd': {server_info->['rust-analyzer']},
      \ 'allowlist': ['rust'],
      \ })
endif

" Ctrl + p alias for `println!()` macro.
inoremap <C-p> println!()<Left>

" Three slashes comment block. Make it look like a
" default comment color.
highlight link rustCommentLineDoc Comment

" -----------------------------------------------------------
" RUST END
" -----------------------------------------------------------

" -----------------------------------------------------------
" JS/TS START
" -----------------------------------------------------------

" Install language server globally:
" `npm install -g typescript typescript-language-server`
if executable('typescript-language-server')
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'ts-lsp',
      \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
      \ 'allowlist': ['javascript','javascriptreact','typescript','typescriptreact'],
      \ })
endif

" Use 2 spaces for JS/TS and their JSX variants.
autocmd FileType javascript,typescript,javascriptreact,typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Ctrl + l alias for `console.log()`
inoremap <C-l> console.log()<Left>

" -----------------------------------------------------------
" JS/TS END
" -----------------------------------------------------------

" -----------------------------------------------------------
" PYTHON START
" -----------------------------------------------------------

" Install language server globally:
" `pip install 'python-lsp-server[all]'`
"
" Add this after allowlist if you want to disable default
" pylsp linter rules in case you use something else like ruff.
"\ 'workspace_config': {
"\     'pylsp': {
"\         'plugins': {
"\             'pycodestyle': {'enabled': v:false},
"\             'pyflakes': {'enabled': v:false},
"\             'mccabe': {'enabled': v:false},
"\             'autopep8': {'enabled': v:false},
"\             'yapf': {'enabled': v:false},
"\         }
"\     }
"\ }
if executable('pylsp')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {
        \     'pylsp': {
        \         'plugins': {
        \             'pycodestyle': {'enabled': v:false},
        \             'pyflakes': {'enabled': v:false},
        \             'mccabe': {'enabled': v:false},
        \             'autopep8': {'enabled': v:false},
        \             'yapf': {'enabled': v:false},
        \         }
        \     }
        \ }
        \ })
endif

" -----------------------------------------------------------
" PYTHON END
" -----------------------------------------------------------

" -----------------------------------------------------------
" MAKEFILE START
" -----------------------------------------------------------

" Use tabs since required.
autocmd FileType make setlocal noexpandtab

" -----------------------------------------------------------
" MAKEFILE END
" -----------------------------------------------------------

" -----------------------------------------------------------
"
" LANGUAGE SPECIFIC END
"
" -----------------------------------------------------------
