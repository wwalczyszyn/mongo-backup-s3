#! /bin/sh

set -u # `-e` omitted intentionally, but i can't remember why exactly :'(
set -o pipefail

source ./env.sh

s3_uri_base="s3://${S3_BUCKET}/${S3_PREFIX}"

if [ -z "$PASSPHRASE" ]; then
  file_type=".dump"
else
  file_type=".dump.gpg"
fi

if [ $# -eq 1 ]; then
  timestamp="$1"
  key_suffix="${MONGO_DATABASE}_${timestamp}${file_type}"
else
  echo "Finding latest backup..."
  key_suffix=$(
    aws $aws_args s3 ls "${s3_uri_base}/${MONGO_DATABASE}" \
      | sort \
      | tail -n 1 \
      | awk '{ print $4 }'
  )
fi

echo "Fetching backup from S3..."
aws $aws_args s3 cp "${s3_uri_base}/${key_suffix}" "db${file_type}"

if [ -n "$PASSPHRASE" ]; then
  echo "Decrypting backup..."
  gpg --decrypt --batch --passphrase "$PASSPHRASE" db.dump.gpg > db.dump
  rm db.dump.gpg
fi

echo "Restoring from backup..."
mongorestore \
        --host $MONGO_HOST \
        --port $MONGO_PORT \
        --username $MONGO_USER \
        --password $MONGO_PASSWORD \
        --db $MONGO_DATABASE \
        --archive db.dump \
        --gzip \
        --drop
rm db.dump

echo "Restore complete."
