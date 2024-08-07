#!/usr/bin/env bash

script_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
jot_file=~/.jot


main() {

    # check input and run script
    if [[ $logoff -eq 1 ]]
    then
        logoff
    elif [[ $login -eq 1 ]]
    then
        login
    elif [[ $update -eq 1 ]]
    then
        update
    else
        manual
    fi

}

write() {

    date=$(date)
    jot=$1

    if [ -z "$jot" ]
    then
        echo "[$date - $USER] -/-" >> $jot_file
    else
        echo "[$date - $USER] $jot" >> $jot_file
    fi

}

# runs before complete logoff
logoff() {

    read -p "[JOT] What have you done? " jot
    
    write "Before logoff: $jot"
}

# runs shortly after login
login() {
    read -p "[JOT] Reason for login? " jot

    write "After login: $jot"
}

# runs when manually called
manual() {
    read -p "[JOT] What has changed? " jot

    write $jot
}

# update jot software
update() {

    # check if executed with sudo permissions
    if [ "$EUID" -ne 0 ]; then
        die "Please run update with root permissions"
    fi

    if [ "$(which wget)" == "" ]; then
        die "wget not installed. Please install wget to proceed!"
    fi

    # rm old jot installer (if exists)
    if [ -e "$script_dir/install-jot.sh" ]; then
        rm $script_dir/install-jot.sh
    fi

    # pull newest install-jot.sh script and make executable
    wget -q https://raw.githubusercontent.com/vozodo/jot/main/install-jot.sh -P $script_dir


    chmod +x $script_dir/install-jot.sh

    # run update script
    /bin/bash $script_dir/install-jot.sh
    exit 0;
}

# preset messages from presets.jot file
presets() {

    # TODO
    # read presets from file
    presets_file="$script_dir/presets.jot"

    if [[ ! -f "$presets_file" ]]; then
        die "File '$presets_file' does not extis."
    fi

    # read each line and put every line into a value of the array
    readarray -t presets < "$presets_file"


    select preset in $presets
    do
        echo "He selected $preset"
    done

}

msg() {
    echo >&2 -e "${1-}"
}

usage() {
    cat <<EOF
Usage: $(
        basename "${BASH_SOURCE[0]}"
    ) [-h] [-v] [-u] [-i] [-o]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-u, --update    Update and Setup JOT
-i, --login     Asks login Question
-o, --logoff    Asks logoff Question
EOF
    exit
}

die() {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}


parse_params() {

    login=0
    logoff=0
    update=0

    while :; do
        case "${1-}" in
        -h | --help) usage ;;
        -v | --verbose) set -x ;;
        -i | --login) login=1 ;;
        -o | --logoff) logoff=1 ;;
        -u | --update) update=1 ;;
        -?*) die "Unknown option: $1" ;;
        *) break ;;
        esac
        shift
    done

    return 0
}

parse_params "$@"
main "$@"