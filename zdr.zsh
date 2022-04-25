# Zshange directory recent (zdr)
if [[ -z "$ZDR_DIR" ]]; then
    ZDR_DIR=${XDG_CACHE_HOME:-$HOME/.cache}/zdr
fi
mkdir -p $ZDR_DIR

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

zstyle ':chpwd:*' recent-dirs-file $ZDR_DIR/recent-dirs
zstyle ':chpwd:*' recent-dirs-max 1000
# fall through to cd
zstyle ':chpwd:*' recent-dirs-default yes

# Prompt which recent directory to change to
zdr-fuzzy() {
    command=$(cdr -l | fzf | sed 's/[0-9]* */cd /')
    if [ ${#command} -ge 1 ]; then
        eval $command
        zle accept-line
    fi
}

# Bind to <CTRL>+p
zle -N zdr-fuzzy
bindkey '^p' zdr-fuzzy
