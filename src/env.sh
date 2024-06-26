for var in $(env | cut -f1 -d"="); do
    if [[ $var =~ .*_FILE ]]
    then
		file=$(eval "echo \$$var")
		val=$(cat $file)
		export ${var%_FILE}=$val
    fi
done

if [ -z "$S3_BUCKET" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "$MONGO_DATABASE" ]; then
  echo "You need to set the MONGO_DATABASE environment variable."
  exit 1
fi

if [ -z "$MONGO_HOST" ]; then
    echo "You need to set the MONGO_HOST environment variable."
    exit 1
fi

if [ -z "$MONGO_USER" ]; then
  echo "You need to set the MONGO_USER environment variable."
  exit 1
fi

if [ -z "$MONGO_PASSWORD" ]; then
  echo "You need to set the MONGO_PASSWORD environment variable."
  exit 1
fi

if [ -z "$S3_ENDPOINT" ]; then
  aws_args=""
else
  aws_args="--endpoint-url $S3_ENDPOINT"
fi


if [ -n "$S3_ACCESS_KEY_ID" ]; then
  export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
fi
if [ -n "$S3_SECRET_ACCESS_KEY" ]; then
  export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
fi
export AWS_DEFAULT_REGION=$S3_REGION
