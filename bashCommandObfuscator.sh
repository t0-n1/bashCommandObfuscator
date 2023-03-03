#!/bin/bash

inputCommand="$1"

outputCommand=''
partialCommand=''

function closeCommand {
    if [ "$partialCommandClosed" == 'false' ]; then
            partialCommand='$\'"'"$partialCommand'\'"'"
            partialCommandClosed='true'
    fi
}

for (( i=0; i < ${#inputCommand}; i++ )); do
    letter="${inputCommand:$i:1}"
    if grep -qP '[ |;]' <<< $letter; then
        echo "$letter"
        closeCommand
        outputCommand=$outputCommand$partialCommand'\'$letter
        partialCommand=''
    else
        octal=`printf "%o\n" "'$letter"`
        binary=`printf "%08d" $(echo "obase=2; $octal" | bc)`
        echo -e "$letter\t$octal\t$binary"
        partialCommand=$partialCommand'\\$(($((1<<1))#'$binary'))'
        partialCommandClosed='false'
    fi
done

echo

closeCommand
outputCommand=$outputCommand$partialCommand

echo '$0<<<'$outputCommand
