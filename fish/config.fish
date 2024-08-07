if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_config theme choose Nord
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
alias f=fuck
alias ts=tmux-sessionizer
alias tp=tmux-session-picker
alias ta='tmux attach'
alias al='aws-okta login'
alias ac='aws-okta creds'
zoxide init --cmd cd fish | source

bind --user -M insert \ce forward-char
bind --user -M insert \cn tmux-sessionizer
bind --user -M insert \cf tmux-session-picker

#Disable shell startup text
set -g fish_greeting

set -x EDITOR nvim
set -x VISUAL nvim
set -x XDG_CONFIG_HOME ~/.config/
set -x DOCKER_HOST unix:///$HOME/.colima/docker.sock
