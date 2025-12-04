export ZSH=$HOME/.zsh
export GPG_TTY=$(tty)

source $ZSH/oh-my-zsh.sh

export PNPM_HOME=/home/godilov/.local/share/pnpm
export RUSTFLAGS='-C target-cpu=native'

PATH=$PATH:$HOME/go/bin
PATH=$PATH:$HOME/.cargo/bin
PATH=$PATH:$HOME/.foundry/bin
PATH=$PATH:$HOME/.asdf/shims
PATH=$PATH:$HOME/.avm/bin
PATH=$PATH:$HOME/.local/share/solana/install/active_release/bin
PATH=$PATH:$HOME/.local/share/pnpm
PATH=$PATH:$HOME/.risc0/bin

export PATH

open() {
    xdg-open $@
}

man() {
    MANWIDTH=$((COLUMNS - 1)) /usr/bin/man "$@"
}

fetch() {
    macchina -t Lithium
}

eval "$(starship init zsh)"
