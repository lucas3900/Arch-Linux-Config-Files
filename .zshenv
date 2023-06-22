#export LIBVA_DRIVER_NAME='vdpau'
#export VDPAU_DRIVER='nvidia'
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_STATE_HOME="$HOME"/.local/state
export __GL_SHADER_DISK_CACHE_PATH=/home/lucas/.cache/
export XDG_CACHE_HOME=/home/lucas/.cache/
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export HISTFILE="$XDG_STATE_HOME"/zsh/history 
export HISTSIZE=10000
export SAVEHIST=10000

# scaling for high DPI
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

# extend path
export PATH=/home/lucas/.local/bin:$PATH
export PATH=/home/lucas/.local/share/gem/ruby/3.0.0/bin:$PATH

# misc
export PYTHONSTARTUP="/etc/python/pythonrc"
export KERAS_HOME="${XDG_STATE_HOME}/keras"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# Enable Ray Tracing in Steam
export PROTON_HIDE_NVIDIA_GPU=0
export PROTON_ENABLE_NVAPI=1
export VKD3D_CONFIG=dxr,dxr11
export PROTON_ENABLE_NGX_UPDATER=1

