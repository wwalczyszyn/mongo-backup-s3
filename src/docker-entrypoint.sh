#!/bin/sh

for var in $(env | cut -f1 -d"="); do
    if [[ $var =~ .*_FILE ]]
    then
		file=$(eval "echo \$$var")
		if test -f $file; then
			val=`cat $file`
			eval "export \"\$$var\"=\"$val\""
		fi
		echo $MONGO_PASSWORD
    fi
done

exec "$@"
