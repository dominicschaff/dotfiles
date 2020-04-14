_bot()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    COMPREPLY=( $(compgen -W "me m msg i img f doc l loc u get p people" -- ${cur}) )
    return 0
}
complete -F _bot bot
