export XCURSOR_SIZE=24
export XCURSOR_THEME=Bibata-Original-Classic
export GTK_THEME=Orchis-Dark
export GTK_ICON_THEME=Papirus-Dark

export EDITOR=nvim
export VISUAL=nvim
export PAGER=bat
export MANPAGER='nvim +Man!'

export PASSWORD_STORE_ENABLE_EXTENSIONS=true

export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland

export MANGOHUD=1
export WINE_FULLSCREEN_FSR=1
export WINE_FULLSCREEN_FSR_STRENGTH=5
export AMD_VULKAN_ICD=RADV
export LIBVA_DRIVER_NAME=radeonsi
export VDPAU_DRIVER=radeonsi

export SSH_ASKPASS=/usr/lib/ssh/gnome-ssh-askpass4
export SSH_ASKPASS_REQUIRE='prefer'

export RIPGREP_CONFIG_PATH=~/.config/ripgreprc

eval $(ssh-agent -t 15m)
