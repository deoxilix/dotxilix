# Helix ZSH Theme
#
# Author: xilix
# License: MIT
# https://github.com/deoxilix/

NEWLINE='
'

# PROMPT
SPACESHIP_PROMPT_SYMBOL="${SPACESHIP_PROMPT_SYMBOL:-​‌♆}"
SPACESHIP_PROMPT_ADD_NEWLINE="${SPACESHIP_PROMPT_ADD_NEWLINE:-true}"
SPACESHIP_PROMPT_SEPARATE_LINE="${SPACESHIP_PROMPT_SEPARATE_LINE:-true}"
SPACESHIP_PROMPT_TRUNC="${SPACESHIP_PROMPT_TRUNC:-3}"
SPACESHIP_BATTERY_THRESHOLD="${SPACESHIP_BATTERY_THRESHOLD:-10}"

# PREFIXES
SPACESHIP_PREFIX_SHOW="${SPACEHIP_PREFIX_SHOW:-true}"
SPACESHIP_PREFIX_HOST="${SPACESHIP_PREFIX_HOST:-""}"
SPACESHIP_PREFIX_DIR="${SPACESHIP_PREFIX_DIR:-" in "}"
SPACESHIP_PREFIX_GIT="${SPACESHIP_PREFIX_GIT:-"  "}"
SPACESHIP_PREFIX_ENV_DEFAULT="${SPACESHIP_PREFIX_ENV_DEFAULT:-" "}"
SPACESHIP_PREFIX_NODE="${SPACESHIP_PREFIX_NODE:-$SPACESHIP_PREFIX_ENV_DEFAULT}"
SPACESHIP_PREFIX_RUBY="${SPACESHIP_PREFIX_RUBY:-$SPACESHIP_PREFIX_ENV_DEFAULT}"
SPACESHIP_PREFIX_SWIFT="${SPACESHIP_PREFIX_SWIFT:-$SPACESHIP_PREFIX_ENV_DEFAULT}"
SPACESHIP_PREFIX_XCODE="${SPACESHIP_PREFIX_XCODE:-$SPACESHIP_PREFIX_ENV_DEFAULT}"
SPACESHIP_PREFIX_VENV="${SPACESHIP_PREFIX_VENV:-$SPACESHIP_PREFIX_ENV_DEFAULT}"
SPACESHIP_PREFIX_PYENV="${SPACESHIP_PREFIX_PYENV:-$SPACESHIP_PREFIX_ENV_DEFAULT}"

# GIT
SPACESHIP_GIT_SHOW="${SPACESHIP_GIT_SHOW:-true}"
SPACESHIP_GIT_STAGED="${SPACESHIP_GIT_STAGED:-∔}"
SPACESHIP_GIT_UNSTAGED="${SPACESHIP_GIT_UNSTAGED:-⌥}"
SPACESHIP_GIT_UNTRACKED="${SPACESHIP_GIT_UNTRACKED:-✗}"
SPACESHIP_GIT_STASHED="${SPACESHIP_GIT_STASHED:-♻}"
SPACESHIP_GIT_UNPULLED="${SPACESHIP_GIT_UNPULLED:-⇣}"
SPACESHIP_GIT_COMMITTED="${SPACESHIP_GIT_COMMITTED:-⇡}"

# NODE
SPACESHIP_NODE_SHOW="${SPACESHIP_NODE_SHOW:-true}"
SPACESHIP_NODE_SYMBOL="${SPACESHIP_NODE_SYMBOL:-⬢}"

# RUBY
SPACESHIP_RUBY_SHOW="${SPACESHIP_RUBY_SHOW:-true}"
SPACESHIP_RUBY_SYMBOL="${SPACESHIP_RUBY_SYMBOL:-▼}"

# SWIFT
SPACESHIP_SWIFT_SHOW_LOCAL="${SPACESHIP_SWIFT_SHOW_LOCAL:-true}"
SPACESHIP_SWIFT_SHOW_GLOBAL="${SPACESHIP_SWIFT_SHOW_GLOBAL:-false}"
SPACESHIP_SWIFT_SYMBOL="${SPACESHIP_SWIFT_SYMBOL:-🐧}"

