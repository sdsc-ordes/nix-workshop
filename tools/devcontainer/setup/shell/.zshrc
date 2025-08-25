# Load completion system
autoload -U compinit; compinit

# Programs requiring an editor.
export EDITOR="nvim"
export VISUAL="nvim"

# Shell settings.
HISTFILE=~/.zsh_history
HISTSIZE=10000                   # How many lines of history to keep in memory
SAVEHIST=10000                   # Number of history entries to save to disk
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.
setopt AUTO_PUSHD                # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS         # Do not store duplicates in the stack.
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd.

# Plugin settings.
# Gray color for autosuggestions
local ZSH_AUTOSUGGEST_USE_ASYNC=true
local ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Installing plugins ===========================================================
# Setup antidote if not yet setup.
# Install antidote and bundle plugins.
source ~/.zshrc-install-plugins.zsh
install_plugins
source ~/.zsh-plugins.zsh
# ==============================================================================

# Del/Home/End
# To see the key characters press `CTRL+V` and afterwards the combination in
# a normal shell.
# Del/Home/End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# Ctrl+ Left/Right, for word back and forward movement.
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Keybindings for substring search plugin.
# Maps up and down arrows and Alt+k, Alt+j
bindkey -M main '^[[A' history-substring-search-up
bindkey -M main '^[[B' history-substring-search-down
bindkey -M main '^[k' history-substring-search-up
bindkey -M main '^[j' history-substring-search-down

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Ctrl+Space and Ctrl+f for accept the autosuggestion.
bindkey '^ ' autosuggest-accept
bindkey '^f' autosuggest-accept

# Map
# - CTRL+R to history,
# - Ctrl+Shift+D to cd widget and
# - Ctrl+Shift+K to the kill witched.
autoload znt-history-widget
# We use `fzf` history search.
# zle -N znt-history-widget
# bindkey "^R" znt-history-widget
zle -N znt-cd-widget
bindkey "^[[86;5u" znt-cd-widget
zle -N znt-kill-widget
bindkey "^[[75;5u"  znt-kill-widget

# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load splash screen.
if [ -f ~/.shell-entry-splash.sh ]; then
    ~/.shell-entry-splash.sh "$(echo "$CONTAINER_NAME" | sed -E 's/-/ /g')"
fi
