# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# export rbenv path
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

## export nodenv path
## export PATH="$HOME/.nodenv/bin:$PATH"
## eval "$(nodenv init -)"

# deno setup
export DENO_INSTALL="/Users/xilix/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export pyenv path
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# export goenv path
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"
export PATH="$HOME/go/bin/:$PATH"

# export jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_111.jdk/Contents/Home"

# export leiningen
export PATH="$HOME/.bin/lein:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=/Users/xilix/.oh-my-zsh

# THEMES
# ZSH_THEME="robbyrussell"
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
alias vpnin="osascript ~/.ssh/connect.scpt"
alias vpnout="osascript ~/.ssh/disconnect.scpt"
alias battery="pmset -g batt | tail -1 | cut -f2 | cut -d';' -f1"
alias weather="weather"
alias emacs="/Applications/Emacs.app/Contents/MacOS/Emacs . &"
alias youtube="youtube-downloader"
alias updatedotfiles="updatedotfiles"
alias ngrok="./ngrok"
alias chcl="cht-clojure"
alias dc='docker-compose'
alias covid19-stats='curl -s https://pastebin.com/raw/KCajNDVi | sh'

# # Git Aliases
alias gitlog="git log"
alias gcm="git commit -m"
alias status="git status"
alias addall="git add --all"
alias addpatch="git add --patch"
alias grv="git remote -v"
alias commit="git commit -m"
alias stash="git stash"
alias pop="git stash pop"
alias pull="git pull"
alias gpr="git pull --rebase"
alias logg="git log"
alias master="gco master"
alias prod="gco production"
alias gitgraph="git log --graph"
alias logline="git log --pretty=oneline"
alias ggg="git grep"
alias today="git log --since=24.hours --pretty='%h :: %an >> %s [%cr]'"
alias mychanges="git log --author=deoxilix --pretty='%h :: %an >> %s [%cr]'"
alias lasthash="git log -1 --pretty='%H'"

# # WorkFlow Aliases
alias quinturbo="~ && itermocil qt"
alias run="run"
alias rspec="bundle exec rspec"
alias ssh="vpnin && ssh"
# Quintype
alias bloombergquint="~/work/qt/bloomberg-quint"
alias bq="~/work/qt/bloomberg-quint"
alias itsman="~/work/qt/itsman"
alias sketches="~/work/qt/sketches"
alias mafia="~/work/qt/mafia-syndication"
alias quest="~/work/qt/quest"
alias rabbit="~/work/qt/trojan-rabbit"
alias random="~/work/qt/random"
alias qt="~/work/qt"
alias qt-connect="vpnin && ~/work/qt/random/bin/qt-connect"
# navigation
alias code42="~/dimension::xilix/github-opensource/code::42 && clear"
alias leetcode="/Users/xilix/dimension::xilix/github-opensource/code::42/ruby/733tcode"
alias xilix="~/dimension::xilix"
alias music="~/Music"
alias videos="~/Movies"
alias movies="~/Movies"
alias docs="~/Documents"
alias downloads="~/Downloads"
alias pics="~/Pictures"
## bindings
# backward and forward word with option+left/right
bindkey '^[^[[D' backward-word
bindkey '^[b' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[f' forward-word

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
      curl -s "wttr.in/$1?m2" | less
  else
      curl -s "wttr.in/bangalore?m2" | less
  fi
}
# ImdSat
function weathersat() {
  # curl -s http://satellite.imd.gov.in/imc/3Dglobe_ir1.jpg > /Users/xilix/Pictures/imdweathersat.jpg \
  # && sips --cropToHeightWidth 960 960 -Z 960 /Users/xilix/Pictures/imdweathersat.jpg \
  #curl -s "http://www.imd.gov.in/pages/crop_sat.php?x=385&y=330&w=750&h=850&src=../section/satmet/3Dasiasec_ir1.jpg" > /Users/xilix/Pictures/imdweathersat.jpg \
  curl -s "https://mausam.imd.gov.in/Satellite/3Dasiasec_ir1.jpg" > /Users/xilix/Pictures/imdweathersat.jpg \
    && imgcat /Users/xilix/Pictures/imdweathersat.jpg \
    && rm -f /Users/xilix/Pictures/imdweathersat.jpg
}
# Youtube downloader
function youtube-downloader() {
  pwd | pbcopy
  videos && youtube-dl "$1" && clear
  ls -lah
  $(command pbpaste)
}
# ./run
function run() {
  if [ -n "$1" ]
  then
    ./run "$1" && clear
  else
    ./run && clear
  fi
}
# Git::Stash::Pop - Versions
function pop() {
  if [ -n "$1" ]
  then
    git stash pop stash@{$1}
  else
    git stash pop
  fi
}
# Cht.sh/clojure
function clo() {
 curl cht.sh/clojure/"$1"
}
# update-dotfiles
function updatedotfiles() {
  # cp '~/.zshrc' '~/dimesion::xilix/github-opensource/dotxilix/.zshrc'
  cp '/Users/xilix/dimension::xilix/github-opensource/dotxilix/Helix/xilix.zsh-theme' '/Users/xilix/.oh-my-zsh/themes/spaceship.zsh-theme'
}
# urldecode
alias urldecode='python -c "import sys, urllib as ul; \
    print ul.unquote_plus(sys.argv[1])"'

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
plugins=(
    git
    zsh-syntax-highlighting
    # zsh-autosuggestions
)

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
eval "$(thefuck --alias fcuk)"

# Adding Cask to PATH
export PATH="$HOME/.cask/bin:$PATH"
# Adding Brew PATH
export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
# Elasticsearch
export PATH="/usr/local/opt/elasticsearch@2.4/bin:$PATH"

# fixing openssl
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export PATH="/usr/local/opt/libressl/bin:$PATH"

clear
