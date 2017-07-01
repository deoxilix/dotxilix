# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# export rbenv path
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# export nodenv path
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# export pyenv path
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# export jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home"

# Path to your oh-my-zsh installation.
export ZSH=/Users/xilix/.oh-my-zsh

# THEMES
ZSH_THEME="robbyrussell"
# ZSH_THEME='hyperzsh'
# ZSH_THEME='lambda'
ZSH_THEME='spaceship'

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Aliases
alias z="vi ~/.zshrc && clear"
alias reload="source ~/.zshrc && clear"
alias ohmyzsh="vi ~/.oh-my-zsh"
alias png="ping www.facebook.com"
alias home="cd"
alias .="~"
alias out="exit"

# # Utility Aliases
alias lsd="ls -ah"
alias battery="pmset -g batt | tail -1 | cut -f2 | cut -d';' -f1"
alias weather="weather"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs . &"
alias youtube="youtube-downloader"

# # Git Aliases
alias gitlog="git log"
alias gcm="git commit -m"
alias addall="git add --all"
alias grv="git remote -v"
alias gci="git commit -m"
alias logg="git log"
alias master="gco master"
alias prod="gco production"
alias gitgraph="git log --graph"
alias logline="git log --pretty=oneline"
alias today="git log --since=24.hours --pretty='%h :: %an >> %s [%cr]'"
alias mychanges="git log --author=deoxilix --pretty='%h :: %an >> %s [%cr]'"
alias lasthash="git log -1 --pretty='%H'"

# # WorkFlow Aliases
alias quinturbo="~ && itermocil qt"
alias run="run"
alias rspec="bundle exec rspec"
# Quintype
alias bloombergquint="~/work/qt/bloomberg-quint"
alias bq="~/work/qt/bloomberg-quint"
alias itsman="~/work/qt/itsman"
alias sketches="~/work/qt/sketches"
alias mafia="~/work/qt/mafia-syndication"
alias quest="~/work/qt/quest"
alias rabbit="~/work/qt/trojan-rabbit"
alias quintype="~/work/qt"
# navigation
alias code="~/dimension::xilix/github-opensource/code::42 && clear"
alias xilix="~/dimension::xilix"
alias music="~/Music"
alias videos="~/Movies"
alias movies="~/Movies"
alias docs="~/Documents"

# # Typo handling
alias cl="clear"
alias cel="clear"
alias cle="clear"
alias lce="clear"
alias lc="clear"
alias gti="git"
alias hoem="~"
alias todau="today"

# # FunctionalAliases
# Weather
function weather() {
  if [ -n "$1" ]
  then
      curl "wttr.in/$1" | less
  else
      curl "wttr.in/bangalore" | less
  fi
}
# Youtube downloader
function youtube-downloader() {
  pwd | pbcopy
  videos && youtube-dl "$1"
  $(ls -ah)
  $(command pbpaste)
}
# ./run
function run() {
  if [ -n "$1" ]
  then
    ./run "$1" && clear
  else
    ./run development && clear
  fi
}

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=5

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="false"
# DISABLE_CORRECTION="true"
unsetopt correct_all

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Setting up TheFuck
eval "$(thefuck --alias fuck)"

# Adding Cask to PATH
export PATH="$HOME/.cask/bin:$PATH"
export PATH="/usr/local/opt/elasticsearch@2.4/bin:$PATH"
