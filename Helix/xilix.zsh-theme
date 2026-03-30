# Helix ZSH Theme
#
# Author: xilix
# License: MIT
# https://github.com/deoxilix/

autoload -Uz add-zsh-hook
autoload -Uz colors && colors

setopt prompt_subst

# 1. Config Defaults

: "${HELIX_PROMPT_TRUNC:=3}"
: "${HELIX_BATTERY_THRESHOLD:=10}"
: "${HELIX_PREFIX_SHOW:=true}"
: "${HELIX_PREFIX_HOST:=}"
: "${HELIX_PREFIX_DIR:= in }"
: "${HELIX_PREFIX_GIT:= on ⎇ }"
: "${HELIX_PREFIX_ENV_DEFAULT:= }"
: "${HELIX_PREFIX_NODE:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_PREFIX_RUBY:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_PREFIX_SWIFT:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_PREFIX_XCODE:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_PREFIX_VENV:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_PREFIX_PYENV:=$HELIX_PREFIX_ENV_DEFAULT}"
: "${HELIX_GIT_SHOW:=true}"
: "${HELIX_GIT_STAGED:=∔}"
: "${HELIX_GIT_UNSTAGED:=⌥}"
: "${HELIX_GIT_UNTRACKED:=✗}"
: "${HELIX_GIT_STASHED:=♻}"
: "${HELIX_GIT_UNPULLED:=⇣}"
: "${HELIX_GIT_COMMITTED:=⇡}"
: "${HELIX_NODE_SHOW:=true}"
: "${HELIX_NODE_SYMBOL:=⬢}"
: "${HELIX_RUBY_SHOW:=true}"
: "${HELIX_RUBY_SYMBOL:=▼}"
: "${HELIX_SWIFT_SHOW_LOCAL:=true}"
: "${HELIX_SWIFT_SHOW_GLOBAL:=false}"
: "${HELIX_SWIFT_SYMBOL:=🐧}"
: "${HELIX_XCODE_SHOW_LOCAL:=true}"
: "${HELIX_XCODE_SHOW_GLOBAL:=false}"
: "${HELIX_XCODE_SYMBOL:=🛠}"
: "${HELIX_VENV_SHOW:=true}"
: "${HELIX_PYENV_SHOW:=false}"
: "${HELIX_PYENV_SYMBOL:=🐍}"
: "${HELIX_VI_MODE_SHOW:=true}"
: "${HELIX_VI_MODE_INSERT:=[I]}"
: "${HELIX_VI_MODE_NORMAL:=[N]}"

: "${HELIX_BATTERY_SHOW:=true}"
: "${HELIX_USE_ORDER:=false}"
: "${HELIX_SET_LS_COLORS:=false}"
: "${HELIX_GIT_CACHE_TTL:=2}"
: "${HELIX_BATTERY_CACHE_TTL:=45}"
: "${HELIX_NODE_CACHE_TTL:=10}"

