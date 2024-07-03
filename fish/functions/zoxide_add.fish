function zoxide_add
    ls -1 | xargs -I {} zoxide add {}
end
