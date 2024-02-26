if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path ~/.config/scripts/
fish_add_path ~/.cargo/bin
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
zoxide init --cmd cd fish | source

bind --user -M insert \ce forward-char
bind --user -M insert \cn tmux-sessionizer
bind --user -M insert \cf tmux-session-picker

#Disable shell startup text
set -g fish_greeting

set EDITOR nvim
set VISUAL nvim
set XDG_CONFIG_HOME ~/.config/
set DOCKER_HOST unix:///$HOME/.colima/docker.sock
thefuck --alias | source
