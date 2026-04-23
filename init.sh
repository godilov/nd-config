#!/bin/bash

DIR=$(pwd)
APPS=$DIR/apps
DEPS=$DIR/deps
CONFIG=$DIR/config

ENSURED=false

ensure-git() {
    [[ -d "$1" ]] || git clone "$2" "$1"

    echo Update "$1"

    cd "$1" || return

    git pull origin

    cd - >/dev/null || return
}

ensure-deps() {
    [[ "$ENSURED" = true ]] && return

    ensure-git "$DEPS"/paru https://aur.archlinux.org/paru.git
    ensure-git "$DEPS"/refind https://github.com/bobafetthotmail/refind-theme-regular.git
    ensure-git "$DEPS"/omz https://github.com/ohmyzsh/ohmyzsh.git

    ENSURED=true
}

link() {
    local src="$1"
    local dst="$2"
    local dir

    dir="$(dirname "$dst")"

    [[ -L "$dst" ]] && rm "$dst"
    [[ -d "$dst" || -f "$dst" ]] && mv "$dst"{,.bak}

    [[ -d "$dir" ]] || mkdir -p "$dir"

    ln -sf "$src" "$dst"
}

link-arr() {
    local src="$1"
    local dst="$2"

    shift 2

    for entry in "$@"; do
        src_entry="$src/$entry"
        dst_entry="$dst/$entry"

        src_entry="${src_entry#"$(pwd)/"}"
        dst_entry="${dst_entry#"/home/$(whoami)/"}"

        echo "Linking $src_entry -> ~/$dst_entry"
        ln -sfn "$src"/"$entry" "$dst"/"$entry"
    done
}

install-pkg() {
    local args

    args="-S --needed $(cat "$1" | grep -E --color=never "^[a-zA-Z0-9_-]+$")"

    if command -v paru &>/dev/null; then
        paru "$args"
    else
        sudo pacman "$args"
    fi
}

init-pkg() {
    cat pkg/init pkg/libs pkg/dev pkg/cli pkg/hypr pkg/apps >pkg/all

    install-pkg pkg/all
}

init-dev() {
    rustup component add rust-analyzer
    rustup component add rust-analyzer --toolchain nightly

    rustup component add rustfmt
    rustup component add rustfmt --toolchain nightly

    cargo install sqlx-cli
    cargo install flamegraph
    cargo install cargo-cache
    cargo install cargo-show-asm
    cargo install cargo-nextest
    cargo install cargo-sort
    cargo install cargo-audit
    cargo install cargo-deny
    cargo install cargo-tarpaulin

    cargo install asm-lsp
    cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl-analyzer

    go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
}

