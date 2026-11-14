" =============================================================
" Targets Vim 9.1+/9.2
" =============================================================

scriptencoding utf-8

augroup vimrc
    autocmd!
augroup END

" =============================================================
"
" REUSABLE VARIABLES START
"
" =============================================================

let s:popup_list_max_items = 20
let s:popup_list_max_width = 70

" =============================================================
"
" REUSABLE VARIABLES END
"
" =============================================================

" =============================================================
"
" REUSABLE FUNCTIONS START
"
" =============================================================

function! s:TruncatePath(path) abort
	if strchars(a:path) <= s:popup_list_max_width
 		return a:path
 	endif
 	return '…' . strcharpart(a:path, strchars(a:path) - s:popup_list_max_width + 1)
endfunction

function! s:ShowPopupMenu(title, items, callback) abort
	if empty(a:items)
		echo 'No items'
		return
	endif
	call popup_menu(a:items, {
		\ 'title': a:title,
		\ 'minwidth': s:popup_list_max_width,
		\ 'maxwidth': s:popup_list_max_width,
		\ 'maxheight': s:popup_list_max_items,
		\ 'padding': [2,1,1,2],
		\ 'border': [0,0,0,0],
		\ 'callback': a:callback,
		\ 'filter': 'popup_filter_menu',
		\ 'mapping': 1,
        \ 'highlight': 'Pmenu'
		\ })
endfunction

" =============================================================
"
" REUSABLE FUNCTIONS END
"
" =============================================================

" =============================================================
"
" BASIC SETTINGS START
"
" =============================================================

" Setup leader symbol. This is the button that you press
" before using another combo keybinding.
nnoremap <Space> <Nop>
let mapleader = ' '

" ftplugins + indent scripts (commentstring, real indenting,
" formatoptions per language).
filetype plugin indent on

" Syntax highlighting.
syntax enable

" Enable mouse support.
set mouse=a

" For wide terminals. The older protocols can’t report clicks
" past about column 223.
if has('mouse_sgr') | set ttymouse=sgr | endif

" Lets us leave a modified buffer without saving it. The buffer
" stays loaded in the background. We need it for :e other-file
" with unsaved edits, and for anything that touches many files,
" like LSP rename or :cdo. The catch is that we can forget about
" unsaved hidden buffers. Vim still warns on :q, and :wa saves
" them all.
set hidden

" This lets Backspace delete autoindent, join lines when we
" backspace at the start of a line, and delete text from before
" where we entered insert mode. Without it, Backspace stops at
" those boundaries.
set backspace=indent,eol,start

" This highlights the first match while we’re still typing a
" search term, and jumps back if we cancel with Esc.
set incsearch

" This sets how long Vim waits to decide whether an Esc byte
" is a lone Esc key or the start of an escape sequence such
" as an arrow key.
set ttimeout ttimeoutlen=50

set history=200 showcmd ruler scrolloff=5 display=lastline
set nrformats-=octal

" 4-space indentation.
set expandtab tabstop=4 softtabstop=4 shiftwidth=4

" A new line starts with the same indentation as the previous
" one.
set autoindent

" The column where Vim wraps text.
set textwidth=100

" formatoptions is a set of flags controlling auto-wrapping and
" comment handling.
" -t: don’t auto-wrap regular text while typing. This is what
"  stops code from hard-wrapping at 100.
" +c: do auto-wrap comments at textwidth, adding the comment
"  leader on the new line.
" +r/o: continue the comment leader (//, *, #) after Enter in
"  insert mode and after o/O in normal mode.
" +q: allow gq to reflow comments.
" +j: remove the comment leader when we join lines with J.
autocmd vimrc FileType * setlocal formatoptions-=t formatoptions+=croqj

" This turns on spell checking in every window using US English.
set spelllang=en_us
set spell

" With camel, Vim splits camelCase words and checks the parts
" separately, so getUserName is checked as get, User and Name
" and isn’t flagged as one unknown word. It’s wrapped in exists()
" so older Vim versions skip it silently.
if exists('+spelloptions') | set spelloptions=camel | endif

" Highlights the cursor’s line.
set cursorline

