# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background and the font Inconsolata.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
# 
# http://ysmood.org/wp/2013/03/my-ys-terminal-theme/
# Mar 2013 ys

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST
}

SEGMENT_SEPARATOR=$'\ue0b0'
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}
# Directory info.
#local current_dir='${PWD/#$HOME/~}'

local current_dir='%2d'

# VCS
YS_VCS_PROMPT_PREFIX1="%{$fg[white]%}on"
YS_VCS_PROMPT_PREFIX2=":%{$fg[magenta]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}Χ"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}✔"

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="$(prompt_segment yellow back)${YS_VCS_PROMPT_PREFIX1}$(prompt_segment red green)%{$fg[blue]%}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$(prompt_segment yellow back)$YS_VCS_PROMPT_DIRTY$(prompt_segment yellow black)"
ZSH_THEME_GIT_PROMPT_CLEAN="$(prompt_segment green black)$YS_VCS_PROMPT_CLEAN$(prompt_segment green black)"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$YS_VCS_PROMPT_DIRTY"
		else
			echo -n "$YS_VCS_PROMPT_CLEAN"
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $ 
PROMPT="%{$terminfo[bold]$fg[blue]%}#\
$(prompt_segment cyan yellow)%{$fg[154]%}%n\
%{$fg[white]%}@\
%{$fg[red]%}%m\
$(prompt_segment red green)%{$fg[white]%}in\
$(prompt_segment blue black)%{$terminfo[bold]$fg[yellow]%}${current_dir}\
${hg_info}\
${git_info} \
%{$fg[white]%}
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"

if [[ "$USER" == "root" ]]; then
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$bg[yellow]%}%{$fg[cyan]%}%n%{$reset_color%} \
%{$fg[white]%}at \
%{$fg[green]%}$(box_name) \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}\
${hg_info}\
${git_info} \
%{$fg[white]%}[%*]
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
fi