init-treesitter() {
    mkdir -p config/nvim/parser
    mkdir -p config/nvim/queries

    rm -r config/nvim/parser/*
    rm -r config/nvim/queries/*

    git clone https://github.com/nvim-treesitter/nvim-treesitter.git /tmp/nvim-treesitter &&
        cp -r /tmp/nvim-treesitter/runtime/queries/* config/nvim/queries &&
        rm -rf /tmp/nvim-treesitter

    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-rust.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-c.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-cpp.git" &
    init-treesitter-parser "https://github.com/RubixDev/tree-sitter-asm.git" &
    init-treesitter-parser "https://github.com/wasm-lsp/tree-sitter-wasm.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-glsl.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-hlsl.git" &
    init-treesitter-parser "https://github.com/gpuweb/tree-sitter-wgsl.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-cuda.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-bash.git" &
    init-treesitter-parser "https://github.com/georgeharker/tree-sitter-zsh.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-html.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-css.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-json.git" &
    init-treesitter-parser "https://github.com/Joakker/tree-sitter-json5.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-javascript.git" &
    init-treesitter-parser "https://github.com/tree-sitter/tree-sitter-typescript.git" &
    init-treesitter-parser "https://github.com/DerekStride/tree-sitter-sql.git" &
    init-treesitter-parser "https://github.com/camdencheek/tree-sitter-dockerfile.git" &
    init-treesitter-parser "https://github.com/uben0/tree-sitter-typst.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-xml.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-yaml.git" &
    init-treesitter-parser "https://github.com/tree-sitter-grammars/tree-sitter-toml.git" &

    wait
}

init-treesitter-parser() {
    local url="$1"
    local dir="/tmp/${url##*/}"

    git clone "$url" "$dir" &&
        cd "$dir" &&
        npm install &&
        tree-sitter generate &&
        tree-sitter build &&
        cd - &&
        cp "$dir"/*.so config/nvim/parser &&
        rm -rf "$dir"
}

init-crypto() {
    curl --proto '=https' -L https://foundry.paradigm.xyz | bash
    curl --proto '=https' -L https://release.anza.xyz/stable/install | bash
    curl --proto '=https' -L https://risczero.com/install | bash
    cargo install --git https://github.com/coral-xyz/anchor avm --force

    foundryup
    avm install latest
    avm use latest

    asdf plugin add scarb
    asdf plugin add starknet-foundry
    asdf plugin add starknet-devnet

    asdf install scarb latest
    asdf install starknet-foundry latest
    asdf install starknet-devnet latest

    asdf set -u scarb latest
    asdf set -u starknet-foundry latest
    asdf set -u starknet-devnet latest

    rzup install
}

init-config() {
    ensure-deps

    link-arr "$CONFIG" ~/.config alacritty.toml batsignal brave-flags.conf ripgreprc starship.toml
    link-arr "$CONFIG" ~/.config bat btop dunst eww hypr mpd mpv nvim yazi
    link-arr "$CONFIG" ~/.config retroarch MangoHud gamemode.ini
    link-arr "$CONFIG" ~ .gitconfig

    link "$DEPS"/omz ~/.zsh
    link "$CONFIG"/.zshrc ~/.zshrc
    link "$CONFIG"/.profile ~/.zprofile
}

init-apps() {
    link-arr "$APPS" ~/.local/share/applications nvim.desktop yazi.desktop btop.desktop
}

init-groups() {
    sudo usermod -aG wheel docker gamemode nordvpn "$(whoami)"
}

for arg in "$@"; do
    case "$arg" in
    "all")
        init-pkg
        init-dev
        init-crypto

        init-config
        init-apps
        init-groups
        ;;
    "pkg")
        init-pkg
        init-dev
        init-crypto
        ;;
    "dev")
        init-dev
        ;;
    "treesitter")
        init-treesitter
        ;;
    "crypto")
        init-crypto
        ;;
    "amd")
        install-pkg pkg/hw_amd
        ;;
    "nvidia")
        install-pkg pkg/hw_nvidia
        ;;
    "config")
        init-config
        ;;
    "apps")
        init-apps
        ;;
    "groups")
        init-groups
        ;;
    "services")
        sudo systemctl enable --now NetworkManager.service
        sudo systemctl enable --now NetworkManager-dispatcher.service
        sudo systemctl disable --now NetworkManager-wait-online.service

        sudo systemctl enable --now bluetooth.service
        sudo systemctl enable --now tlp.service
        sudo systemctl enable --now fstrim.timer
        sudo systemctl enable --now chronyd.service
        sudo systemctl enable --now docker.service
        sudo systemctl enable --now ollama.service
        sudo systemctl enable --now nordvpn.service

        systemctl --user enable --now xdg-user-dirs-update.service
        systemctl --user enable --now pipewire.service
        systemctl --user enable --now wireplumber.service
        systemctl --user enable --now mpd.service
        ;;
    "reflector")
        sudo reflector --sort rate --threads 128 --fastest 128 --latest 1024 --protocol https --save /etc/pacman.d/mirrorlist
        ;;
    "diff")
        cat pkg/init pkg/libs pkg/dev pkg/cli pkg/hypr pkg/apps pkg/games pkg/aur | grep -E --color=never "^[a-zA-Z0-9_-]+$" | sort >pkg/all.diff1

        pacman -Qeq >pkg/all.diff2

        diff -u pkg/all.diff1 pkg/all.diff2 | grep -E --color=never '^[\+\-][a-zA-Z]+' | LC_COLLATE=C sort

        rm pkg/all.diff1 pkg/all.diff2
        ;;
    *)
        echo "No args"
        ;;
    esac
done
