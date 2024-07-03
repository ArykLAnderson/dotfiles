function sesh_list_sessions
    sesh list -i | fzf-tmux -p 85%,80% \
        --no-sort --ansi --border-label ' Pick Session ' --prompt '   ' \
        --header '[a]ll | [t]mux | confi[g]s | zo[x]ide | tmux-[k]ill | [f]ind' \
        --bind 'ctrl-n:down,ctrl-p:up' \
        --bind 'ctrl-a:change-prompt(   )+reload(sesh list)' \
        --bind 'ctrl-t:change-prompt(   )+reload(sesh list -t)' \
        --bind 'ctrl-g:change-prompt(   )+reload(sesh list -c)' \
        --bind 'ctrl-x:change-prompt(󱞊   )+reload(sesh list -z)' \
        --bind 'ctrl-f:change-prompt(   )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-k:execute(tmux kill-session -t {})+change-prompt(   )+reload(sesh list)' \
        --preview 'sesh_preview_window {}'
end
