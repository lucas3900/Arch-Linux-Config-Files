# Path to your oh-my-zsh installation.
export ZSH="/home/lucas/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# auto update oh-my-zsh
DISABLE_UPDATE_PROMPT="true"


# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"


# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"


# plugins
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# ALIASES
alias ls='exa -lah --color=always --group-directories-first --git --no-user --icons'
# delete orphaned programs
alias cleanSystem='yay -Rns $(yay -Qtdq)'
# ask before deleteing/ovewriting
alias mv='mv -i'
# launch bitwarden rofi client with my rofi settings
alias bwmenu='bwmenu -- -lines 1 -show run -columns 20 -width 100 -location 2'
# generate password and copy it to clipboard
alias password='bw generate -ulns --length 12 | xclip -selection clipboard'

# environment variables
export BW_SESSION="dzbj6BR6/NXu3fGw5UtaH9kc0S93LMwaevylHWYMJ4/RKUP7dzUzu/Mrp0I7gwi6CmeOX7ngeo8OS5RNUrQ/aA=="
export BROWSER='qutebrowser'

# change directory color to purple in ls/exa
EXA_COLORS=$EXA_COLORS:'di=0;35:' ; export EXA_COLORS

# run neofetch on startup because I'm cool
neofetch