typeset -ga HELIX_PROMPT_ORDER
(( ${#HELIX_PROMPT_ORDER[@]} )) || HELIX_PROMPT_ORDER=(user dir git)

typeset -g VIRTUAL_ENV_DISABLE_PROMPT=true

# 2. Helpers

helix_bool() {
  [[ $1 == true ]]
}

helix_print_prefix() {
  helix_bool "$HELIX_PREFIX_SHOW" || return
  print -n -- "%B$1%b"
}

helix_last_status_color() {
  if (( HELIX_LAST_EXIT_CODE == 0 )); then
    print -n -- "%{$fg_bold[green]%}"
  else
    print -n -- "%{$fg_bold[red]%}"
  fi
}

helix_cache_valid() {
  local key=$1
  local ttl=$2
  [[ -n ${HELIX_CACHE_TIME[$key]-} ]] || return 1
  (( EPOCHSECONDS - HELIX_CACHE_TIME[$key] < ttl ))
}

helix_cache_set() {
  local key=$1
  local value=$2
  HELIX_CACHE_DATA[$key]=$value
  HELIX_CACHE_TIME[$key]=$EPOCHSECONDS
}

helix_escape_value() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//$'\n'/\\n}
  value=${value//;/\\;}
  print -r -- "$value"
}

helix_unescape_value() {
  local value=$1
  value=${value//\\;/;}
  value=${value//\\n/$'\n'}
  value=${value//\\\\/\\}
  print -r -- "$value"
}

helix_assign_kv() {
  local map_name=$1
  local key=$2
  local value=$3
  typeset -n map_ref=$map_name
  map_ref[$key]=$value
}

helix_parse_kv_blob() {
  local map_name=$1
  local blob=$2
  local entry key value

  typeset -n map_ref=$map_name
  map_ref=()

  for entry in ${(ps:;:)blob}; do
    [[ -n $entry ]] || continue
    key=${entry%%=*}
    value=${entry#*=}
    helix_assign_kv "$map_name" "$key" "$(helix_unescape_value "$value")"
  done
}

# 3. Cache

typeset -gA HELIX_CACHE_DATA
typeset -gA HELIX_CACHE_TIME
typeset -gA HELIX_GIT_INFO
typeset -gi HELIX_LAST_EXIT_CODE=0

# 4. Segments

helix_precmd() {
  HELIX_LAST_EXIT_CODE=$?
}
add-zsh-hook precmd helix_precmd

helix_user() {
  helix_last_status_color
  print -n -- "λ %{$reset_color%}"
  if [[ $USER == root ]]; then
    print -n -- "%{$fg_bold[red]%}%n"
  else
    print -n -- "%{$fg_bold[cyan]%}%n"
  fi
  print -n -- "%{$reset_color%}"
}

helix_dir() {
  print -n -- "%{$fg_bold[cyan]%}["
  print -n -- "%${HELIX_PROMPT_TRUNC}~"
  print -n -- "]%{$reset_color%}"
}

helix_git_load() {
  local repo_key="git:${PWD}"
  local raw_status line branch branch_oid ahead behind key
  local -A info

  if helix_cache_valid "$repo_key" "$HELIX_GIT_CACHE_TTL"; then
    helix_parse_kv_blob info "${HELIX_CACHE_DATA[$repo_key]}"
    HELIX_GIT_INFO=()
    HELIX_GIT_INFO=("${(@kv)info}")
    return
  fi

  raw_status=$(command git status --porcelain=2 --branch 2>/dev/null) || {
    HELIX_GIT_INFO=()
    helix_cache_set "$repo_key" "inside_repo=false"
    return
  }

  info=()
  info[inside_repo]=true
  info[branch]=''
  info[staged]=0
  info[unstaged]=0
  info[untracked]=0
  info[ahead]=0
  info[behind]=0

  while IFS= read -r line; do
    case $line in
      '# branch.head '*)
        branch=${line#\# branch.head }
        info[branch]=$branch
        ;;
      '# branch.oid '*)
        branch_oid=${line#\# branch.oid }
        info[branch_oid]=$branch_oid
        ;;
      '# branch.ab '*)
        [[ $line =~ '^\# branch\.ab \+([0-9]+) -([0-9]+)$' ]]
        ahead=${match[1]:-0}
        behind=${match[2]:-0}
        info[ahead]=$ahead
        info[behind]=$behind
        ;;
      '? '*)
        (( info[untracked]++ ))
        ;;
      '1 '*|'2 '*|'u '*)
        local xy=${line[3,4]}
        [[ ${xy[1]} != '.' ]] && (( info[staged]++ ))
        [[ ${xy[2]} != '.' ]] && (( info[unstaged]++ ))
        ;;
    esac
  done <<< "$raw_status"

  if [[ ${info[branch]} == '(detached)' && -n ${info[branch_oid]} ]]; then
    info[branch]=${info[branch_oid][1,7]}
  fi

  raw_status=''
  for key value in "${(@kv)info}"; do
    raw_status+="${key}=$(helix_escape_value "$value");"
  done

  HELIX_GIT_INFO=()
  HELIX_GIT_INFO=("${(@kv)info}")
  helix_cache_set "$repo_key" "$raw_status"
}

helix_git_segment() {
  local symbol=$1
  local color=$2
  local count=$3
  (( count > 0 )) || return
  print -n -- " %{${color}%}${symbol}%{$reset_color%}%{$fg[cyan]%}${count}%{$reset_color%}"
}

helix_git() {
  helix_bool "$HELIX_GIT_SHOW" || return
  helix_git_load
  helix_bool "${HELIX_GIT_INFO[inside_repo]-false}" || return

  local indicators=''

  indicators+=$(helix_git_segment "$HELIX_GIT_UNTRACKED" "$fg[red]" "${HELIX_GIT_INFO[untracked]:-0}")
  indicators+=$(helix_git_segment "$HELIX_GIT_UNSTAGED" "$fg_bold[red]" "${HELIX_GIT_INFO[unstaged]:-0}")
  indicators+=$(helix_git_segment "$HELIX_GIT_STAGED" "$fg_bold[green]" "${HELIX_GIT_INFO[staged]:-0}")
  indicators+=$(helix_git_segment "$HELIX_GIT_COMMITTED" "$fg_bold[green]" "${HELIX_GIT_INFO[ahead]:-0}")
  indicators+=$(helix_git_segment "$HELIX_GIT_UNPULLED" "$fg_bold[red]" "${HELIX_GIT_INFO[behind]:-0}")

  print -n -- " %{$fg_bold[cyan]%}["
  print -n -- "%{$reset_color%}"
  helix_last_status_color
  helix_print_prefix "$HELIX_PREFIX_GIT"
  print -n -- "%{$reset_color%}%{$fg_bold[yellow]%}${HELIX_GIT_INFO[branch]}%{$reset_color%}"
  if [[ -n $indicators ]]; then
    print -n -- "%{$fg_bold[cyan]%}${indicators} %{$fg_bold[cyan]%}"
  fi
  print -n -- "]%{$reset_color%}"
}

helix_ruby() {
  [[ $HELIX_RUBY_SHOW == true ]] || return

  local ruby_version=''

  if command -v rvm-prompt >/dev/null 2>&1; then
    ruby_version=$(rvm-prompt i v g 2>/dev/null)
  elif command -v chruby >/dev/null 2>&1; then
    ruby_version=$(chruby 2>/dev/null | sed -n -e 's/ \* //p')
  elif command -v rbenv >/dev/null 2>&1; then
    ruby_version=$(rbenv version 2>/dev/null | sed -e 's/ (set.*$//')
  fi

  [[ -n $ruby_version ]] || return
  helix_print_prefix "$HELIX_PREFIX_RUBY"
  print -n -- "%{$fg_bold[red]%}${HELIX_RUBY_SYMBOL}${ruby_version}%{$reset_color%}"
}

helix_node() {
  helix_bool "$HELIX_NODE_SHOW" || return
  [[ -f package.json || -f .nvmrc || -f .node-version ]] || return

  local cache_key="node:${PWD}"
  local node_version=''

  if helix_cache_valid "$cache_key" "$HELIX_NODE_CACHE_TTL"; then
    node_version=${HELIX_CACHE_DATA[$cache_key]}
  else
    if command -v nvm >/dev/null 2>&1; then
      node_version=$(nvm version 2>/dev/null)
      node_version=${node_version#v}
    elif command -v nodenv >/dev/null 2>&1; then
      node_version=$(nodenv version-name 2>/dev/null)
    elif command -v node >/dev/null 2>&1; then
      node_version=$(node -v 2>/dev/null)
      node_version=${node_version#v}
    fi

    [[ -n $node_version && $node_version != N/A ]] || return
    helix_cache_set "$cache_key" "$node_version"
  fi

  helix_print_prefix "$HELIX_PREFIX_NODE"
  print -n -- "%{$fg_bold[green]%}${HELIX_NODE_SYMBOL} ${node_version}%{$reset_color%}"
}

helix_battery_percent() {
  case $OSTYPE in
    darwin*)
      pmset -g batt 2>/dev/null | awk 'NR==2 {gsub(/%;/, "", $3); gsub(/%/, "", $3); print $3}'
      ;;
    *)
      return 1
      ;;
  esac
}

helix_battery() {
  helix_bool "$HELIX_BATTERY_SHOW" || return

  local cache_key='battery'
  local battery=''

  if helix_cache_valid "$cache_key" "$HELIX_BATTERY_CACHE_TTL"; then
    battery=${HELIX_CACHE_DATA[$cache_key]}
  else
    battery=$(helix_battery_percent) || return
    [[ -n $battery ]] || return
    helix_cache_set "$cache_key" "$battery"
  fi

  print -n -- "%B%{$fg[cyan]%}⚡ ${battery}%{$reset_color%}%b"
}

helix_vi_mode() {
  [[ $HELIX_VI_MODE_SHOW == true ]] || return
  bindkey | grep 'vi-quoted-insert' >/dev/null 2>&1 || return

  local mode_indicator=$HELIX_VI_MODE_INSERT
  case $KEYMAP in
    vicmd) mode_indicator=$HELIX_VI_MODE_NORMAL ;;
  esac

  print -n -- "%{$fg_bold[white]%}${mode_indicator}%{$reset_color%}"
}

helix_return_status() {
  helix_last_status_color
  print -n -- "%B→%b %{$reset_color%}"
}

helix_system_environment_prompt() {
  local content=''
  local battery_segment
  local node_segment

  battery_segment=$(helix_battery)
  node_segment=$(helix_node)

  content+=$battery_segment
  if [[ -n $node_segment ]]; then
    if [[ -n $content ]]; then
      content+=" "
    fi
    content+=$node_segment
  fi

  [[ -n $content ]] || return
  print -n -- "[${content} ]"
}

# 5. Prompt Assembly

helix_render_prompt_section() {
  case $1 in
    user) helix_user ;;
    dir)
      helix_last_status_color
      print -n -- " » "
      print -n -- "%{$reset_color%}"
      helix_dir
      ;;
    git) helix_git ;;
  esac
}

