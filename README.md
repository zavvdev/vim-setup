# Vim Setup

Minimal setup.

## Prerequisites

1. [Vim](https://www.vim.org/) should be installed.

2. [Git](https://git-scm.com/) should be installed.

3. If you run `vim --version` and don't see `+clipboard`, you need to install the `vim-gtk3`
   package. You can research how to enable it for your specific OS. This is required in order to
   copy text to the OS clipboard with `"+y`.

4. Configuration lives in `~/.vimrc` or `~/.vim/vimrc`.

5. Run `git config --global merge.tool vimdiff` to set vimdiff as the merge tool.

6. Run `git config --global mergetool.keepBackup false` to disable backup files.

7. LSP requires plugin installation. If you want LSP support, see the [LSP section](https://github.com/zavvdev/vim-setup/tree/main?tab=readme-ov-file#lsp). Otherwise, remove the 'Language specific settings' section from your _.vimrc_ file.

## Keybindings

Leader key: `Space`. The Leader key is pressed before a keybinding combination.

### File Explorer

To open the Netrw file explorer from a file, run: `Leader e`.

Run these commands from the file explorer:

1. Create a file: `f f`.

2. Create a directory: `f d`.

3. Edit the name of the file/directory under the cursor: `f e`.

4. Delete the file or empty directory under the cursor: `f r`.

#### Moving Files

Run these commands from the file explorer:

1. Mark a directory as the target: `Shift Tab`. This is required when moving or copying files to that directory.

2. Mark/unmark a file or directory: `Tab`.

3. Unmark all marked files and directories: `Leader Tab`.

4. Copy marked files/directories to the target directory: `f c`.

5. Copy marked files/directories to the directory under the cursor: `f C`.

6. Move marked files/directories to the target directory: `f x`.

7. Move marked files/directories to the directory under the cursor: `f X`.

8. Run a shell command on marked files/directories: `f ;`.
   For example, mark a non-empty directory, use _f ;_, then type _rm -r_ to delete it.

#### Navigation

Run these commands from the file explorer:

1. Bookmark the current directory: `f b`.

2. Remove the most recent bookmark: `f b r`.

3. Go to the previous bookmarked directory: `f b g`.

4. Show a list of marked files: `f l m`.

5. Move up one directory: `-`.

6. Open a file in a new tab: place the cursor on a file/directory and press `t`.

7. Navigate to an open tab by number: `Ngt`, where N is the tab number.

#### Global Search

1. Search in files: `Leader s f`.

2. Search in files by specifying a path: `Leader s p`.

3. Search in files using grep: `Leader s g`, type something, then press Enter.

4. Search for the word under the cursor across all files: `Leader s g c`, then press Enter.

5. Show a list of recently opened files: `Leader ?`.

### File

1. Search for the word under the cursor: `*`.

2. Go to a specific line in the file: `:<line number>`.

3. Scroll down: `Ctrl d`.

4. Scroll up: `Ctrl u`.

5. Copy to clipboard: `" + y`.

6. Add a multi-line prefix: `Leader a a`, add text to the beginning of the first line, `Esc`.

7. Remove a multi-line prefix: `Leader a r`, select all of the lines with prefix in a way that the
last line selection covers all prefix, press `x`.

8. Go to definition: `g d`.

9. Follow the path under the cursor: `g f`.

10. Split vertically: press `v` on a file in the file explorer.

11. Split vertically: `Leader v` from a file.

12. Open the current file in a new tab: `Leader t` from a file.

13. Toggle autocomplete in insert mode: `Shift Tab`.

14. Increase split window width: `Leader >`.

15. Decrease split window width: `Leader <`.

16. Equalize split sizes: `Leader =`.

17. Refresh the current file: `Leader rr`.

### Code Aliases

1. `console.log()` alias: `Ctrl l` from insert mode.

### Git

If a merge has conflicts:

1. Open vim.

2. Press `Leader d v m` to open diffview.

3. Jump to the start of the next change: `]c`.

4. Jump to the start of the previous change: `[c`.

5. Obtain the difference from the other buffer. Place your cursor on the conflict and run: `do`.

6. Put the difference to the other buffer. Place your cursor on the conflict and run: `dp`.

7. Use `:diffget N`, where N is the number of the buffer with the desired changes, to accept those changes.

List uncommitted files:

1. Use `Leader d v` to open a list of files that have been changed but not yet committed.

Diffs:

1. Show diff for the current file: `Leader d v f`.

2. Revert all changes for the current file: `Leader d v r`.

## LSP

This configuration provides LSP support for Rust, JavaScript, and TypeScript. You can see it in `.vimrc` by searching for _Language specific settings_.

Since Vim does not support LSP out of the box for all languages, you need to install LSP for your desired language. You can do this without a plugin manager:

1. `mkdir -p ~/.vim/pack/vendor/start`.

2. `cd ~/.vim/pack/vendor/start`.

3. `git clone https://github.com/prabirshrestha/vim-lsp.git`.

This is how you can install any plugin — simply clone its repository into that directory. You can name "vendor" whatever you like.

How to install LSP for Rust and JS/TS:

1. `rustup component add rust-analyzer`.

2. `npm install -g typescript typescript-language-server`.

For more information about LSP configuration, see [vim-lsp](https://github.com/prabirshrestha/vim-lsp).

**Keybindings**

1. Go to definition: `g d`.

2. Show type information for the word under the cursor (hover): `K`.

3. Show code actions: `Leader c a`.

4. Show LSP errors in the current file: `Leader s i`.

5. Apply formatting: `Leader f m`.

See the vim-lsp plugin documentation for additional actions.

## Other Useful Keybindings

### Cursor Movement

`e` - jump forwards to the end of a word.

`b` - jump backward to the end of a word.

`%` - move the cursor to a matching character (default supported pairs: `()`, `{}`, `[]` — use `:h matchpairs` in Vim for more info).

`0` - jump to the start of the line.

`^` - jump to the first non-blank character of the line.

`$` - jump to the end of the line.

`g_` - jump to the last non-blank character of the line.

`gg` - go to the first line of the document.

`G` - go to the last line of the document.

`}` - jump to the next paragraph (or function/block when editing code).

`{` - jump to the previous paragraph (or function/block when editing code).

### Insert Mode — Inserting/Appending Text

`i` - insert before the cursor.

`I` - insert at the beginning of the line.

`a` - insert (append) after the cursor.

`A` - insert (append) at the end of the line.

`o` - append (open) a new line below the current line.

`O` - append (open) a new line above the current line.

`ea` - insert (append) at the end of the word.

`Ctrl + w` - delete the word before the cursor.

`Ctrl + t` - indent (move right) the line one shiftwidth.

`Ctrl + d` - de-indent (move left) the line one shiftwidth.

`Ctrl + n` - insert the next autocomplete match before the cursor.

`Ctrl + p` - insert the previous autocomplete match before the cursor.

### Editing

`r` - replace a single character.

`R` - replace more than one character until ESC is pressed.

`J` - join the line below to the current one with one space in between.

`cc` - change (replace) the entire line.

`c$` or `C` - change (replace) to the end of the line.

`cw` or `ce` - change (replace) to the end of the word.

`s` - delete the character and substitute text (same as `cl`).

`S` - delete the line and substitute text (same as `cc`).

`u` - undo.

`Ctrl + r` - redo.

`.` - repeat the last command.

### Marking Text (Visual Mode)

`v` - start visual mode; mark lines, then run a command (e.g. `y` to yank).

`V` - start linewise visual mode.

`Ctrl + v` - start visual block mode.

`a(` - a block with `()`.

`a{` - a block with `{}`.

`at` - a block with `<>` tags.

`i(` - inner block with `()`.

`i{` - inner block with `{}`.

`it` - inner block with `<>` tags.

### Visual Commands

`>` - shift text right.

`<` - shift text left.

`y` - yank (copy) marked text.

`d` - delete marked text.

`~` - switch case.

`u` - change marked text to lowercase.

`U` - change marked text to uppercase.

### Marks and Positions

`ma` - set the current position as mark A.

`` `a `` - jump to the position of mark A.

`` `. `` - go to the position of the last change in this file.

### Macros

`qa` - record macro a.

`q` - stop recording the macro.

`@a` - run macro a.

`@@` - rerun the last run macro.

### Cut and Paste

`yy` - yank (copy) a line.

`Nyy` - yank (copy) N lines downward.

`Ny<up|down>` - yank (copy) N lines up or down.

`yw` - yank (copy) characters from the cursor position to the start of the next word.

`yiw` - yank (copy) the word under the cursor.

`y$` or `Y` - yank (copy) to the end of the line.

`p` - put (paste) clipboard contents after the cursor.

`P` - put (paste) before the cursor.

`dd` - delete (cut) a line.

`Ndd` - delete (cut) N lines downward.

`Nd<up|down>` - delete (cut) N lines up or down.

`dw` - delete (cut) characters from the cursor position to the start of the next word.

`:g/{pattern}/d` - delete all lines containing a pattern.

`:g!/{pattern}/d` - delete all lines not containing a pattern.

`d$` or `D` - delete (cut) to the end of the line.

`x` - delete (cut) a character.

### Indent Text

`>>` - indent (move right) the line one shiftwidth.

`<<` - de-indent (move left) the line one shiftwidth.

`>%` - indent a block with `()` or `{}` (cursor on brace).

`<%` - de-indent a block with `()` or `{}` (cursor on brace).

### Exiting

`:w` - write (save) the file without exiting.

`:wq` - write (save) and quit.

`:q` - quit (fails if there are unsaved changes).

`:qa` - quit all (fails if there are unsaved changes).

`:q!` - quit and discard unsaved changes.

`:wqa` - write (save) and quit all tabs.

### Search and Replace

`/pattern` - search for a pattern.

`?pattern` - search backward for a pattern.

`n` - go to the next match.

`N` - go to the previous match.

`:%s/old/new/g` - replace all occurrences of old with new throughout the file.

`:%s/old/new/gc` - replace all occurrences with confirmation.

`:%s/old/new/gi` - replace all occurrences, case-insensitive.

`:%s/old/new/gI` - replace all occurrences, case-sensitive.

`:%s/old/new/gIc` - replace all occurrences, case-sensitive, with confirmation.

---

You can find more Vim commands [here](https://vim.rtorr.com/).
