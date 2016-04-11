#!/bin/bash

set -e

mv /pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
mv /postgresql.conf /var/lib/postgresql/data/postgresql.conf

exists() {
  gosu postgres pg_ctl -w start 2>&1 1>/dev/null
  set +e
  gosu postgres psql -q -U postgres ${DB_NAME} -c '' 2>&1 1>/dev/null
  connected=$?
  set -e
  gosu postgres pg_ctl -w stop
  return $connected
}

# HACK(mtwilliams): Only create the database and user if they do not already exist.
if exists; then
  echo "Database already exists :)"
  exit 0
fi

echo "=== CREATING DATABASE '${DB_NAME}' FOR '${DB_NAME}' ==="
gosu postgres postgres --single <<-EOSQL
  CREATE DATABASE ${DB_NAME} WITH ENCODING='UTF-8';
  GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to postgres;
  CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';
  GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};
  ALTER SCHEMA public OWNER TO ${DB_USER};
  ALTER DATABASE ${DB_NAME} OWNER TO ${DB_USER};

  CREATE EXTENSION hstore;
  CREATE EXTENSION dblink;
EOSQL
echo ""
echo ""
echo "=========="
