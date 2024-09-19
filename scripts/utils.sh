# This is a utility library and not meant to be called directly

function git_branch {
    local git_status="$(git status 2> /dev/null)"
    local on_branch="On branch ([^${IFS}]*)"
    local on_commit="HEAD detached at ([^${IFS}]*)"

    if [[ $git_status =~ $on_branch ]]; then
        local branch=${BASH_REMATCH[1]}
        echo -n "$branch"
	return
    fi
    echo -n ""
    exit -1
}

function find_upwards {
    DIR=$(readlink -f "$1")

    while
        RESULT=$(find "$DIR"/ -maxdepth 1 -name "$2")
        # echo "Debugging upfind - search in $DIR gives: $RESULT"
        [[ -z $RESULT ]] && [[ "$DIR" != "/" ]]
    do DIR=$(dirname "$DIR"); done

    if [[ ! -z $RESULT ]]; then
        realpath --relative-to="$1" "$RESULT"
    fi
}