# XCODE
SPACESHIP_XCODE_SHOW_LOCAL="${SPACESHIP_XCODE_SHOW_LOCAL:-true}"
SPACESHIP_XCODE_SHOW_GLOBAL="${SPACESHIP_XCODE_SHOW_GLOBAL:-false}"
SPACESHIP_XCODE_SYMBOL="${SPACESHIP_XCODE_SYMBOL:-🛠}"

# VENV
SPACESHIP_VENV_SHOW="${SPACESHIP_VENV_SHOW:-true}"

# PYENV
SPACESHIP_PYENV_SHOW="${SPACESHIP_PYENV_SHOW:-false}"
SPACESHIP_PYENV_SYMBOL="${SPACESHIP_PYENV_SYMBOL:-🐍}"

# VI_MODE
SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW:-true}"
SPACESHIP_VI_MODE_INSERT="${SPACESHIP_VI_MODE_INSERT:-[I]}"
SPACESHIP_VI_MODE_NORMAL="${SPACESHIP_VI_MODE_NORMAL:-[N]}"

# Status Color
spaceship_return_status_color() {
  echo -n "%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})"
}

# Username.
# If user is root, then paint it in red. Otherwise, just print in cyan.
spaceship_user() {
  echo -n "$(spaceship_return_status_color)λ %{$reset_color%}"
  if [[ $USER == 'root' ]]; then
    echo -n "%{$fg_bold[red]%}"
  else
    echo -n "%{$fg_bold[cyan]%}"
  fi
  echo -n "%n"
  echo -n "%{$reset_color%}"
}

# Username and SSH host
# If there is an ssh connections, then show user and current machine.
# If user is not $USER, then show username.
spaceship_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo -n "$(spaceship_user)"

    # Do not show directory prefix if prefixes are disabled
    [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_DIR}%b" || echo -n ' '
    # Display machine name
    echo -n "%{$fg_bold[green]%}%m%{$reset_color%}"
    # Do not show host prefix if prefixes are disabled
    [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_HOST}%b" || echo -n ' '

  #elif [[ $LOGNAME != $USER ]] || [[ $USER == 'root' ]]; then
  else
    echo -n "$(spaceship_user)"

    # Do not show host prefix if prefixes are disabled
    [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_HOST}%b" || echo -n ' '

    echo -n "%{$reset_color%}"
  fi
}

# Current directory.
# Return only three last items of path
spaceship_current_dir() {
  echo -n "%{$reset_color%}"
  echo -n "%{$fg[cyan]%}"
  echo -n "%${SPACESHIP_PROMPT_TRUNC}~";
  echo -n "%{$reset_color%}"
}

# Staged changes.
# Check for staged changes in the index.
spaceship_git_staged() {
  echo -n "%{$reset_color%}%{$fg_bold[green]%}"
  local staged="$(command git diff --cached --name-only | wc -l | bc)"
  if ! $(git diff --quiet --ignore-submodules --cached); then
    echo -n " ${SPACESHIP_GIT_STAGED}"
    echo -n "%{$reset_color%}%{$fg[cyan]%}"
    echo -n ${staged}
  fi
}

# Unstaged changes.
# Check for unstaged changes.
spaceship_git_unstaged() {
  echo -n "%{$reset_color%}%{$fg_bold[red]%}"
  local unstaged="$(command git diff --name-only | wc -l | bc)"
  if ! $(git diff-files --quiet --ignore-submodules --); then
    echo -n " ${SPACESHIP_GIT_UNSTAGED} "
    echo -n "%{$reset_color%}%{$fg[cyan]%}"
    echo -n ${unstaged}
  fi
}

# Untracked files.
# Check for untracked files.
spaceship_git_untracked() {
  echo -n "%{$reset_color%}"
  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo -n " %{$fg[red]%}${SPACESHIP_GIT_UNTRACKED}%{$reset_color%}"
    echo -n "%{$fg[cyan]%}"
    git ls-files --others --exclude-standard | wc -l | sed "s/[^0-9]//g"
  fi
}

# Stashed changes.
# Check for stashed changes.
spaceship_git_stashed() {
  # "%{$fg[cyan]%}""%{$reset_color%}"
  echo -n "%{$reset_color%}"
  # local stashed_number
  if $(git rev-parse --verify refs/stash &>/dev/null); then
    echo -n "%{$fg[red]%}${SPACESHIP_GIT_STASHED} %{$reset_color%}"
    echo -n "%{$fg[cyan]%}"
    git stash list | wc -l | sed "s/[^0-9]//g"
  fi
}

