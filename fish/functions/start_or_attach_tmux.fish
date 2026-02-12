function start_or_attach_tmux
    if test -z "$TMUX"
        if test -z (tmux ls | grep workspace)
            TERM="xterm-kitty" tmux new -s workspace
        else
            TERM="xterm-kitty" tmux attach
        end
    end
end
