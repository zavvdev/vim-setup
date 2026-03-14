# Vim Setup

No plugins used

## Prerequisites

1. [Vim](https://www.vim.org/) should be installed.

2. If you type `vim --version` and don't see `+clipboard` then you need to install `vim-gtk3` package in your system if you're on Linux.

3. Configuration lives in `~/.vimrc` or `~/.vim/vimrc`.

4. Run `git config --global merge.tool vimdiff` to assign merge tool to vimdiff.

5. Run `git config --global mergetool.keepBackup false` to disable backup files.

## Keybindings

1. Leader key: `Space`

2. Enter insert mode: `a`

3. Enter visual mode: `v`

### File system

1. Create file: `f f`

2. Create directory: `f d`

3. Edit file/directory name: `f e`

4. Delete file or empty directory: `f r`

#### Moving files

1. Mark directory as target: `Shift Tab`. This is needed for moving/copying files to that target

2. Mark file: `Tab`

3. Unmark all marked files: `Leader Tab`

4. Copy marked files to target directory: `f c`

5. Copy marked files to directory under the cursor: `f C`

6. Move marked files to target directory: `f x`

7. Moved marked files to directory under the cursor: `f X`

8. Run shell command on marked files: `f ;`. For example, mark non-empty directory, use _f ;_ and type _rm -r_ to delete the directory

#### Navigation

1. Bookmark current directory: `f b`

2. Remove most recent bookmark: `f b r`

3. Go to previous bookmarked directory: `f b g`

4. Show list of marked files: `f l m`

5. Change directory to current under cursor: `c d`

6. Move one directory above: `-`

7. Open file tree: `Leader e`

#### Global Search

1. Search in files: `Leader s f`

2. Search in by path: `Leader s p`

3. Search in files by grep: `Leader s f g` then press Enter

4. Show list of recently opened files: `Leader ? Tab`

5. Open previous recently opened file: `Leader ,`

6. Open next recently opened file: `Leader .`

#### File

1. Replace in file: `:%s/<find>/<replace>`.
   - `:%s/<find>/<replace>/gc` - replace global with confirmation
   - `:%s/<find>/<replace>/gi` - replace global case insensitive
   - `:%s/<find>/<replace>/gI` - replace global case sensitive
   - `:%s/<find>/<replace>/gIc` - replace global case sensitive with confirmation

2. Search for pattern in file: `?`

3. Search for word under the cursor: `*`

4. Go to specific line in file: `:<line number>`

5. Go to the very top of the file: `g g`

6. Go to the very bottom of the file: `G`

7. Scroll down: `Ctrl d`

8. Scroll up: `Ctrl u`

9. Undo: `u`

10. Re-do: `Ctrl r`

11. Go to the end of the line: `$`

12. Got to the start of the line: `^`

13. Go to the closed/start bracket/paren/tag of the bracket/pare/tag under cursor: `%`

14. Move line/lines of code forward: `> >`

15. Move line/lines of code backward: `< <`

16. Copy to vim buffer: `y`

17. Paste from vim buffer: `p`

18. Copy to clipboard: `" + y`

19. Add multiline prefix: `Leader a a, add text to the beggining of the first line, Esc`

20. Remove multiline prefix: `Leader a r, select prefix, x`

21. Hover over variable/function for showing details: `K` (probably works for C lang only)

22. Go to definition: `g d`

23. Follow path: `g f`

24. Split vertically: `v`

### Git Merge Conflicts

If merge has conflicts:

1. Open vim

2. Press `d v c` to open diffview

3. Use `:diffget N` where N is the number of screen with specific changes to accept that changes.
