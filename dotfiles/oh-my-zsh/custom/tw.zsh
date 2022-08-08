# Task/Time warrior related items.

# Task Warrior
alias tin='task add +in'

#: GTD Tickle
tickle () {
    deadline=$1
    shift
    task add +in +tickle wait:$deadline $@
}
alias tick=tickle

alias think='tickle +1d'
