function start_or_attach_tmux
    if test -z "$TMUX"
        if test -z (tmux ls | grep workspace)
            tmux new -s workspace
        else
            tmux attach
        end
    end
end
