#!/bin/bash
# Author: xilix
# License: MIT (https://github.com/deoxilix/dotxilix/blob/master/LICENSE)
# https://github.com/deoxilix/

CYAN="$(tput setaf 6)"
dim="$(tput dim)" # Select dim (half-bright) mode
rev="$(tput rev)"



printf '%s' "$CYAN"
printf '%s\n' ' __  __     __     __         __     __  __'
printf '%s\n' '/\_\_\_\   /\ \   /\ \       /\ \   /\_\_\_\'
printf '%s\n' '\/_/\_\/_  \ \ \  \ \ \____  \ \ \  \/_/\_\/_'
printf '%s\n' '  /\_\/\_\  \ \_\  \ \_____\  \ \_\   /\_\/\_\'
printf '%s\n' '  \/_/\/_/   \/_/   \/_____/   \/_/   \/_/\/_/'
printf '%s\n'
printf '%s\n' "${dim}               deoxilix.github.io              "
printf '%s\n' "${license}"

# 0    black
# 1    red
# 2    green
# 3    yellow
# 4    blue
# 5    magenta
# 6    cyan
# 7    white