" Only the line number is highlighted, not the text.
if exists('+cursorlineopt') | set cursorlineopt=number | endif

" Enable highlight search pattern and smart case search
" sensitivity.
set hlsearch ignorecase smartcase

" Set relative number lines.
set number relativenumber

" Show the matching part of pairs [] {} and ().
set showmatch

" How long Vim waits (in milliseconds) before triggering
" certain idle events.
set updatetime=800

" Saves undo history to ~/.vim/undo.
if has('persistent_undo')
    " expands ~ to the home directory.
    let s:undodir = expand('~/.vim/undo')

    " creates the directory and any missing parents, readable only
    " by you. The permissions matter because undo files hold copies
    " of your old text, which could include secrets you later deleted.
    if !isdirectory(s:undodir) | call mkdir(s:undodir, 'p', 0700) | endif
    let &undodir = s:undodir
    set undofile
endif

" Cursor shape per mode.
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_te = "\e[0 q" . &t_te

" Auto completion alias. Press Shift-Tab in Insert mode to
" view auto completion options. It does not rely on LSP.
inoremap <S-Tab> <C-n>
set complete=.,w,b,u,t

" Manual buffer refresh.
nnoremap <leader>rr <Cmd>call <SID>RefreshPreserveCursor()<CR>
function! s:RefreshPreserveCursor() abort
    if &modified && confirm('Discard unsaved changes?', "&Yes\n&No", 2) != 1
        return
    endif
    let view = winsaveview()
    edit!
    call winrestview(view)
endfunction

" Auto-reload files changed outside Vim. Useful when switching
" between terminal tools, git operations, generators, tests.
set autoread

autocmd vimrc FocusGained,BufEnter * if getcmdwintype() ==# '' | silent! checktime | endif

nnoremap <leader>v :Vexplore<CR>
nnoremap <leader>h :Hexplore<CR>
nnoremap <leader>> :vertical resize +10<CR>
nnoremap <leader>< :vertical resize -10<CR>
nnoremap <leader>= :wincmd =<CR>
nnoremap <leader>t :tab split<CR>

" Quick jump between matched patterns when we search for some
" globally. For example, we search for word 'enum' with
" <Leader>sg and then we can press these in order to jump
" to the next/prev match.
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" This loop enables Vim’s optional bundled plugins. Vim ships
" several plugins as optional packages under pack/dist/opt/ in
" its runtime directory, and they do nothing until we load them.
" packadd! is how we turn them on.
" 
" comment: adds the `gc` operator for toggling comments. `gcc`
"   comments the current line, `gc{motion}` comments a range, and
"   `gc` in visual mode comments the selection.
" 
" matchit: extends % to jump between if/else/end, HTML tags and
"   similar pairs.
" 
" editorconfig: reads .editorconfig files and applies their indent
"   style, indent size and similar settings per buffer. In projects
"   that have one, it will override our 4-space and 2-space defaults.
"
" cfilter: adds :Cfilter and :Lfilter for narrowing the quickfix and
"   location lists by pattern.
" 
" hlyank: briefly flashes the text we just yanked.
for s:pkg in ['comment', 'matchit', 'editorconfig', 'cfilter', 'hlyank']
    if !empty(globpath(&packpath, 'pack/*/opt/' . s:pkg, 0, 1))
        execute 'packadd! ' . s:pkg
    endif
endfor

" =============================================================
"
" BASIC SETTINGS END
"
" =============================================================

" =============================================================
"
" MULTI LINE EDITING START
"
" =============================================================

" Select multiple lines in visual mode and press <leader>aa.
" Then you can add any prefix you want and press Escape.
" To remove prefix select lines in visual mode in a way
" that the last selection captures the whole prefix you
" want to remove. Press <leader>ar which will select
" prefix for each row. Then press x which will remove prefix.
" Can be used for commenting/uncommenting.
xnoremap <leader>aa <Esc>'<0<C-v>'>0I
xnoremap <leader>ar <C-v>

" =============================================================
"
" MULTI LINE EDITING END
"
" =============================================================

