#!/bin/bash
set -e
cmd="$@"

function postgres_ready(){
node << END
const Client = require('pg').Client;

const client = new Client({
  host: process.env.EXPRESS_DB_HOST,
  port: process.env.EXPRESS_DB_PORT,
  user: process.env.EXPRESS_DB_USER,
  database: process.env.EXPRESS_DB_NAME,
  password: process.env.EXPRESS_DB_PASSWORD,
});

client.connect(function (err) {
  if (err) {
    process.exit(-1);
  };

  process.exit(0);
});
END
}

until postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 3
done

>&2 echo "Postgres is up - continuing..."
exec $cmd
