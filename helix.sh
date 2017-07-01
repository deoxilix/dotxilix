#!/bin/bash
# Author: xilix
# License: MIT (https://github.com/deoxilix/dotxilix/blob/master/LICENSE)
# https://github.com/deoxilix/

CYAN="$(tput setaf 6)"
RED="$(tput setaf 1)"
YELLOW="$(tput setaf 3)"
GREEN="$(tput setaf 2)"
dim="$(tput dim)" # Select dim (half-bright) mode
rev="$(tput rev)"
reset="$(tput sgr0)"

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White


printf '%s' "$CYAN"
printf '%s\n' '    __  __     __     __         __     __  __'
printf '%s\n' '   /\_\_\_\   /\ \   /\ \       /\ \   /\_\_\_\'
printf '%s\n' '   \/_/\_\/_  \ \ \  \ \ \____  \ \ \  \/_/\_\/_'
printf '%s\n' '     /\_\/\_\  \ \_\  \ \_____\  \ \_\   /\_\/\_\'
printf '%s\n' '     \/_/\/_/   \/_/   \/_____/   \/_/   \/_/\/_/'
printf '\n'
printf '%s\n' "${dim}                  deoxilix.github.io              "
echo $reset

# if [ -n "$ZSH_VERSION" ]; then
#   #  cp './xilix.zsh-theme' '~/.oh-my-zsh/themes/'
#   echo "zsh"
# else
#   printf '%s\n' "${RED}   ¯\_(ツ)_/¯"
#   printf '%s\n' "${reset}where's oh-my-zsh?"
#
# fi

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  helixlocalpath="/Users/$USER/.oh-my-zsh/themes/xilix.zsh-theme"
  helixgiturl="https://github.com/deoxilix/dotxilix"
  helixrawurl="https://raw.githubusercontent.com/deoxilix/dotxilix/master/Helix/xilix.zsh-theme"

  if echo "\n$BGreen---------------------------->" && $(curl -s $helixrawurl > ${helixlocalpath}); then
    printf '\r%s\n' "----------------------------------------------------->${reset}"
    echo "${BCyan}Helix$reset$BGreen ≫$BYellow ${helixlocalpath} ${reset}\n"
    echo "ZSH_THEME='spaceship'" | pbcopy
  else
    echo -e "\r$BRed----------------------------------------------------->${reset}"
    echo -e "${BCyan}Helix$BRed download failed !${reset}\n"
    $(rm -f $helixlocalpath)
    echo -e "Try Cloning from:\n$helixgiturl"
  fi
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
  printf '%s\n' "\r$BRed    ¯\_(ツ)_/¯"
  printf '%s\n' "${reset}where's oh-my-zsh?"
else
  printf '%s\n' "\r$BRed      ¯\(°_o)/¯"
  printf '%s\n' "${reset}What shell is this?!"
fi

# setup() {};

# 0    black
# 1    red
# 2    green
# 3    yellow
# 4    blue
# 5    magenta
# 6    cyan
# 7    white
