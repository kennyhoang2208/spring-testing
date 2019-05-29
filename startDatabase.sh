#! /bin/bash

docker stop demo-postgres
docker rm demo-postgres
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=pQoXKj9oPX -e POSTGRES_USER=postgres -d postgres

# spring.datasource.url = jdbc:postgresql://35.184.111.61:5432/postgres
# spring.datasource.url = jdbc:postgresql://127.0.0.1:15432/postgres
# spring.datasource.url = jdbc:postgresql://jx-testdb:5432/postgres
# spring.datasource.username = postgres
# spring.datasource.password = pQoXKj9oPX
# spring.datasource.platform = POSTGRESQL