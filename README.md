This is our Docker image for Postgres in development and production. It is intended to behave like Postgres/9.4.1 on AWS RDS.

It assumes that you will standup containers with the following environment:

 - `DB_NAME`
 - `DB_USER` and `DB_PASSWORD` for application credentials
 - `POSTGRES_USER` and `POSTGRES_PASSWORD` for superuser credentials

You can persist the database by mounting `/var/lib/postgresql/data` in the host.
