#######################################################
# Useful functions
#######################################################
# Extracts any archive(s) (if "unp" or "atool" isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf "$archive" ;;
			*.tar.gz) tar xvzf "$archive" ;;
			*.bz2) bunzip2 "$archive" ;;
			*.rar) rar x "$archive" ;;
			*.gz) gunzip "$archive" ;;
			*.tar) tar xvf "$archive" ;;
			*.tbz2) tar xvjf "$archive" ;;
			*.tgz) tar xvzf "$archive" ;;
			*.zip) unzip "$archive" ;;
			*.Z) uncompress "$archive" ;;
			*.7z) 7z x "$archive" ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# Function for creating a new directory and entering it
mcd() {
	mkdir -p "$@" && cd "$@"
}

# Function for git auto commit and push
gcp() {
	read -r -p "Commit message: " commit_msg
	git commit -a -m "$commit_msg"
	git push
}

# Function for rsync copy
cpr() {
	rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
}

# Function for rsync move
mvr() {
	rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# function to check if a command exists
# command_exist() {
# 	command -v "$1" >/dev/null 2>&1
# }
