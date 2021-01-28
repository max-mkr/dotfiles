# Dotfiles
Configs syncronisation repository. You can grab my configs for applications or sync.sh bash script.

# Warnings
This script is provided as is, without any warranty (see LICENSE for more). Do not rely solely on the script to do your job. Check what it is doing. It is recomended to test the behaviour on sample files.

# Plug...
*If you see `$ ...` you dont need to type `$`. It only indicates that you are in the terminal.*

The purpose of this script is to copy a list of files in different directories to a list of destinations (can be unique paths).

First copy `sync.sh` to directory with your repository. Then edit `config` variable to include all your config files. Do the same for `repo` variable. `repo` holds target locations in your repository.

Lists need to be same length as each element in `config[i]` will go in location `repo[i]` relative to script path.
Syntax: `var=("item1" "item2" ...)`

Example:
```
config=("$HOME.config/alacritty.yml" "$HOME/.emacs")
repo=("alacritty/alacritty.yml" "emacs/.emacs")
```
Now use `$ ./sync.sh -l` to list supported files. You may get `error: Lists are different length (x-x). Can't sync. Terminating now`. This means that you forgot to match something in `config` to `repo` or vice-versa. If you get a list instead - you are good.
```
$ ./sync.sh -l
0: /home/mkr/.config/alacritty.yml -- alacritty/alacritty.yml
1: /home/mkr/.emacs -- emacs/.emacs
```
# ...and play
There are 2 things that this script can do - copy files around and list avaliable files.
To list files use `-l` Or `-L` The only difference between them is that `-L` requires you to specify which files to list. Put your space separated list into `"` like this: `$ ./sync.sh -L "0 1 5"`. **Counting starts from 0**.
When importing `-i` or exporting `-e` you can use `-v` flag to preview files affected by script and where they will go. Please note that output below only shows pairs of files, not their direction:
```
0: /home/mkr/.config/alacritty/alacritty.yml -- alacritty/alacritty.yml
1: /home/mkr/.emacs -- emacs/.emacs
```
It is this part that tells you where the files are going:
```
Exporting. [config files] -> [this directory]
Do you want to proceed? (y/n)
```
To select specific files you can put their number list (or just one nmber) with `-s`, which has to be at the end. For example: `$ ./sync.sh -evs "0 1 3"`.

By the way all this, but short, can be found in
```
$ ./sync.sh -h
 i - import (this/folder -> config)
 e - export (config -> this/folder)
 v - verbose (prompt before doing)
 s - select by number
 l - list all tracked files
 L - list files by number
 h - display help and exit
```
