function hd --description 'Start or attach to the isolated Herdr Casebook trial'
    set -l trial_config "$HOME/.config/herdr/trials/casebook/config.toml"

    if test (count $argv) -ne 0
        echo 'hd: arguments are not accepted; this command only attaches casebook-trial' >&2
        return 64
    end

    if not type -q herdr
        echo 'hd: Herdr is not installed or not on PATH' >&2
        return 127
    end

    if not test -f "$trial_config"
        echo "hd: missing trial config: $trial_config" >&2
        return 78
    end

    command env HERDR_CONFIG_PATH="$trial_config" herdr --session casebook-trial
end
