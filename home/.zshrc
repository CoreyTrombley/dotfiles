# Path to your oh-my-zsh installation.
export ZSH=/Users/coreytrombley/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="kolo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

setopt interactivecomments
set -k

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

function current_branch() {
  local ref
  ref=$($_omz_git_git_cmd symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$($_omz_git_git_cmd rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function plat() {
  version=${2:=0.0.12}
  case "$1" in
      '')
          echo "up|status|pvp|help"
          ;;
      up)
          if [ -z "$version" ]; then
            # display usage if no parameters given
            echo "you must pass a release version number ex: 0.0.5"
          else
            echo "------------- starting vagrant up ----------------"
            cd ~/unified/platform-ui
            RELEASE_VERSION=$version vagrant up
            cd ../platform-communique
            vagrant up
            echo "------------- finished vagrant up ----------------"
          fi
          ;;
      status)
          if [ -z "$version" ]; then
            # display usage if no parameters given
            echo "you must pass a release version number ex: 0.0.5"
          else
            echo "------------- starting vagrant status ----------------"
            cd ~/unified/platform-ui
            RELEASE_VERSION=$version vagrant status
            echo "------------- finished vagrant status ----------------"
          fi
          ;;
      pull)
          if [ -z "$version" ]; then
            # display usage if no parameters given
            echo "you must pass a release version number ex: 0.0.5"
          else
            # echo "------------- starting vagrant pvp ----------------"
            cd ~/unified/platform && git pull && cd ../pmn && git pull && cd ../platform-ui && plat pd
            # RELEASE_VERSION=$version vagrant provision
            # echo "------------- finished vagrant pvp ----------------"
          fi
          ;;
      pd)
          local branch_name
          branch_name=$(current_branch)
          if [ $branch_name = "develop" ]; then
              if ! git diff-index --quiet HEAD --; then
                git stash
                git pull -r unified develop
                git stash pop
            else
                git pull -r unified develop
            fi
          else
              if ! git diff-index --quiet HEAD --; then
                git stash
                git checkout develop
                git pull -r unified develop
                git checkout $branch_name
                git stash pop
            else
                git checkout develop
                git pull -r unified develop
                git checkout $branch_name
            fi
          fi
          ;;
      *)
          echo "--------------- Help ---------------"
          echo "Quick vagrant help script"
          echo "Commands:"
          echo "  up: Runs vagrant up with a release version for entity manager"
          echo "  status: Get the current status of all running vms"
          echo "  pull: Pull new code from github"
          echo "  help: This help text"
          echo "--------------- Help ---------------"
  esac
}

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew github history jira npm pep8 osx pip sublime git-flow aws bower osx vagrant)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:/usr/local/go/bin:/Users/coreytrombley/go/bin
# export MANPATH="/usr/local/man:$MANPATH"
export PYTHONPATH=/home/username/caffe/python
export GOPATH="/Users/coreytrombley/go"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

BASTION_USERNAME=ctrombley

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/unified/
source /usr/local/bin/virtualenvwrapper.sh

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
 alias zshconfig="vim ~/.zshrc"
# alias ohmyzsh="vim ~/.oh-my-zsh"
alias pvp="cd ../platform && git pull && cd ../pmn && git pull && cd ../platform-ui && RELEASE_VERSION=0.0.5 vagrant provision"

alias crontab="VIM_CRONTAB=true crontab"
alias unified='open https://github.com/Unified'
alias mou="open -a /Applications/Mou.app"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.scripts:$PATH"

export NVM_DIR="/Users/coreytrombley/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


source "$HOME/.homesick/repos/homeshick/homeshick.sh"