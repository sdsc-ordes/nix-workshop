#!/usr/bin/env zsh

ANTIDOTE_HOME=~/.antidote/.plugins
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:bundle' file ~/.zplugins

fpath+=(~/.antidote)
autoload -Uz "$fpath[-1]/antidote"

function install_plugins() {
    local zsh_plugins_src=~/.zplugins
    local zsh_plugins=~/.zsh-plugins.zsh

    local force_bundle="false"
    if [ ! -f "$zsh_plugins" ]; then
        force_bundle="true"
    fi

    # Ensure you have a plugins.txt file
    # where you can add plugins.
    [[ -f "$zsh_plugins_src" ]] || {
        mkdir -p "$(dirname "$zsh_plugins_src")" &&
            touch "$zsh_plugins_src"
    }

    # Generate static file in a subshell when
    # source plugin list is updated.
    if [[ "$zsh_plugins_src" -nt "$zsh_plugins" ]] ||
        [ "$force_bundle" = "true" ]; then
        echo "Generate static plugins file '$zsh_plugins' ..."
        antidote bundle <"$zsh_plugins_src" >"$zsh_plugins"
    fi
}
