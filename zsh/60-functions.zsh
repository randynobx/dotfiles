# 60-functions.zsh - shell functions

# up [n]: cd up n directories (default 1)
up() {
    local i x=''
    for i in {1..${1:-1}}; do
        x+='../'
    done
    cd $x
}

# ra: start ranger, or return to it if this shell is already inside one
ra() {
    if [[ -z $RANGER_LEVEL ]]; then
        ranger
    else
        exit
    fi
}

# cheat [filter]: list aliases, git aliases and functions with descriptions
# Built from the comments in zsh/*.zsh and gitconfig, so describe new aliases
# with a trailing comment and functions with a "name [args]: what it does"
# comment line above them. Pages through less only if it won't fit on screen.
cheat() {
    emulate -L zsh
    local dir=$ZSH_CONFIG_DIR
    [[ -d $dir ]] || { print -u2 "cheat: ZSH_CONFIG_DIR not set"; return 1 }
    local color=0
    [[ -t 1 ]] && color=1

    awk -v filter="$*" -v color=$color -v gitcfg="${dir:h}/gitconfig" '
        function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
        function short(s) { return length(s) > 36 ? substr(s, 1, 33) "..." : s }
        function add(sec, name, cmd, desc,   hay) {
            hay = tolower(name " " cmd " " desc)
            if (filter != "" && index(hay, tolower(filter)) == 0) return
            row[sec, ++n[sec]] = sprintf("  %s%-9s%s %-36s  %s", G, name, R, short(cmd), desc)
        }
        BEGIN { B = color ? "\033[1m" : ""; G = color ? "\033[32m" : ""; R = color ? "\033[0m" : ""
                sq = sprintf("%c", 39) }

        # gitconfig: entries inside [alias]
        FILENAME == gitcfg {
            if ($0 ~ /^\[/) { inalias = ($0 ~ /^\[alias\]/); next }
            if (inalias && $0 ~ /=/) {
                line = $0; desc = ""
                if ((i = index(line, "  #")) > 0) { desc = trim(substr(line, i + 3)); line = substr(line, 1, i - 1) }
                eq = index(line, "=")
                add("git", trim(substr(line, 1, eq - 1)), trim(substr(line, eq + 1)), desc)
            }
            next
        }

        # zsh files: aliases
        /^[ \t]*alias [A-Za-z0-9_-]+=/ {
            s = $0; sub(/^[ \t]*alias /, "", s)
            eq = index(s, "="); name = substr(s, 1, eq - 1); rest = substr(s, eq + 1)
            desc = ""
            if (substr(rest, 1, 1) == sq) {
                rest = substr(rest, 2); q = index(rest, sq)
                cmd = substr(rest, 1, q - 1); after = substr(rest, q + 1)
            } else { cmd = rest; after = "" ; sub(/[ \t].*/, "", cmd) }
            if ((h = index(after, "#")) > 0) desc = trim(substr(after, h + 1))
            add("alias", name, cmd, desc)
            comment = ""; next
        }

        # zsh files: functions, described by the comment line(s) just above
        /^#/ { c = trim(substr($0, 2)); if (comment == "") comment = c; next }
        /^[a-z][a-z0-9_]*\(\) *\{/ {
            name = $0; sub(/\(.*/, "", name)
            if (name !~ /^(zshaddhistory|precmd|preexec|chpwd)$/) {
                usage = ""; desc = comment
                # "name [args]: description" -> usage + description
                if (index(comment, name) == 1 && (k = index(comment, ": ")) > 0) {
                    usage = substr(comment, 1, k - 1); desc = substr(comment, k + 2)
                    if (usage == name) usage = ""
                }
                add("func", name, usage, desc)
            }
            comment = ""; next
        }
        { comment = "" }

        END {
            split("alias git func", order, " ")
            title["alias"] = "shell aliases"
            title["git"]   = "git aliases  (git <name>)"
            title["func"]  = "functions"
            for (o = 1; o <= 3; o++) {
                s = order[o]; if (!n[s]) continue
                if (printed++) print ""
                print B title[s] R
                for (i = 1; i <= n[s]; i++) print row[s, i]
            }
            if (!printed) print "no matches for: " filter
        }
    ' $dir/*.zsh(N) ${dir:h}/gitconfig |
        if (( color )); then less -FRX; else cat; fi
}
