function utime()
{
    if [ $# = 1 ] && ([ "${1:0:1}" = "+" ] || [ "${1:0:1}" = "-" ]) && [ "$1" != "--help" ]
    then
        # Do date math
        date -d "$1" "+%s"
    elif [ $# = 1 ] && (echo "$1" | grep -P "^[[:digit:]]+$" > /dev/null)
    then
        # Convert timestamp to human-readable date
        date -d "@$1" || help
    elif [ $# = 0 ]
    then
        # Print timestamp
        date "+%s"
    else
        echo "$0 usage:"
        echo ""
        echo "--help: this message"
        echo "no arguments: current time as timestamp"
        echo "+10days: now plus 10 days as timestamp"
        echo "1000000: convert timestamp to human-readable date"
    fi
}
