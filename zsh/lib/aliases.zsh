# Alias browser (replacement for OMZ's aliases plugin, without Python).

als() {
    local -a requested_groups keywords lines words group_names alias_names
    local groups_only=false argument line name value command group filter
    local -A values commands counts groups

    while (( $# )); do
        argument=$1
        shift
        case $argument in
            -h|--help)
                print 'Usage: als [keyword ...] [-g group ...] [--groups]'
                return
                ;;
            -g|--group)
                (( $# )) || { print -u2 "als: $argument requires a group"; return 1; }
                requested_groups+=("$1")
                shift
                ;;
            --groups) groups_only=true ;;
            *) keywords+=("$argument") ;;
        esac
    done

    lines=("${(@f)$(alias)}")
    for line in $lines; do
        name=${line%%=*}
        value=${(Q)${line#*=}}
        words=(${(z)value})
        command=${words[1]:-$value}
        values[$name]=$value
        commands[$name]=$command
        (( counts[$command]++ ))
    done

    for name in ${(k)values}; do
        command=${commands[$name]}
        if (( counts[$command] > 1 )); then
            groups[$command]=1
        else
            groups[_default]=1
        fi
    done

    filter="${(j: :)keywords}"
    group_names=(${(ok)groups})
    alias_names=(${(ok)values})
    for group in $group_names; do
        (( ${#requested_groups} == 0 || requested_groups[(Ie)$group] )) || continue

        local -a matches=()
        for name in $alias_names; do
            command=${commands[$name]}
            if (( counts[$command] > 1 )); then
                [[ $command == $group ]] || continue
            else
                [[ $group == _default ]] || continue
            fi
            [[ -z $filter || "$name ${values[$name]}" == *"$filter"* ]] && matches+=("$name")
        done

        (( $#matches )) || continue
        print -P "%F{red}[$group]%f"
        if [[ $groups_only != true ]]; then
            for name in $matches; do
                print -P "\t%F{green}${name//\%/%%} = ${values[$name]//\%/%%}%f"
            done
            print
        fi
    done
}
