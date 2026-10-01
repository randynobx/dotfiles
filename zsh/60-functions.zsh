# 60-functions.zsh - shell functions

# up [n]: cd up n directories (default 1)
up() {
    local i x=''
    for i in {1..${1:-1}}; do
        x+='../'
    done
    cd $x
}

# start ranger, or return to the existing one if this shell is inside it
ra() {
    if [[ -z $RANGER_LEVEL ]]; then
        ranger
    else
        exit
    fi
}