# Unpulled changes
# Commits behind remote
spaceship_git_unpulled() {
  # "%{$fg[cyan]%}""%{$reset_color%}"
  echo -n "%{$reset_color%}"

  # check if there is an upstream configured for this branch
  command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

  local count
  count="$(command git rev-list --left-right --count HEAD...@'{u}' | cut -f2)"
  # $count || return # exit if the command failed

  # counters are tab-separated, split on tab and store as array
  count=(${(ps:\t:)count})
  local behind=${count[1]}
  local arrows

  (( ${behind:-0} > 0 )) && arrows=" ${SPACESHIP_GIT_UNPULLED}"
  [ -n $arrows ] && echo -n "%{$fg_bold[red]%}${arrows}"

  echo -n "%{$reset_color%}%{$fg[cyan]%}"
  (( ${behind:-0} > 0 )) && echo -n ${behind}
}

# Unpulled changes
# Commits behind remote
spaceship_git_committed() {
  # "%{$fg[cyan]%}""%{$reset_color%}"
  echo -n "%{$reset_color%}"

  # check if there is an upstream configured for this branch
  command git rev-parse --abbrev-ref @'{u}' &>/dev/null || return

  local count
  count="$(command git rev-list --left-right --count HEAD...@'{u}' | cut -f1)"
  # $count || return # exit if the command failed

  # counters are tab-separated, split on tab and store as array
  count=(${(ps:\t:)count})
  local ahead=${count[1]}
  local arrows

  # prints arrow
  (( ${ahead:-0} > 0 )) && arrows=" ${SPACESHIP_GIT_COMMITTED}"
  [ -n $arrows ] && echo -n "%{$fg_bold[green]%}${arrows}"

  echo -n "%{$reset_color%}%{$fg[cyan]%}"
  (( ${ahead:-0} > 0 )) && echo -n ${ahead}
}

# Git status.
# Collect indicators, git branch and pring string.
spaceship_git_status() {
  [[ $SPACESHIP_GIT_SHOW == false ]] && return

  # Check if the current directory is in a Git repository.
  command git rev-parse --is-inside-work-tree &>/dev/null || return

  # Check if the current directory is in .git before running git checks.
  if [[ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]]; then
    # Ensure the index is up to date.
    git update-index --really-refresh -q &>/dev/null

    # String of indicators
    local indicators

    indicators+="$(spaceship_git_stashed)"
    indicators+="$(spaceship_git_untracked)"
    indicators+="$(spaceship_git_unstaged)"
    indicators+="$(spaceship_git_staged)"
    indicators+="$(spaceship_git_committed)"
    indicators+="$(spaceship_git_unpulled)"

    [ -n ${indicators} ] && indicators="[ ${indicators}%{$fg_bold[cyan]%} ]";

    # Do not show git prefix if prefixes are disabled
    echo -n "$(spaceship_return_status_color)"
    [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_GIT}%b" || echo -n ' '
    echo -n "%{$reset_color%}"


    echo -n "%{$fg_bold[yellow]%}"
    echo -n "$(git_current_branch) "
    echo -n "%{$reset_color%}"
    echo -n "%{$fg_bold[cyan]%}"
    [ -n ${indicators} ] && echo -n ${indicators}
    echo -n "%{$reset_color%}"
  fi
}

# Virtual environment.
# Show current virtual environment (Python).
spaceship_venv_status() {
  [[ $SPACESHIP_VENV_SHOW == false ]] && return

  # Check if the current directory running via Virtualenv
  [ -n "$VIRTUAL_ENV" ] && $(type deactivate >/dev/null 2>&1) || return

  # Do not show venv prefix if prefixes are disabled
  [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_VENV}%b" || echo -n ' '

  echo -n "%{$fg_bold[blue]%}"
  echo -n "$(basename $VIRTUAL_ENV)"
  echo -n "%{$reset_color%}"
}

