function diff_latest_vector_tags
    # Find all existing vector tags
    set vector_tags (git tag -l "vector-*" | sort -V 2>/dev/null)
    if test (count $vector_tags) -lt 2
        echo "Not enough tags to compare diffs"
    else
        # Extract the highest version
        set highest_version $vector_tags[-1]
        echo $vector_tags[-1]
        echo $vector_tags[-2]
        git diff --name-only $vector_tags[-2] $vector_tags[-1]
    end
end