helix_prompt_body_dynamic() {
  local section
  for section in "${HELIX_PROMPT_ORDER[@]}"; do
    helix_render_prompt_section "$section"
  done
}

helix_prompt_body() {
  if [[ $HELIX_USE_ORDER == true ]]; then
    helix_prompt_body_dynamic
  else
    helix_user
    helix_last_status_color
    print -n -- " » "
    print -n -- "%{$reset_color%}"
    helix_dir
    helix_git
  fi
}

helix_prompt() {
  helix_prompt_body
  local vi_segment=''
  if [[ $HELIX_VI_MODE_SHOW == true ]]; then
    vi_segment=$(helix_vi_mode)
  fi
  if [[ -n $vi_segment ]]; then
    print -n -- " ${vi_segment}"
  fi
  print -n -- " "
}

helix_ps2_prompt() {
  print -n -- "%{$fg_bold[yellow]%}→ %{$reset_color%}"
}

# 6. Init

helix_enable_vi_mode() {
  function zle-keymap-select() { zle reset-prompt; zle -R; }
  zle -N zle-keymap-select
  bindkey -v
}

[[ $HELIX_SET_LS_COLORS == true ]] && {
  export LSCOLORS="Gxfxcxdxbxegedabagacab"
  export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:ow=0;41:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:*.patch=00;34:*.o=00;32:*.so=01;35:*.ko=01;31:*.la=00;33'
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
}

RPROMPT='$(helix_system_environment_prompt)'
PROMPT='$(helix_prompt)'
PS2='$(helix_ps2_prompt)'
