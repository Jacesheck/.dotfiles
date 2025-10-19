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
#alias gcp='./.wine/drive_c/Program\ Files/AVT/Gimbal\ Control\ Panel\ Factory\ 4-0-0-2504_x64/GimbalControlPanelFactory.exe & exit'
alias gcp='./.wine/drive_c/Program\ Files/AVT/GCP_4.1.x/GimbalControlPanel.exe & exit'

# Bash Prompt
function prompt_cmd
{
    local EXIT="$?"
    local prompt=""
    GREEN="\[\033[0;32m\]"
    BLUE="\[\033[0;34m\]"
    RED="\[\033[0;31m\]"
    NC="\[\033[0m\]"
    if [[ $EXIT != 0 ]]; then
        prompt="$RED"
    else
        prompt="$GREEN"
    fi
    prompt="${prompt}$NC"

    # Extract build toolchain
    echo $PS1 | grep -q ">"
    if [[ $? -eq 0 ]]; then
        local build_tool=`echo $PS1 | sed s/\>.*/\>\ /`
    fi

    # Debug str
    unset OPTIMISATION_STR
    if [[ $ZERO_OPTIMISATION == 1 ]]; then
        OPTIMISATION_STR=$GREEN
    elif [[ $NO_OPTIMISATION == 1 ]]; then
        OPTIMISATION_STR=$BLUE
    else
        OPTIMISATION_STR=$RED
    fi

    unset DEBUG_STR
    if [[ $DEBUG == 1 ]]; then
        DEBUG_STR="$OPTIMISATION_STR $NC"
    fi

    export PS1="$build_tool$prompt \u: $DEBUG_STR\W \$ "
}
export PROMPT_COMMAND=prompt_cmd

# Custom aliases
alias rgf='rg --files | rg'
alias stm32='STM32_Programmer_CLI'
alias gitdiffcolor='git diff --color-moved=zebra --color-moved-ws=ignore-all-space'

# Theme
export BASH_IT_THEME="atomic"

# Fuzzy finding search
#source /usr/share/fzf/completion.bash && source /usr/share/fzf/key-bindings.bash

# Walker options in $FZF_DEFAULT_OPTS
eval "$(fzf --bash)"
export FZF_DEFAULT_OPTS="--walker=dir,follow --walker-skip=.git,node_modules,target"

# External
export PATH="/opt/stm32cubeprog/bin:$PATH"
export PATH="/home/j.denny/avt/uvvp/protocol/reg_acc/:$PATH"
export PATH="/opt/forticlient/gui/FortiClient-linux-x64/:$PATH"
export PATH="/home/j.denny/vpn/:$PATH"
export PATH="/home/j.denny/debugging/extension/debugAdapters/bin/:$PATH"
export PATH="/home/j.denny/.opam/opam-init:$PATH"
export PATH="/usr/lib/jvm/java-24-openjdk/bin:$PATH"


giomount() {
    if [[ ! -d /run/user/1000/gvfs/smb-share:server=192.168.8.21,share=$1/ ]]; then
        gio mount smb://192.168.8.21/$1
    fi
    cd /run/user/1000/gvfs/smb-share:server=192.168.8.21,share=$1/
}

fastserial() {
    usb=`cd /dev && ls ttyUSB*`
    sudo bash -c "echo 1 > /sys/bus/usb-serial/devices/$usb/latency_timer"
}

debugmode() {
    if [[ $1 == "0" ]]; then
        unset DEBUG
        unset ZERO_OPTIMISATION
    else
        export DEBUG=1;
        export ZERO_OPTIMISATION=1
    fi
}

so() {
    source ~/.bashrc
}


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/jaced/.opam/opam-init/init.sh' && . '/home/jaced/.opam/opam-init/init.sh' > /dev/null 2> /dev/null || true
# END opam configuration

export home=49.198.26.89
