if status is-interactive
    # Commands to run in interactive sessions can go here
end

#fish_config theme choose Nord
set -g fish_key_bindings fish_vi_key_bindings

fish_add_path /opt/homebrew/bin
fish_add_path ~/.config/scripts/
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin/
fish_add_path ~/.bun/bin
fish_add_path ~/.rvm/bin
fish_add_path ~/opt/homebrew/opt/ruby/bin

alias l='eza -alg --icons'
alias lt='eza -lg --tree --level=2 --icons'
alias ls='eza -g --icons'
alias vim=nvim
alias v=nvim
alias grep=rg
alias ta='tmux attach'
alias al='aws-okta login'
alias ac='aws-okta creds'
zoxide init --cmd cd fish | source

bind --user -M insert \ce forward-char
bind --user -M insert \cn tmux-sessionizer
bind --user -M insert \cf tmux-session-picker

bass source ~/.nvm/nvm.sh --no-use ';'

#Disable shell startup text
set -g fish_greeting

set -x EDITOR nvim
set -x VISUAL nvim
set -x XDG_CONFIG_HOME ~/.config/
set -x DOCKER_HOST unix:///$HOME/.colima/docker.sock

set nord0 2e3440
set nord1 3b4252
set nord2 434c5e
set nord3 4c566a
set nord4 d8dee9
set nord5 e5e9f0
set nord6 eceff4
set nord7 8fbcbb
set nord8 88c0d0
set nord9 81a1c1
set nord10 5e81ac
set nord11 bf616a
set nord12 d08770
set nord13 ebcb8b
set nord14 a3be8c
set nord15 b48ead

set fish_color_normal $nord4
set fish_color_command $nord9
set fish_color_quote $nord14
set fish_color_redirection $nord9
set fish_color_end $nord6
set fish_color_error $nord11
set fish_color_param $nord4
set fish_color_comment $nord3
set fish_color_match $nord8
set fish_color_search_match $nord8
set fish_color_operator $nord9
set fish_color_escape $nord13
set fish_color_cwd $nord8
set fish_color_autosuggestion $nord5
set fish_color_user $nord4
set fish_color_host $nord9
set fish_color_cancel $nord15
set fish_pager_color_prefix $nord13
set fish_pager_color_completion $nord6
set fish_pager_color_description $nord10
set fish_pager_color_progress $nord12
set fish_pager_color_secondary $nord1

source ~/.config/fish/work_env.fish

starship init fish | source
enable_transience
start_or_attach_tmux
