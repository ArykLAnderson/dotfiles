function scrape_copilot_key
    set -gx OPENAI_API_KEY (cat $XDG_CONFIG_HOME/github-copilot/apps.json | jq -r 'to_entries | .[0].value.oauth_token')
end
