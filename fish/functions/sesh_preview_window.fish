function sesh_preview_window
    if test (echo $argv[1] | wc -w) -gt 1
        set session_name (echo $argv[1] | awk '{print $2}')
    else
        set session_name $argv[1]
    end
    set session_id (tmux ls -F '#{session_id}' -f "#{==:#{session_name},$session_name}")
    if test -z $session_id
        set escaped_name (echo $session_name | sed s^~^$HOME^g)
        if test -d $escaped_name
            figlet -f doom $session_name
            eza -lg --tree --level=2 --icons --color=always "$escaped_name"
        else
            figlet -f isometric2 $session_name
        end
    else
        figlet -f doom $session_name
        tmux capture-pane -ep -t "$session_id"
    end
end