# Pyenv
# Show current version of pyenv python, including system.
spaceship_pyenv_status() {
  [[ $SPACESHIP_PYENV_SHOW == false ]] && return

  $(type pyenv >/dev/null 2>&1) || return # Do nothing if pyenv is not installed

  local pyenv_shell=$(pyenv shell 2>/dev/null)
  local pyenv_local=$(pyenv local 2>/dev/null)
  local pyenv_global=$(pyenv global 2>/dev/null)

  # Version follows this order: shell > local > global
  # See: https://github.com/yyuu/pyenv/blob/master/COMMANDS.md
  if [[ ! -z $pyenv_shell ]]; then
    pyenv_status=$pyenv_shell
  elif [[ ! -z $pyenv_local ]]; then
    pyenv_status=$pyenv_local
  elif [[ ! -z $pyenv_global ]]; then
    pyenv_status=$pyenv_global
  else
    return # If none of these is set, pyenv is not being used. Do nothing.
  fi

  # Do not show pyenv prefix if prefixes are disabled
  [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_PYENV}%b" || echo -n ' '

  echo -n "%{$fg_bold[yellow]%}"
  echo -n "${SPACESHIP_PYENV_SYMBOL}  ${pyenv_status}"
  echo -n "%{$reset_color%}"
}

# Ruby
# Show current version of Ruby
spaceship_ruby_version() {
  [[ $SPACESHIP_RUBY_SHOW == false ]] && return

  if command -v rvm-prompt > /dev/null 2>&1; then
    ruby_version=$(rvm-prompt i v g)
  elif command -v chruby > /dev/null 2>&1; then
    ruby_version=$(chruby | sed -n -e 's/ \* //p')
  elif command -v rbenv > /dev/null 2>&1; then
    ruby_version=$(rbenv version | sed -e 's/ (set.*$//')
  else
    return
  fi

  # Do not show ruby prefix if prefixes are disabled
  [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_RUBY}%b" || echo -n ' '

  echo -n "%{$fg_bold[red]%}"
  echo -n "${SPACESHIP_RUBY_SYMBOL}${ruby_version}"
  echo -n "%{$reset_color%}"
}


# Node
# Show current version of Node
spaceship_node_version() {
  [[ $SPACESHIP_NODE_SHOW == false ]] && return

  if command -v nvm-prompt > /dev/null 2>&1; then
    node_version=$(nvm-prompt i v g)
  elif command -v nodenv > /dev/null 2>&1; then
    node_version=$(nodenv version | sed -e 's/ (set.*$//')
  else
    return
  fi

  # Do not show ruby prefix if prefixes are disabled
  [[ $SPACESHIP_PREFIX_SHOW == true ]] && echo -n "%B${SPACESHIP_PREFIX_NODE}%b" || echo -n ' '

  echo -n "%{$fg_bold[green]%}"
  echo -n "${SPACESHIP_NODE_SYMBOL} ${node_version}"
  echo -n "%{$reset_color%}"
}


# Swift
# Show current version of Swift
spaceship_swift_version() {
  command -v swiftenv > /dev/null 2>&1 || return

  if [[ $SPACESHIP_SWIFT_SHOW_GLOBAL == true ]] ; then
    local swift_version=$(swiftenv version | sed 's/ .*//')
  elif [[ $SPACESHIP_SWIFT_SHOW_LOCAL == true ]] ; then
    if swiftenv version | grep ".swift-version" > /dev/null; then
      local swift_version=$(swiftenv version | sed 's/ .*//')
    fi
  fi

  if [ -n "${swift_version}" ]; then
    echo -n " %B${SPACESHIP_PREFIX_SWIFT}%b "
    echo -n "%{$fg_bold[yellow]%}"
    echo -n "${SPACESHIP_SWIFT_SYMBOL}  ${swift_version}"
    echo -n "%{$reset_color%}"
  fi
}

# Xcode
# Show current version of Xcode
spaceship_xcode_version() {
  command -v xcenv > /dev/null 2>&1 || return

  if [[ $SPACESHIP_SWIFT_SHOW_GLOBAL == true ]] ; then
    local xcode_path=$(xcenv version | sed 's/ .*//')
  elif [[ $SPACESHIP_SWIFT_SHOW_LOCAL == true ]] ; then
  else
    if xcenv version | grep ".xcode-version" > /dev/null; then
      local xcode_path=$(xcenv version | sed 's/ .*//')
    fi
  fi

  if [ -n "${xcode_path}" ]; then
    local xcode_version_path=$xcode_path"/Contents/version.plist"
    if [ -f ${xcode_version_path} ]; then
      if command -v defaults > /dev/null 2>&1 ; then
        xcode_version=$(defaults read ${xcode_version_path} CFBundleShortVersionString)
        echo -n " %B${SPACESHIP_PREFIX_XCODE}%b "
        echo -n "%{$fg_bold[blue]%}"
        echo -n "${SPACESHIP_XCODE_SYMBOL}  ${xcode_version}"
        echo -n "%{$reset_color%}"
      fi
    fi
  fi
}

