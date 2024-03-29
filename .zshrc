##### Aliases, functions and environment variables #####

unsetopt BEEP
setopt appendhistory
autoload -Uz compinit
compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# ALIASES
alias ls='eza -lah --color=always --group-directories-first --git --no-user --icons'
# delete orphaned programs
alias cleanSystem='yay -Rns $(yay -Qtdq)'
# ask before deleteing/ovewriting
alias mv='mv -i'
# launch bitwarden rofi client with my rofi settings
alias bwmenu='bwmenu -- -lines 1 -show run -columns 20 -width 100 -location 2'
# generate password and copy it to clipboard
alias password='bw generate -ulns --length 12 | xclip -selection clipboard'
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

# change directory color to purple in ls/exa
EXA_COLORS=$EXA_COLORS:'di=0;35:' ; export EXA_COLORS

eval "$(starship init zsh)"
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# run neofetch on startup because I'm cool
neofetch
