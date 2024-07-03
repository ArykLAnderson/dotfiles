function sesh_preview_window
    set session_name (echo $argv[1] | awk '{print $2}')
    set session_id (tmux ls -F '#{session_id}' -f "#{==:#{session_name},$session_name}")
    if test -z $session_id
        set escaped_name (echo $session_name | sed s^~^$HOME^g)
        eza -lg --tree --level=2 --icons "$escaped_name"
    else
        tmux capture-pane -ep -t "$session_id"
    end
end