" =============================================================
"
" STATUS LINE START
"
" =============================================================

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
function! StatusLineSearchCount() abort
    if !v:hlsearch | return '' | endif
    try
        let sc = searchcount({'maxcount': 999, 'timeout': 20})
    catch
        return ''
    endtry
    if empty(sc) || sc.total == 0 | return '' | endif
    return sc.incomplete ? printf('[%d/>%d]', sc.current, sc.total)
                \ : printf('[%d/%d]', sc.current, sc.total)
endfunction
set statusline+=\ %{StatusLineSearchCount()}

" Setup git branch in status line.
function! s:UpdateGitBranch(bufnr) abort
    let dir = fnamemodify(bufname(a:bufnr), ':p:h')
    if !isdirectory(dir) | let dir = getcwd() | endif
    let out = []
    call job_start(['git', '-C', dir, 'rev-parse', '--abbrev-ref', 'HEAD'], {
        \ 'in_io': 'null', 'err_io': 'null',
        \ 'out_cb': {_, l -> add(out, l)},
        \ 'close_cb': {_ -> s:SetBranch(a:bufnr, get(out, 0, ''))}})
endfunction

function! s:SetBranch(bufnr, branch) abort
    if bufexists(a:bufnr)
        call setbufvar(a:bufnr, 'git_branch', a:branch)
        redrawstatus!
    endif
endfunction
autocmd vimrc BufEnter,DirChanged,FocusGained * call s:UpdateGitBranch(bufnr('%'))
let &statusline .= ' %{empty(get(b:, "git_branch", "")) ? "" : "⎇ " . b:git_branch}'

" =============================================================
"
" STATUS LINE END
"
" =============================================================

" =============================================================
"
" THEME START
"
" =============================================================

" All overrides live in one function, re-applied on
" every :colorscheme (which runs :hi clear and wipes them).
" Defined BEFORE :colorscheme so the first load uses it too.
function! s:Highlights() abort
    highlight CursorLine cterm=bold ctermbg=black
    for g in ['SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal']
        execute 'highlight clear ' . g
        execute 'highlight ' . g . ' term=underline cterm=underline gui=underline'
    endfor
    highlight Normal guibg=#1f2029 ctermbg=235
    highlight StatusLine guibg=#2b2c3a guifg=#939393 ctermbg=17 ctermfg=15
    highlight StatusLineNC guibg=#1d1e27 guifg=#555555 ctermbg=234 ctermfg=240
    
    " Popup window styles.
    highlight Pmenu guibg=#2b2c3a guifg=#939393 ctermbg=17 ctermfg=246
    highlight PmenuSel guibg=#3d3f52 guifg=#ffffff ctermbg=60 ctermfg=15 gui=bold
    highlight PmenuSbar guibg=#1d1e27 ctermbg=234
    highlight PmenuThumb guibg=#555555 ctermbg=240
    
    highlight VertSplit guibg=#1f2029 guifg=#3d3f52 ctermbg=235 ctermfg=60
    
    " Tab line styles.
    highlight TabLineSel guibg=#3a3c4f guifg=#a8a8a8 ctermbg=60 ctermfg=15 gui=bold
    highlight TabLine guibg=#262838 guifg=#6b6b6b ctermbg=236 ctermfg=242
    highlight TabLineFill guibg=#26272f ctermbg=236
    
    highlight GitSignAdd guifg=#50fa7b ctermfg=84 guibg=#1f2029 ctermbg=235
    highlight GitSignChange guifg=#f1fa8c ctermfg=228 guibg=#1f2029 ctermbg=235
    highlight GitSignDelete guifg=#ff5555 ctermfg=203 guibg=#1f2029 ctermbg=235

    highlight link rustCommentLineDoc Comment
endfunction
autocmd vimrc ColorScheme * call s:Highlights()

if has('termguicolors')
    if &term =~# '^\%(screen\|tmux\)'
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
endif

set background=dark
colorscheme habamax

" =============================================================
"
" THEME END
"
" =============================================================

" =============================================================
"
" SEARCH START
"
" =============================================================

