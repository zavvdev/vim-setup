# Vim Setup

Minimal setup.

## Prerequisites

1. [Vim](https://www.vim.org/) should be installed.

2. [Git](https://git-scm.com/) should be installed.

3. If you type `vim --version` and don't see `+clipboard` then you need to install `vim-gtk3`
   package in your system if you're on Linux. You can research how to enable it on your specific
   OS. You need this in order to be able to copy text into OS clipboard with `"+y`.

4. Configuration lives in `~/.vimrc` or `~/.vim/vimrc` file.

5. Run `git config --global merge.tool vimdiff` to assign merge tool to vimdiff.

6. Run `git config --global mergetool.keepBackup false` to disable backup files.

7. LSP requires plugin installation, so if you want LSP support, check [LSP section](https://github.com/zavvdev/vim-setup/tree/main?tab=readme-ov-file#lsp). If you don't want to support LSP, then remove 'Language specific settings' section in _.vimrc_ file.

## Keybindings

Leader key: `Space`. Leader is the button that you press before using keybindings combo.

### File explorer.

In order to open Netrw file explorer from file run: `Leader e`.

Run these commands from file explorer:

1. Create file: `f f`.

2. Create directory: `f d`.

3. Edit file/directory name under the cursor: `f e`.

4. Delete file or empty directory under the cursor: `f r`.

#### Moving files

Run these commands from file explorer:

1. Mark directory as target: `Shift Tab`. This is needed for moving/copying files to that target.

2. Mark/unmark file/directory: `Tab`.

3. Unmark all marked files/directories: `Leader Tab`.

4. Copy marked files/directories to target directory: `f c`.

5. Copy marked files/directories to directory under the cursor: `f C`.

6. Move marked files/directories to target directory: `f x`.

7. Moved marked files/directories to directory under the cursor: `f X`.

8. Run shell command on marked files/directories: `f ;`.
   For example, mark non-empty directory, use _f ;_ and type _rm -r_ to delete the directory.

#### Navigation

Run these commands from file explorer:

1. Bookmark current directory: `f b`.

2. Remove most recent bookmark: `f b r`.

3. Go to previous bookmarked directory: `f b g`.

4. Show list of marked files: `f l m`.

5. Change directory to current under cursor: `c d`.

6. Move one directory above: `-`.

7. Open file in a new tab: Place cursor on file/directory press `t`.

8. Navigate to opened tab by number: `Ngt` where N is a tab number.

#### Global Search

1. Search in files: `Leader s f`.

2. Search in files by entering path: `Leader s p`.

3. Search in files by grep: `Leader s g`, type something then press Enter.

4. Search current word under the cursor in all files: `Leader s g c` then press Enter.

5. Show list of recently opened files: `Leader ?`.

#### File

1. Search for word under the cursor: `*`.

2. Go to specific line in file: `:<line number>`.

3. Scroll down: `Ctrl d`.

4. Scroll up: `Ctrl u`.

5. Copy to clipboard: `" + y`.

6. Add multi line prefix: `Leader a a`, add text to the beginning of the first line, `Esc`.

7. Remove multi line prefix: `Leader a r`, select prefix, `x`.

8. Go to definition: `g d`.

9. Follow path under the cursor: `g f`.

10. Split vertically: `v` on file in file explorer.

11. Split vertically: `Leader v` from file.

12. Open current file in a new tab: `Leader t` from file.

13. Toggle auto complete in insert mode: `Shift Tab`.

14. Increase split window width: `Leader >`.

15. Decrease split window width: `Leader <`.

16. Equalize split size: `Leader =`.

17. Refresh current file: `Leader rr`.

### Code aliases

1. `console.log()` alias: `Ctrl l` from insert mode.

### Git

If merge has conflicts:

1. Open vim.

2. Press `Leader d v m` to open diffview.

3. Jump to start of next change: `]c`.

4. Jump to start of previous change: `[c`.

5. Obtain a difference from other buffer. Place your cursor on the conflict and run: `do`.

6. Put difference to other buffer. Place your cursor on the conflict and run: `dp`.

7. Use `:diffget N` where N is the number of screen with specific changes to accept that changes.

List uncommited files:

1. Use `Leader d v` to open the list of files that have been changed but not commited yet.

Diffs:

1. Show diff for the current file: `Leader d v f`.

2. Revert all changes for the current file: `Leader d v r`.

## LSP

This configuration provide LSP support for Rust, JavaScript and TypeScript. You can see it in `.vimrc` file by searching for _Language specific settings_.

Since LSP is not supported by Vim out of the box for all languages, you need to install LSP for your
desired language. You can do it without plugin manager:

1. `mkdir -p ~/.vim/pack/vendor/start`.

2. `cd ~/.vim/pack/vendor/start`.

3. `git clone https://github.com/prabirshrestha/vim-lsp.git`.

This is basically how you can install any plugin by just cloning repository to that directory. You can name "vendor" however you want.

How to install LSP for Rust and JS/TS:

1. `rustup component add rust-analyzer`.

2. `npm install -g typescript typescript-language-server`.

For more information about LSP configuration see [vim-lsp](https://github.com/prabirshrestha/vim-lsp).

**Keybindings**

1. Go to definition: `g d`.

2. Show type information for the word under the cursor (hover): `K`.

3. Show code actions: `Leader c a`.

4. Show lsp errors in current file: `Leader s i`.

5. Apply formatting: `Leader f m`.

You can check vim-lsp plugin if you want more actions.

## Other useful keybindings

### Cursor movement

`e` - jump forwards to the end of a word.

`b` - jump backward to the end of a word.

`%` - move cursor to matching character (default supported pairs: '()', '{}', '[]' - use :h matchpairs in vim for more info).

`0` - jump to the start of the line.

`^` - jump to the first non-blank character of the line.

`$` - jump to the end of the line.

`g_` - jump to the last non-blank character of the line.

`gg` - go to the first line of the document.

`G` - go to the last line of the document.

`}` - jump to next paragraph (or function/block, when editing code).

`{` - jump to previous paragraph (or function/block, when editing code).

### Insert mode - inserting/appending text

`i` - insert before the cursor.

`I` - insert at the beginning of the line.

`a` - insert (append) after the cursor.

`A` - insert (append) at the end of the line.

`o` - append (open) a new line below the current line.

`O` - append (open) a new line above the current line.

`ea` - insert (append) at the end of the word.

`Ctrl + w` - delete word before the cursor during insert mode.

`Ctrl + t` - indent (move right) line one shiftwidth during insert mode.

`Ctrl + d` - de-indent (move left) line one shiftwidth during insert mode.

`Ctrl + n` - insert (auto-complete) next match before the cursor during insert mode.

`Ctrl + p` - insert (auto-complete) previous match before the cursor during insert mode.

### Editing

`r` - replace a single character.

`R` - replace more than one character, until ESC is pressed.

`J` - join line below to the current one with one space in between.

`cc` - change (replace) entire line.

`c$` or `C` - change (replace) to the end of the line.

`cw` or `ce` - change (replace) to the end of the word.

`s` - delete character and substitute text (same as cl).

`S` - delete line and substitute text (same as cc).

`u` - undo.

`Ctrl + r` - redo.

`.` - repeat last command.

`Ctrl v`, `$`, `A`, add something at the end, `Esc` - append to the end of multiple lines.

### Marking text (visual mode)

`v` - start visual mode, mark lines, then do a command (like y-yank).

`V` - start linewise visual mode.

`Ctrl + v` - start visual block mode.

`a(` - a block with ().

`a{` - a block with {}.

`at` - a block with <> tags.

`i(` - inner block with ().

`i{` - inner block with {}.

`it` - inner block with <> tags.

### Visual commands

`>` - shift text right.

`<` - shift text left.

`y` - yank (copy) marked text.

`d` - delete marked text.

`~` - switch case.

`u` - change marked text to lowercase.

`U` - change marked text to uppercase.

### Marks and positions

`ma` - set current position for mark A.

**`a** - jump to position of mark A.

**`.** - go to the position of the last change in this file.

`g,` - go to newer position in change list.

`g;` - go to older position in change list.

### Macros

`qa` - record macro a.

`q` - stop recording macro.

`@a` - run macro a.

`@@` - rerun last run macro.

### Cut and paste

`yy` - yank (copy) a line.

`Nyy` - yank (copy) N lines down.

`Ny<up|down>` - yank (copy) N lines up or down.

`yw` - yank (copy) the characters of the word from the cursor position to the start of the next word.

`yiw` - yank (copy) word under the cursor.

`y$` or `Y` - yank (copy) to end of line.

`p` - put (paste) the clipboard after cursor.

`P` - put (paste) before cursor.

`dd` - delete (cut) a line.

`Ndd` - delete (cut) N lines down.

`Nd<up|down>` - delete (cut) N lines up or down.

`dw` - delete (cut) the characters of the word from the cursor position to the start of the next word.

`:g/{pattern}/d` - delete all lines containing pattern.

`:g!/{pattern}/d` - delete all lines not containing pattern.

`d$ or D` - delete (cut) to the end of the line.

`x` - delete (cut) character.

### Indent text

`>>` - indent (move right) line one shiftwidth.

`<<` - de-indent (move left) line one shiftwidth.

`>%` - indent a block with () or {} (cursor on brace).

`<%` - de-indent a block with () or {} (cursor on brace).

### Exiting

`:w` - write (save) the file, but don't exit.

`:wq` - write (save) and quit.

`:q` - quit (fails if there are unsaved changes).

`:qa` - quit all (fails if there are unsaved changes)

`:q!` - quit and throw away unsaved changes.

`:wqa` - write (save) and quit on all tabs.

### Search and replace

`/pattern` - search for pattern.

`?pattern` - search backward for pattern.

`n` - go forward in matched search result.

`N` - go backward in matched search result.

`:%s/old/new/g` - replace all old with new throughout file.

`:%s/old/new/gc` - replace all old with new throughout file with confirmations.

`:%s/old/new/gi` - replace global case insensitive.

`:%s/old/new/gI` - replace global case sensitive.

`:%s/old/new/gIc` - replace global case sensitive with confirmation.
