function string_to_bytes
    if test (count $argv) -eq 0
        echo "Usage: string_to_bytes <string>"
        return 1
    end

    set input_string $argv[1]

    echo -n "["
    printf '%s' "$input_string" | od -t u1 -A n | tr -s ' ' | sed 's/^ *//' | sed 's/ *$//' | tr ' ' ','
    echo "]"
end
