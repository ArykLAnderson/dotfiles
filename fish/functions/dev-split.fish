function dev-split --description "Create 50/50 split with nvim (left) and oc (right)"
    # Usage:
    #   dev-split                           - nvim + oc
    #   dev-split file.txt                  - nvim file.txt + oc (simple mode)
    #   dev-split -n file.txt -c Something  - nvim file.txt -c Something + oc
    #   dev-split -n file.txt -o --resume   - nvim file.txt + oc --resume
    #   dev-split -o --resume               - nvim + oc --resume
    #
    # Bare repo detection:
    #   When opened in a bare git repo root, nvim will cd into the default
    #   branch worktree (master/main/develop) so LSP/treesitter work.
    #   opencode stays in the bare root (ideal for cross-worktree work).

    set -l nvim_args
    set -l oc_args
    set -l current_target nvim  # default target for args

    # If no flags provided, treat all args as nvim args (simple mode)
    if not string match -q -- '-n' $argv; and not string match -q -- '-o' $argv
        set nvim_args $argv
    else
        # Parse flags
        for arg in $argv
            switch $arg
                case -n --nvim
                    set current_target nvim
                case -o --oc
                    set current_target oc
                case '*'
                    if test "$current_target" = nvim
                        set -a nvim_args $arg
                    else
                        set -a oc_args $arg
                    end
            end
        end
    end

    # Detect bare repo and find default worktree for nvim
    set -l nvim_cd ""
    if git rev-parse --is-bare-repository 2>/dev/null | grep -q true
        # Find default branch worktree: try master, main, develop in order
        for branch in master main develop
            if test -d "./$branch" -a -f "./$branch/.git"
                set nvim_cd $branch
                break
            end
        end
    end

    # Build and run nvim command in current pane
    if test -n "$nvim_cd"
        # cd into worktree, then run nvim
        if test (count $nvim_args) -gt 0
            tmux send-keys "cd $nvim_cd && nvim $nvim_args" Enter
        else
            tmux send-keys "cd $nvim_cd && nvim" Enter
        end
    else
        if test (count $nvim_args) -gt 0
            tmux send-keys "nvim $nvim_args" Enter
        else
            tmux send-keys "nvim" Enter
        end
    end

    # Create 50% vertical split and run oc (stays in bare root if applicable)
    tmux split-window -h -p 50

    if test (count $oc_args) -gt 0
        tmux send-keys "oc $oc_args" Enter
    else
        tmux send-keys "oc" Enter
    end

    # Focus back on left pane (nvim)
    tmux select-pane -L
end