if exists('+findfunc')
    let s:filescache = []
    function! s:FindFiles(arg, _) abort
        if empty(s:filescache)
            let s:filescache = systemlist('git ls-files --cached --others --exclude-standard')
            if v:shell_error
                let s:filescache = filter(globpath('.', '**', 1, 1), '!isdirectory(v:val)')
            endif
        endif
        return empty(a:arg) ? s:filescache : matchfuzzy(s:filescache, a:arg, {'limit': 200})
    endfunction
    set findfunc=s:FindFiles
    autocmd vimrc CmdlineEnter : let s:filescache = []
else
    " Set absolute path to be able to search in all sub directories.
    set path+=$PWD/**
endif

" Visual menu for command completion.
set wildmenu

" Controls how command-line completion looks and matches.
" pum: shows the matches in a popup menu, like insert-mode
"   completion, instead of the horizontal wildmenu bar. It
"   still needs wildmenu on.
" fuzzy: matches don’t have to be contiguous or start at the
"   beginning, so :b ctl can match user_controller.ts. Results
"   are ranked by match quality instead of alphabetically, and
"   wildcards like * are taken literally.
set wildoptions=pum,fuzzy

" Controls what each consecutive press of <Tab> does.
" Commas separate presses, and colons combine behaviors within a
" single press.
" 1st press (noselect:lastused): the popup opens, but nothing is selected and
" nothing is inserted into the command line. What we typed stays as
" is, so we can keep typing to narrow the fuzzy matches, and <CR>
" runs exactly what you typed. lastused applies when completing buffer
" names: matches are sorted by most recently used (excluding the
" current buffer) instead of by name or fuzzy score. So :b <Tab> lists
" our most recent buffers first.
" 2nd press and after (full): selects the first match, and further presses
" cycle through the rest.
set wildmode=noselect:lastused,full

" Optional: popup appears as you type:
" autocmd vimrc CmdlineChanged : call wildtrigger()

" 'wildignore' only removes entries from the wildmenu
" after entries have been found. It does not change
" search times.
set wildignore+=*/node_modules/*,*/dist/*,*/.git/*,*/build/*,*.pyc,*.o

" Make file search case insensitive.
set wildignorecase

" Search for a file.
" This setting should contain space after :find so you
" don't need to specify it manually after <leader>sf.
nnoremap <leader>sf :find<Space>

" Search for files with entering path.
" This setting should contain space after :e so you
" don't need to specify it manually after <leader>sp.
nnoremap <leader>sp :e<Space>

" Automatically add file extensions when searching
" for files.
set suffixesadd+=.py,.js,.jsx,.ts,.tsx,.c,.h,.cpp,.json,.rs,.css,.scss

" Set grep search tool to 'git grep'.
set grepprg=git\ grep\ -n\ --column\ -I
set grepformat=%f:%l:%c:%m,%f:%l:%m

" Search for sub string in all project files.
nnoremap <leader>sg :silent grep! -- ""<Left>

" Search for current word under the cursor in all
" project files.
nnoremap <leader>sc :silent grep! -w -- <C-r><C-w><CR>:redraw!<CR>

" Search for exact word (user-typed) in all project files.
nnoremap <leader>sw :silent grep! -w -- ""<Left>

autocmd vimrc QuickFixCmdPost [^l]* ++nested cwindow
autocmd vimrc QuickFixCmdPost l* ++nested lwindow

" Put the cursor on a word and use * to highlight all exact
" word matches in the current buffer.
nnoremap * /\C\<\V<C-r><C-w>\><CR>

" Replace the exact occurrences of the word under the cursor
" in the current file with confirmation.
nnoremap <leader>rw :%s/\C\<\V<C-r><C-w>\>//gc<Left><Left><Left>

" =============================================================
"
" SEARCH END
"
" =============================================================

" =============================================================
"
" GIT START
"
" =============================================================

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
function! s:GitRoot() abort
    let dir = expand('%:p:h')
    if !isdirectory(dir) | let dir = getcwd() | endif
    return get(systemlist('git -C ' . shellescape(dir) . ' rev-parse --show-toplevel'), 0, '')
endfunction

function! s:OpenGitChangedFileFromPopup(id, result) abort
    if a:result > 0
        execute 'edit ' . fnameescape(s:git_root . '/' . s:git_changed_files[a:result - 1])
    endif
endfunction

" Staged + unstaged + untracked, all root-relative.
function! GitChangedFilesPopup() abort
    let s:git_root = s:GitRoot()
    if empty(s:git_root) | echo 'Not in git repository' | return | endif
    let r = shellescape(s:git_root)
    let changed = systemlist('git -C ' . r . ' diff --name-only HEAD')
    if v:shell_error | let changed = [] | endif " repo without commits
    let s:git_changed_files = uniq(sort(changed +
                \ systemlist('git -C ' . r . ' ls-files --others --exclude-standard')))
    let display = map(copy(s:git_changed_files), {_, v -> s:TruncatePath(v)})
    call s:ShowPopupMenu('Changed files', display, function('s:OpenGitChangedFileFromPopup'))
endfunction
nnoremap <leader>dl <Cmd>call GitChangedFilesPopup()<CR>

function! s:GitRestore() abort
    if confirm('Discard all changes to ' . expand('%:t') . '?', "&Yes\n&No", 2) != 1
        return
    endif
    let out = system('git -C ' . shellescape(expand('%:p:h')) . ' restore -- ' . shellescape(expand('%:t')))
    if v:shell_error | echoerr out | return | endif
    edit!
endfunction

" Revert all changes for the current file.
nnoremap <leader>dvr <Cmd>call <SID>GitRestore()<CR>

" Show diff for the current file.
function! GitFileDiff() abort
    let dir = expand('%:p:h')
    let lines = systemlist('git -C ' . shellescape(dir) . ' show HEAD:./' . shellescape(expand('%:t')))
    if v:shell_error | echo 'Not tracked in HEAD' | return | endif
    let ft = &filetype
    let srcwin = win_getid()
    vertical new
    setlocal buftype=nofile bufhidden=wipe noswapfile
    execute 'silent file ' . fnameescape('HEAD:' . expand('#:t') . ' [' . bufnr('%') . ']')
    call setline(1, lines)
    let &l:filetype = ft
    let b:lsp_diagnostics_enabled = 0
    setlocal nomodifiable readonly
    diffthis
    execute 'autocmd vimrc BufWipeout <buffer> call win_execute(' . srcwin . ', "diffoff")'
    wincmd p
    diffthis
endfunction
nnoremap <leader>dvf <Cmd>call GitFileDiff()<CR>
set diffopt+=vertical,algorithm:histogram,indent-heuristic,linematch:60

" -----------------------------------------------------------
" CHANGED FILES END
" -----------------------------------------------------------

" -----------------------------------------------------------
" GIT GUTTER START
" -----------------------------------------------------------

for [s:n, s:t] in [['GitSignAdd', '+'], ['GitSignChange', '~'], ['GitSignDelete', '- ']]
    if empty(sign_getdefined(s:n))
        call sign_define(s:n, {'text': s:t, 'texthl': s:n})
    endif
endfor

function! s:GitSignsUpdate(bufnr) abort
    if getbufvar(a:bufnr, '&buftype') !=# '' || getbufvar(a:bufnr, '&modified')
        return
    endif
    let path = fnamemodify(bufname(a:bufnr), ':p')
    if !filereadable(path) | return | endif
    let out = []
    call job_start(['git', '-C', fnamemodify(path, ':h'), 'diff', '--no-color',
        \ '--no-ext-diff', '-U0', 'HEAD', '--', fnamemodify(path, ':t')], {
        \ 'in_io': 'null', 'err_io': 'null',
        \ 'out_cb': {_, l -> add(out, l)},
        \ 'close_cb': {_ -> s:GitSignsPlace(a:bufnr, out)}})
endfunction

function! s:GitSignsPlace(bufnr, diff) abort
    if !bufexists(a:bufnr) || getbufvar(a:bufnr, '&modified') | return | endif
    call sign_unplace('GitSigns', {'buffer': a:bufnr})
    let signs = []
    for l in a:diff
        " @@ -a[,b] +c[,d] @@ ; missing count = 1
        let m = matchlist(l, '^@@ -\d\+\%(,\(\d\+\)\)\? +\(\d\+\)\%(,\(\d\+\)\)\? @@')
        if empty(m) | continue | endif
        let old = m[1] ==# '' ? 1 : str2nr(m[1])
        let start = str2nr(m[2])
        let new = m[3] ==# '' ? 1 : str2nr(m[3])
        if new == 0 " pure deletion: after line 'start' (may be 0)
            call add(signs, {'buffer': a:bufnr, 'group': 'GitSigns',
                \ 'name': 'GitSignDelete', 'lnum': max([1, start]), 'priority': 5})
            continue
        endif
        for i in range(new)
            call add(signs, {'buffer': a:bufnr, 'group': 'GitSigns',
                \ 'name': i < old ? 'GitSignChange' : 'GitSignAdd',
                \ 'lnum': start + i, 'priority': 5})
        endfor
    endfor
    call sign_placelist(signs)
endfunction

autocmd vimrc BufReadPost,BufWritePost,FocusGained,ShellCmdPost * call s:GitSignsUpdate(bufnr('%'))
set signcolumn=yes

" -----------------------------------------------------------
" GIT GUTTER END
" -----------------------------------------------------------

" =============================================================
"
" GIT END
"
" =============================================================

" =============================================================
"
" FILE EXPLORER START
"
" =============================================================

" Open native Vim netrw file explorer.
nnoremap <leader>e :Explore<CR>

" Enable relative line numbers inside netrw so it's easier
" to jump to the specific file/folder.
let g:netrw_bufsettings = 'noma nomod rnu nowrap ro nobl'

" Disable top banner (I in netrw to show back).
let g:netrw_banner = 0

" Copy or move marked files/dirs to a path you type
" (with completion).
" If the destination already has an item with the same name,
" prompts to overwrite, rename, skip, or cancel the whole
" operation.
function! s:MoveOrCopy(is_move) abort
    let marked = netrw#Expose('netrwmarkfilelist')
    if type(marked) != v:t_list || empty(marked)
        echo 'No files marked (press <Tab> to mark files/dirs first)'
        return
    endif
    let dest = input(a:is_move ? 'Move to: ' : 'Copy to: ', b:netrw_curdir . '/', 'dir')
    redraw
    if empty(dest) | echo 'Cancelled' | return | endif
    let dest = substitute(fnamemodify(expand(dest), ':p'), '/$', '', '')
    if !isdirectory(dest) | call mkdir(dest, 'p') | endif
    let errors = []
    let done = 0
    for f in marked
        let src = substitute(f =~# '^/' ? f : b:netrw_curdir . '/' . f, '/$', '', '')
        let target = dest . '/' . fnamemodify(src, ':t')
        if getftype(target) !=# ''
            let c = confirm(fnamemodify(target, ':t') . ' already exists.',
                \ "&Overwrite\n&Rename\n&Skip\n&Cancel all", 3)
            if c == 0 || c == 4 | break | endif
            if c == 3 | call add(errors, src . ' -> skipped') | continue | endif
            if c == 2
                let nn = input('New name: ', fnamemodify(target, ':t'))
                redraw
                if empty(nn) | call add(errors, src . ' -> skipped') | continue | endif
                let target = dest . '/' . nn
            else
                " Remove first, or cp/mv would nest a directory inside the existing one.
                call delete(target, 'rf')
            endif
        endif
        let out = system((a:is_move ? 'mv ' : 'cp -R ') . shellescape(src) . ' ' . shellescape(target))
        if v:shell_error
            call add(errors, src . ' failed: ' . substitute(out, '\n', ' ', 'g'))
        else
            let done += 1
        endif
    endfor
    normal mu
    execute "normal \<Plug>NetrwRefresh"
    if done > 0
        echo (a:is_move ? 'Moved ' : 'Copied ') . done . ' item(s) to ' . dest
    endif
    if !empty(errors)
        echohl ErrorMsg | echo join(errors, "\n") | echohl None
    endif
endfunction

" You need to run all these commands from netrw file explorer.
function! s:NetrwMapping() abort
    " Mark a file. You need this for further file manipulations like
    " file deletion/moving/copying.
    nmap <buffer> <Tab> mf

    " Unmark all marked files.
    nmap <buffer> <Leader><Tab> mu

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
    nnoremap <buffer> fc <Cmd>call <SID>MoveOrCopy(0)<CR>

    " Move marked files/directories. You'll be prompted to select
    " a destination.
    nnoremap <buffer> fx <Cmd>call <SID>MoveOrCopy(1)<CR>

    " Run external shell command on marked files.
    nmap <buffer> f; mx
endfunction
autocmd vimrc FileType netrw call s:NetrwMapping()

" Tree-style directory listing instead of the flat list.
" let g:netrw_liststyle = 3

" Sets the split width percentage for Vexplore/Hexplore so
" it doesn't default to 50%.
" let g:netrw_winsize = 25

" =============================================================
"
" FILE EXPLORER END
"
" =============================================================

" =============================================================
"
" VISITED FILES START
"
" Opens a popup with all previously visited files.
"
" =============================================================

function! ListFileBuffers() abort
    let bufs = filter(getbufinfo({'buflisted': 1}), 'filereadable(v:val.name)')
    call sort(bufs, {a, b -> b.lastused - a.lastused})
    let display = map(copy(bufs), {_, b -> s:TruncatePath(fnamemodify(b.name, ':~:.'))})
    call s:ShowPopupMenu('Previous files', display, {id, result ->
        \ result > 0 ? execute('buffer ' . bufs[result - 1].bufnr) : 0})
endfunction
command! LsFiles call ListFileBuffers()
nnoremap <leader>? :LsFiles<CR>

" =============================================================
"
" VISITED FILES END
"
" =============================================================

" =============================================================
"
" LSP START
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
" =============================================================

let g:lsp_use_native_client = 1

" Make the code actions list to be a floating window.
let g:lsp_code_action_ui = 'float'

let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_format_sync_timeout = 1000
let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0

" LSP autocompletion.
set completeopt=menu,menuone,noselect
" Native auto-popup; 'o' asks the LSP omnifunc.
set autocomplete complete=o,.,w,b autocompletedelay=150

function! s:OnLspBufferEnabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    " Go to definition. Place your cursor on variable/function
    " or anything else and use `gd`.
    nmap <buffer> gd <plug>(lsp-definition)

    " Check references to the current word under the cursor.
    nmap <buffer> gr <plug>(lsp-references)

    " Show type information for a token under the cursor (hover).
    nmap <buffer> K <plug>(lsp-hover)

    " Code action. For example, if you have a missing import,
    " you can put your cursor over it and press <leader>ca
    " and select autoimport option.
    nmap <buffer> <leader>ca <plug>(lsp-code-action)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [d <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]d <plug>(lsp-next-diagnostic)

    " Show LSP errors in the current file.
    nnoremap <buffer> <leader>si <Cmd>LspDocumentDiagnostics<CR>
    
    " Apply formatting for the current file.
    nnoremap <buffer> <leader>fm <Cmd>LspDocumentFormatSync<CR>
    
    inoremap <buffer> <C-Space> <C-x><C-o>
    inoremap <buffer> <C-@> <C-x><C-o>
endfunction
autocmd vimrc User lsp_buffer_enabled call s:OnLspBufferEnabled()
inoremap <expr> <Tab> pumvisible() ? "\<C-y>" : "\<Tab>"

" Walk up from a dir looking for a relative path (no 'path'
" syntax, so spaces/commas are safe).
function! s:FindUp(dir, rel) abort
    let d = a:dir
    while 1
        if !empty(glob(d . '/' . a:rel, 1, 1)) | return d | endif
        let p = fnamemodify(d, ':h')
        if p ==# d | return '' | endif
        let d = p
    endwhile
endfunction

" Returns the directory of the file in the current buffer, and falls
" back to Vim’s current working directory if that directory doesn’t exist.
function! s:BufDir() abort
    let d = fnamemodify(lsp#utils#get_buffer_path(), ':p:h')
    return isdirectory(d) ? d : getcwd()
endfunction

" Finds the project root for the current buffer by looking upward for marker
" files or directories, and returns it as a file:// URI. If nothing is found,
" it returns the current working directory as a URI.
function! s:RootUri(markers) abort
    for m in a:markers
        let r = s:FindUp(s:BufDir(), m)
        if !empty(r) | return lsp#utils#path_to_uri(r) | endif
    endfor
    return lsp#utils#path_to_uri(getcwd())
endfunction

" -----------------------------------------------------------
" RUST START
" -----------------------------------------------------------

" If Rust errors vanish after the update, that is vim-lsp #1695.
" Pin vim-lsp to a0762a6 until it is fixed.
if executable('rust-analyzer')
    autocmd vimrc User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {_ -> ['rust-analyzer']},
        \ 'root_uri': {_ -> s:RootUri(['Cargo.toml'])},
        \ 'allowlist': ['rust'],
        \ })
endif
autocmd vimrc FileType rust inoremap <buffer> <expr> <C-p>
    \ pumvisible() ? "\<C-p>" : "println!()\<Left>"

" -----------------------------------------------------------
" RUST END
" -----------------------------------------------------------

" -----------------------------------------------------------
" JS/TS START
" Server chosen per project
" TS <= 6 ships lib/tsserver.js -> typescript-language-server.
" TS 7 (native, July 2026) has none -> its own tsc --lsp.
" -----------------------------------------------------------
function! s:TsInfo() abort
    let root = s:FindUp(s:BufDir(), 'node_modules/typescript/package.json')
    if empty(root) | return {'kind': 'classic', 'root': ''} | endif
    let lib = root . '/node_modules/typescript/lib/'
    if filereadable(lib . 'tsserver.js') | return {'kind': 'classic', 'root': root} | endif
    let tsc = root . '/node_modules/.bin/tsc'
    return executable(tsc) ? {'kind': 'native', 'root': root, 'tsc': tsc}
        \ : {'kind': 'classic', 'root': root}
endfunction

let s:ts_ft = ['javascript', 'javascriptreact', 'typescript', 'typescriptreact']

" An empty cmd list means "do not start" (check :LspStatus).
autocmd vimrc User lsp_setup call lsp#register_server({
    \ 'name': 'ts-native',
    \ 'cmd': {_ -> s:TsInfo().kind ==# 'native' ? [s:TsInfo().tsc, '--lsp', '--stdio'] : []},
    \ 'root_uri': {_ -> s:RootUri(['tsconfig.json', 'package.json'])},
    \ 'allowlist': s:ts_ft,
    \ })

if executable('typescript-language-server')
    autocmd vimrc User lsp_setup call lsp#register_server({
        \ 'name': 'ts-classic',
        \ 'cmd': {_ -> s:TsInfo().kind ==# 'classic' ? ['typescript-language-server', '--stdio'] : []},
        \ 'root_uri': {_ -> s:RootUri(['tsconfig.json', 'package.json'])},
        \ 'allowlist': s:ts_ft,
        \ })
endif
autocmd vimrc FileType javascript,typescript,javascriptreact,typescriptreact
    \ setlocal tabstop=2 softtabstop=2 shiftwidth=2
    \ | inoremap <buffer> <expr> <C-l> pumvisible() ? "\<C-l>" : "console.log()\<Left>"

" -----------------------------------------------------------
" JS/TS END
" -----------------------------------------------------------

" -----------------------------------------------------------
" PYTHON START
" -----------------------------------------------------------

if executable('pylsp')
    autocmd vimrc User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {_ -> ['pylsp']},
        \ 'root_uri': {_ -> s:RootUri(['pyproject.toml', 'setup.py', '.git'])},
        \ 'allowlist': ['python'],
        \ 'workspace_config': {'pylsp': {'plugins': {
        \ 'pycodestyle': {'enabled': v:false},
        \ 'pyflakes': {'enabled': v:false},
        \ 'mccabe': {'enabled': v:false},
        \ 'autopep8': {'enabled': v:false},
        \ 'yapf': {'enabled': v:false}}}},
        \ })
endif

" -----------------------------------------------------------
" PYTHON END
" -----------------------------------------------------------

" -----------------------------------------------------------
" MAKEFILE START
" -----------------------------------------------------------

autocmd vimrc FileType make setlocal noexpandtab

" -----------------------------------------------------------
" MAKEFILE END
" -----------------------------------------------------------

" =============================================================
"
" LSP END
"
" =============================================================