# Temporarily switch to vi-mode
spaceship_enable_vi_mode() {
  function zle-keymap-select() { zle reset-prompt; zle -R; };
  zle -N zle-keymap-select;
  bindkey -v;
}

# Show current vi_mode mode
spaceship_vi_mode() {
  if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then # check if vi-mode enabled
    echo -n "%{$fg_bold[white]%}"

    MODE_INDICATOR="${SPACESHIP_VI_MODE_INSERT}"

    case ${KEYMAP} in
      main|viins)
      MODE_INDICATOR="${SPACESHIP_VI_MODE_INSERT}"
      ;;
      vicmd)
      MODE_INDICATOR="${SPACESHIP_VI_MODE_NORMAL}"
      ;;
    esac
    echo -n "${MODE_INDICATOR}"
    echo -n "%{$reset_color%}"
  fi
}

# Battery Status
spaceship_battery() {
  pmset -g batt | tail -1 | cut -f2 | cut -d';' -f1| cut -d'%' -f1
}
spaceship_battery_status() {
  # battery = $((spaceship_battery))
  # echo -n "$(spaceship_battery)"
  # if [ $battery -lt 10 ]
  # then
  #   echo -n "%{$fg_bold[red]%}⚡ $(spaceship_battery)%{$reset_color%}"
  # else
    echo -n "%B%{$fg[cyan]%}⚡ $(spaceship_battery)%{$reset_color%}%b"
  # fi
}

# Command prompt.
# Paint $PROMPT_SYMBOL in red if previous command was fail and
# paint in green if everything was OK.
spaceship_return_status() {
  echo -n "%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})"
  echo -n "%B${SPACESHIP_PROMPT_SYMBOL}%b "
  echo -n "%{$reset_color%}"
}

spaceship_system_environment_promt() {
  echo -n "["
  spaceship_battery_status
  spaceship_ruby_version
  spaceship_node_version
  spaceship_xcode_version
  spaceship_swift_version
  spaceship_venv_status
  spaceship_pyenv_status
  echo -n " ]"
}

# Entry point
# Compose whole prompt from smaller parts
spaceship_prompt() {
  # Should it add a new line before the prompt?
  [[ $SPACESHIP_PROMPT_ADD_NEWLINE == true ]] && echo -n "$NEWLINE"

  # Execute all parts
  spaceship_host

  echo -n "$(spaceship_return_status_color) » "
  echo -n "[$(spaceship_current_dir)$(spaceship_return_status_color)]%{$reset_color%}"

  # Render git notification
  spaceship_git_status

  # Should it write prompt in two lines or not?
  # Write a space before, if it's written in single line
  [[ $SPACESHIP_PROMPT_SEPARATE_LINE == true ]] && echo -n "$NEWLINE" || echo -n ' '

  # Is vi-mode active?
  [[ $SPACESHIP_VI_MODE_SHOW == true ]] && spaceship_vi_mode

  # Prompt character
  spaceship_return_status
}

# PS2 - continuation interactive prompt
spaceship_ps2_prompt() {
  echo -n "%{$fg_bold[yellow]%}"
  echo -n "%{$SPACESHIP_PROMPT_SYMBOL%} "
  echo -n "%{$reset_color%}"
}

# Disable python virtualenv environment prompt prefix
VIRTUAL_ENV_DISABLE_PROMPT=true

# Expose Spaceship to environment variables
RPROMPT='$(spaceship_system_environment_promt)'
PROMPT='$(spaceship_prompt)'
PS2='$(spaceship_ps2_prompt)'

# LSCOLORS
export LSCOLORS="Gxfxcxdxbxegedabagacab"
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:ow=0;41:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.patch=00;34:*.o=00;32:*.so=01;35:*.ko=01;31:*.la=00;33'
# Zsh to use the same colors as ls
# Link: http://superuser.com/a/707567
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
