#~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias xclip='xclip -selection c'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/Gimbal\ Control\ Panel\ Factory\ 3-18-1-2304_x64/GimbalControlPanelFactory.exe & exit'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/Gimbal\ Control\ Panel\ Factory\ 3-2_x64/GimbalControlPanel.exe & exit'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/GCP-3-22-fw-routing/GimbalControlPanel.exe & exit'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/GCP-3-24-fw-upload-fix/GimbalControlPanel.exe & exit'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/GCP-Attitude-Sources/GimbalControlPanel.exe & exit'
#alias gcp='./.wine/drive_c/Program\ Files/AVT/GCP-4-0/GimbalControlPanel.exe & exit'
alias gcp='./.wine/drive_c/Program\ Files/AVT/Gimbal\ Control\ Panel\ Factory\ 4-0-0-2504_x64/GimbalControlPanelFactory.exe & exit'

# Bash Prompt
function prompt_cmd
{
    local EXIT="$?"
    local prompt=""
    GREEN="\[\033[0;32m\]"
    RED="\[\033[0;31m\]"
    NC="\[\033[0m\]"
    if [[ $EXIT != 0 ]]; then
        prompt="$RED"
    else
        prompt="$GREEN"
    fi
    prompt="${prompt}$NC"
    export PS1="$prompt\u: \W \$ "
}
export PROMPT_COMMAND=$PROMPT_COMMAND;prompt_cmd

# Custom aliases
alias rgf='rg --files | rg'
alias stm32='STM32_Programmer_CLI'
alias gitdiffcolor='git diff --color-moved --color-moved-ws=ignore-all-space'

# Theme
export BASH_IT_THEME="atomic"

# Fuzzy finding search
#source /usr/share/fzf/completion.bash && source /usr/share/fzf/key-bindings.bash

# Walker options in $FZF_DEFAULT_OPTS
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--walker=dir,follow --walker-skip=.git,node_modules,target"

# Defaults keyboard
numlockx &
xset r rate 200 30
setxkbmap -option caps:escape

# External
export PATH="/opt/stm32cubeprog/bin:$PATH"
export PATH="/home/j.denny/avt/uvvp/client_api/uavv_fwup/:$PATH"
export PATH="/home/j.denny/avt/uvvp/protocol/reg_acc/:$PATH"
export PATH="/opt/forticlient/gui/FortiClient-linux-x64/:$PATH"
export PATH="/home/j.denny/vpn/:$PATH"
export PATH="/home/j.denny/debugging/extension/debugAdapters/bin/:$PATH"

giomount() {
    if [[ ! -d /run/user/1000/gvfs/smb-share:server=192.168.8.21,share=$1/ ]]; then
        gio mount smb://192.168.8.21/$1
    fi
    cd /run/user/1000/gvfs/smb-share:server=192.168.8.21,share=$1/
}

export home=49.198.26.89
