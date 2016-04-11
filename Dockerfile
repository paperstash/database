FROM postgres:9.4.1
MAINTAINER Michael Williams
ENV REFRESHED_AT 2016-04-10

ADD ./initialize.sh /docker-entrypoint-initdb.d/initialize.sh
ADD ./pg_hba.conf /pg_hba.conf
ADD ./postgresql.conf /postgresql.conf
