source "$HOME/.zsh_functions"

[[ -n "$WSL_INTEROP" ]] && source "$HOME/.zsh_tmux"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


setopt globdots             # Enable completition on hidden files
setopt INC_APPEND_HISTORY   # Immediately append commands to history file.
setopt HIST_IGNORE_ALL_DUPS # Never add duplicate entries.
setopt HIST_IGNORE_SPACE    # Ignore commands that start with a space.
setopt HIST_REDUCE_BLANKS   # Remove unnecessary blank lines.


ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
    git
    pnpm pnpm-shell-completion
    fzf fzf-tab
    zsh-autosuggestions
    fast-syntax-highlighting
    you-should-use
)


source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi


if command -v fzf &>/dev/null; then
  [[ -f "$HOME/.zsh_fzf" ]] && source "$HOME/.zsh_fzf"
fi


[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


bindkey '^ ' autosuggest-accept
bindkey '\t' fzf-tab-complete
bindkey '^[OA' fzf-history-widget


for file in ~/.zshrc.local "$HOME/.zsh_prompt" "$HOME/.zsh_aliases"; do
  [[ -f "$file" ]] && source "$file"
done


# pnpm
export PNPM_HOME="/home/julio/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
