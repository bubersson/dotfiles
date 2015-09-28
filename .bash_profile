# LS Aliases
alias ..="cd .."
alias ...="cd .. ; cd .."
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git Aliases
alias cdb='git checkout'
alias mkb='git checkout -b'
alias rmb='git branch -D'
alias gb="git branch -av"
alias status="git status -sb"
alias g="git"

# Ip Address
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# Other aliases
alias server="python -m SimpleHTTPServer"
alias rm="rm -i"  # safety first


function parse_git_branch {
    git rev-parse --git-dir > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        git_status="$(git status 2> /dev/null)"
        branch_pattern="^[# ]*On branch ([^${IFS}]*)"
        detached_branch_pattern="# Not currently on any branch"
        remote_pattern="[# ]*Your branch is (.*) of"
        diverge_pattern="[# ]*Your branch and (.*) have diverged"
        untracked_pattern="[# ]*Untracked files:"
        new_pattern="new file:"
        not_staged_pattern="[# ]*Changes not staged for commit"
        to_be_commited="[# ]*Changes to be committed:"


        # changes to be commited (no files to be added)
        if [[ ${git_status}} =~ ${to_be_commited} ]]; then
            state=" •"
        fi

        #files not staged for commit
        if [[ ${git_status}} =~ ${not_staged_pattern} ]]; then
            state=" ⁕"
        fi

        # add an else if or two here if you want to get more specific
        # show if we're ahead or behind HEAD
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
            if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
                remote=" ↑"
            else
                remote=" ↓"
            fi
        fi
        #new files
        if [[ ${git_status} =~ ${new_pattern} ]]; then
            remote=" +"
        fi
        #untracked files
        if [[ ${git_status} =~ ${untracked_pattern} ]]; then
            remote=" ?"
        fi
        #diverged branch
        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
            remote=" ↕"
        fi
        #branch name
        if [[ ${git_status} =~ ${branch_pattern} ]]; then
            branch=${BASH_REMATCH[1]}
        #detached branch
        elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
            branch="NO BRANCH"
        fi

        echo " (${branch}${state}${remote})"
    fi
    return
}

function tree() {
    git log --branches --remotes --tags --graph --oneline --decorate --max-count=${1:-'25'} #default
}

function log() {
    git log --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --max-count=${1:-'25'}
}

function fff() {
    git diff --stat ${1:-'master'}
}

# Create a new directory and enter it
function md() {
	mkdir -p "$@" && cd "$@"
}

export PS1="\[\033[33m\]\u\[\033[35m\]@air3:\[\e[32m\]\$(parse_git_branch) \[\033[36m\]\w\033[0m\n$ "

# LS colors
export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

# Search in history as ^R
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export EDITOR='sbl'
export VISUAL='sbl'








# Settings for bash
# keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups         # no duplicate entries
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
which shopt > /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Tohle automaticky skoci do slozky, nemusim psat 'cd'
shopt -s autocd

# Bash completetion
if [ -d $(brew --prefix)/etc/bash_completion.d ]; then
    . $(brew --prefix)/etc/bash_completion.d/*
fi

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on

# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Immediately add a trailing slash when autocompleting symlinks to directories
set mark-symlinked-directories on

# ctrl left, ctrl right for moving on the readline by word
"\e[1;5C": forward-word
"\e[1;5D": backward-word

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off


