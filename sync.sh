# lists of files to sync
# must be same length
config=("$HOME/.config/alacritty/alacritty.yml"
	"$HOME/.config/i3/config"
	"$HOME/.config/i3/kb-layout.sh"
	"$HOME/.emacs")


repo=("alacritty/alacritty.yml"
      "i3/config"
      "i3/kb-layout.sh"
      "emacs/.emacs")

# affix is appended to backup names
affix="~"

if [ ${#config[@]} = ${#repo[@]} ]
then
    length=${#config[@]}
else
    echo "error: Lists are different length (${#config[@]}-${#repo[@]}). Can't sync"
    echo "Terminating now."
    exit 1
fi

setaction()
{
    if [ "$ACTION" == "none" ]
    then	
	ACTION=$options
	if [ "$ACTION" == "L" ]
	then
	    ACTION="l"
	fi
    else
	echo "error: Conflicting arguments specifed."
	echo "Terminating now."
	exit 1
    fi
}

ACTION="none"
SELECT="all"
VERBOSE=false

# options:
# i - import (git -> repoination)
# e - export (repoination -> git)
# v - verbose (prompt before doing)
# s - select by number
# l - list tracked files
# L - list files by number

while getopts ":ievs:L:l" options
do
    case "${options}" in
	i) setaction
	   ;;
	e) setaction
	   ;;
	v) VERBOSE=true
	   ;;
	s) SELECT="${OPTARG}"
	   ;;
	l) setaction
	   ;;
	L) setaction
	   SELECT="${OPTARG}"
	   ;;
    esac
done

verbose_warning()
{
    echo "$verbose_msg"
    echo "Do you want to proceed? (y/n)"
    local answer="n"
    
    while read answer
    do
	case "$answer" in
	    y) break
	       ;;
	    n) echo "Terminating now."
	       exit 0
	       ;;
	    *) echo "Please answer y or n."
	       ;;
	esac
    done
}

showFilePair()
{
    if [[ -v position ]]
    then
	echo "${config[$position]} -- ${repo[$position]}"
    fi
}

import_files()
{
    local verbose_msg="Importing. [this directory] -> [config files]"
    if [ "$VERBOSE" == true ]
    then
	list_files
	verbose_warning
    fi

    if [ "$SELECT" == "all" ]
    then
	for ((i=0; i<length; i++))
	do
	    cp ${repo[$i]} $(pwd)/${config[$i]}
	done
    else
	for i in $SELECT
	do
	    cp ${repo[$i]} $(pwd)/${config[$i]}
	done
    fi
}

export_files()
{
    local verbose_msg="Exporting. [config files] -> [this directory]"
    if [ "$VERBOSE" == true ]
    then
	list_files
	verbose_warning
    fi

    if [ "$SELECT" == "all" ]
    then
	for ((i=0; i<length; i++))
	do
	    cp ${config[$i]} $(pwd)/${repo[$i]}
	done
    else
	for i in $SELECT
	do
	    cp ${config[$i]} $(pwd)/${repo[$i]}
	done
    fi
}

list_files()
{
    if [ "$SELECT" == "all" ]
    then
	for ((i=0; i<length; i++))
	do
	    position=$i
	    showFilePair
	done
    else
	for i in $SELECT
	do
	    position=$i
	    showFilePair
	done
    fi
}

case "$ACTION" in
    i) import_files
       ;;
    e) export_files
       ;;
    l) list_files
       ;;
esac

if [ $ACTION != "none" ]
then
    echo "Done."
fi
exit 0
