# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
#HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=5000
#HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    screen*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

BLACK="\[\033[0;38m\]"
RED="\[\033[0;31m\]"
RED_BOLD="\[\033[01;31m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[0;32m\]"
parse_git_branch () {
  git name-rev HEAD 2> /dev/null | sed 's#HEAD\ \(.*\)# (git::\1)#'
}
parse_svn_branch() {
  svn info 2>/dev/null | sed -ne 's#^Relative URL: ##p'
  #parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk '{print " (svn::"$1")" }'
}
parse_svn_url() {
  svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
parse_svn_repository_root() {
  svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    export PS1='${debian_chroot:+($debian_chroot)}$GREEN\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] [$RED_BOLD\$(parse_git_branch)\$(parse_svn_branch)$BLACK] \$ '
else
    export PS1='${debian_chroot:+($debian_chroot)}$GREEN\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] [$RED_BOLD\$(parse_git_branch)\$(parse_svn_branch)$BLACK] \$ '
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w [\$(parse_git_branch)\$(parse_svn_branch)] \$ '
fi
unset color_prompt force_color_prompt


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen*)
    export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


t_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n $branch ]]; then
    echo -e " «$branch» "
  fi
}

# Ensure that we're in bash, in a byobu environment
if [ -n "$BASH" ]; then
  byobu_prompt_status() { local e=$?; [ $e != 0 ] && echo -e "$e "; }
  [ -n "$BYOBU_CHARMAP" ] || BYOBU_CHARMAP=$(locale charmap 2>/dev/null || echo)
  case "$BYOBU_DISTRO" in
    "Ubuntu")
      # Use Ubuntu colors (grey / aubergine / orange)
      PS1="${debian_chroot:+($debian_chroot)}\[\e[38;5;202m\]\$(byobu_prompt_status)\[\e[38;5;245m\]\u\[\e[00m\]@\[\e[38;5;172m\]\h\[\e[00m\] \[\e[38;5;141m\]\$(parse_git_branch)\$(parse_svn_branch)\[\e[00m\]\[\e[38;5;5m\]\w\[\e[00m\]: "
      export GREP_COLORS="ms=01;38;5;202:mc=01;31:sl=:cx=:fn=01;38;5;132:ln=32:bn=32:se=00;38;5;242"
      export LESS_TERMCAP_mb=$(printf '\e[01;31m')       # enter blinking mode – red
      export LESS_TERMCAP_md=$(printf '\e[01;38;5;180m') # enter double-bright mode – bold light orange
      export LESS_TERMCAP_me=$(printf '\e[0m')           # turn off all appearance modes (mb, md, so, us)
      export LESS_TERMCAP_se=$(printf '\e[0m')           # leave standout mode
      export LESS_TERMCAP_so=$(printf '\e[03;38;5;202m') # enter standout mode – orange background highlight (or italics)
      export LESS_TERMCAP_ue=$(printf '\e[0m')           # leave underline mode
      export LESS_TERMCAP_us=$(printf '\e[04;38;5;139m') # enter underline mode – underline aubergine
    ;;
    *)
      # Use nice colors (green / red / blue)
      PS1="${debian_chroot:+($debian_chroot)}\[\e[31m\]\$(byobu_prompt_status)\[\e[00;32m\]\u\[\e[0m\]@\[\e[00;31m\]\h\[\e[0m\]:\[\e[00;36m\]\w\[\e[0m\]\$ "
    ;;
  esac
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Vagrant Alias
alias v='cd /var/www/Vagrant';
alias d='cd /var/www/docker';
alias vup='vagrant up';
alias vht='vagrant halt';
alias vsh='vagrant ssh';
alias vbu='vagrant box update';

# GIT alias
alias gitpushall='git push && git push --tags';

# clipboard alias 
# http://jetpackweb.com/blog/2009/09/23/pbcopy-in-ubuntu-command-line-clipboard/
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
if [ -f ~/.bash_aliases.local ]; then
    . ~/.bash_aliases.local
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#[ -r /home/david/.byobu/prompt ] && . /home/david/.byobu/prompt   #byobu-prompt#

export EDITOR="/usr/bin/vi"

export PATH="~/.local/bin:~/.composer/vendor/bin:~/bin:${PATH:+:${PATH}}";
alias homestead=~/.composer/vendor/bin/homestead

if [ -f ~/.bash_path.local ]; then
    . ~/.bash_path.local
fi

