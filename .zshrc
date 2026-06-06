##### Aliases, functions and environment variables #####

unsetopt BEEP
setopt appendhistory

# Initialize completion system
autoload -Uz compinit

# Set up completion cache directory
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

# Create cache directory if it doesn't exist
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"

# Load and initialize completion system
# Check if cache is older than 24 hours and regenerate if needed
if [[ -n ${ZSH_COMPDUMP}(#qN.mh+24) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Ranger configuration - prevent loading default rc.conf
export RANGER_LOAD_DEFAULT_RC=FALSE

# ALIASES
alias remove-whitespace='for f in *\ *; do mv "$f" "${f// /_}"; done'
alias ls='exa -lah --color=always --group-directories-first --git --no-user --icons'
# delete orphaned programs
alias cleanSystem='paru -Rns $(yay -Qtdq)'
# ask before deleteing/ovewriting
alias mv='mv -i'
# launch bitwarden rofi client with my rofi settings
alias open='xdg-open'
# enable hardware acceleration in qutebrowser
alias qutebrowser='qutebrowser --qt-flag ignore-gpu-blocklist --qt-flag enable-gpu-rasterization --qt-flag enable-native-gpu-memory-buffers --qt-flag num-raster-threads=4'
alias firmware='systemctl reboot --firmware-setup'
alias bashtozsh='chsh -s $(which zsh)'
## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias startvirtnet='sudo virsh net-start default'
alias hx='helix'
alias emacs="emacsclient -a '' -c"
alias nvidia-settings="nvidia-settings --config=$XDG_CONFIG_HOME/nvidia/settings"
alias gittop='cd $(git rev-parse --show-toplevel)'
alias git-submod-update='git submodule foreach git pull origin'
alias kitten-ssh='kitty +kitten ssh'
alias vpn-up='sudo tailscale up --accept-routes'
alias vpn-down='sudo tailscale down'
alias docker-stop-all='docker stop $(docker ps -a -q)'
alias docker-rm-all='docker rm $(docker ps -a -q)'
alias tc-vpn-up='openvpn3 session-start --config /home/lucas/work/napster/vpn/profile-userlocked.ovpn'
alias tc-vpn-down='openvpn3 session-manage --config /home/lucas/work/napster/vpn/profile-userlocked.ovpn --disconnect'
alias tc-vpn-clean='openvpn3 session-manage --cleanup'
alias claude-napster='CLAUDE_CONFIG_DIR=~/.claude-napster /home/lucas/.local/bin/claude'
# alias claude-harmoneyes='CLAUDE_CONFIG_DIR=~/.claude /home/lucas/.local/bin/claude'
# alias claude="echo 'Use specific commands: claude-napster or claude-harmoneyes'"

# keybindings
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

# FUNCTIONS
function force_pull() {
    git fetch --all
    git branch backup
    git reset --hard origin/$1
}

function commit() {
    git add .
    git commit -m $1
    git push origin $2
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# add ruby to path
# export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
# export PATH="$PATH:$GEM_HOME/bin"

# change directory color to purple in ls/exa
EXA_COLORS=$EXA_COLORS:'di=0;35:' ; export EXA_COLORS

eval "$(starship init zsh)"
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /etc/profile.d/google-cloud-cli.sh 

# run neofetch on startup because I'm cool
fastfetch

# bun completions
[ -s "/home/lucas/.bun/_bun" ] && source "/home/lucas/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
