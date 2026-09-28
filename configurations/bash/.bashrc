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

[ -f ~/.bash_prompt ] && . ~/.bash_prompt

# enable color support of ls and also add handy aliases
# NB: --color=auto (non "always"): colora sul terminale, non sporca le pipe
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

alias clearrecentfiles='rm ~/.local/share/recently-used.xbel'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# GIT alias
alias gitpushall='git push && git push --tags';
# NB: gli alias git (co/br/ci/st) vivono in ~/.gitconfig, impostati una tantum:
#   git config --global alias.co checkout   (ecc.)

# clipboard alias
# Wayland-nativo se disponibile (26.04: GNOME solo Wayland), fallback xclip
if [ "$XDG_SESSION_TYPE" = "wayland" ] && command -v wl-copy >/dev/null; then
    alias pbcopy='wl-copy'
    alias pbpaste='wl-paste'
else
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

alias open='xdg-open'

# Kubernetes
if command -v kubectl >/dev/null; then
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -F __start_kubectl k
fi

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

export EDITOR="/usr/bin/vi"
export COMPOSER_PATH="$HOME/.config/composer/"
export PATH="${COMPOSER_PATH}vendor/bin:$HOME/bin${PATH:+:${PATH}}"

if [ -f ~/.bash_path.local ]; then
    . ~/.bash_path.local
fi

if [ -f /var/code/projects/wpvip/.bash_vip.local ]; then
    . /var/code/projects/wpvip/.bash_vip.local
fi

alias lzd='lazydocker'
alias docknpmi='docker run -it --rm -v "$PWD":/app -w /app node:lts npm install'
alias docknpms='docker run -it --rm -v "$PWD":/app -w /app node:lts npm run start'
alias docknpmb='docker run -it --rm -v "$PWD":/app -w /app node:lts bash'

alias dockcleancontainers='docker rm $(docker ps -q --filter "status=exited")'
alias dockcleanimages='docker rmi -f $(docker images -f "dangling=true" -q)'
alias dockcleanvolumes='docker volume rm $(docker volume ls -q | grep -Ei "(\w){64}")'

alias docksystemdf='docker system df -v'

# @see https://vitux.com/how-to-see-the-terminal-commands-you-use-most-often-in-debian-10/
# history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head -n 25

alias p="local-env-project"
alias pd=". local-env-project-directory"
alias cli="local-env-cli"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# docker-sync
# https://docker-sync.readthedocs.io/en/latest/getting-started/installation.html
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# circleci completion bash
[ -f "$HOME/.circleci/.bash_completion_circleci" ] && . "$HOME/.circleci/.bash_completion_circleci"

# laravel sails
# @see https://laravel.com/docs/10.x/sail#configuring-a-shell-alias
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

alias phpcs='phpcs  --error-severity=1 --warning-severity=8 --ignore=*/build/*.js'

alias beep='echo -e "\a"'
alias beep2='tput bel'
alias beepog='paplay /usr/share/sounds/freedesktop/stereo/bell.oga'
alias beepsox1='play -n synth 0.1 sine 880 vol 0.5'
alias beepsox2='play -n synth pl G2 pl B2 pl D3 pl G3 pl D4 pl G4 delay 0 .05 .1 .15 .2 .25 remix - fade 0 4 .1 norm -1'

export GCM_CREDENTIAL_STORE="secretservice"

# PYENV
if command -v pyenv >/dev/null 2>&1 || [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"
    command -v pyenv >/dev/null 2>&1 && eval "$(pyenv virtualenv-init -)"
fi

# Lando
export PATH="$HOME/.lando/bin${PATH+:$PATH}" #landopath

command -v zoxide >/dev/null && eval "$(zoxide init bash)"
