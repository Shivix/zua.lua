complete -c zua -n '__fish_use_subcommand' -f -a add   -d 'Adds the provided path to the data file'
complete -c zua -n '__fish_use_subcommand' -f -a clean -d 'Removes any invalid paths from the data file'
complete -c zua -n '__fish_use_subcommand' -f -a edit  -d 'Open up the data file in $EDITOR.'
complete -c zua -n '__fish_use_subcommand' -f -a init  -d 'Outputs the required shell code to be added to shell config'

complete -c zua -l help -s h -d "Print usage"
complete -c zua -l version -s v -d "Print version"
