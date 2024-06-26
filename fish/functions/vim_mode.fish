function vim_mode
    switch $fish_bind_mode
        case default
            echo N
        case insert
            echo I
        case replace_one
            echo R
        case visual
            echo V
        case '*'
            echo '?'
    end
end
