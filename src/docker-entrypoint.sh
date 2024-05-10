#!/bin/sh

for var in $(env | cut -f1 -d"="); do
    if [[ $var =~ .*_FILE ]]
    then
		file=$(eval "echo \$$var")
		val=$(cat $file)
		export ${var%_FILE}=\"$val\"
    fi
done

exec "$@"
