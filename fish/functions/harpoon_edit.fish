function harpoon_edit --description "Edit tmux-harpoon bookmarks in a Nord-themed nvim popup"
    set -l cachefile "$HOME/Library/Caches/.tmux-harpoon-sessions"

    tmux popup -E -w 60% -h 50% \
        "nvim --clean -u ~/.config/nvim/harpoon-edit.lua $cachefile"
end
