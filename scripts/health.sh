#!/bin/sh
# Read-only health check: container status, listeners, supervisor services.
set -eu
docker ps --format '{{.Names}} {{.Status}}' | grep drogist-mail
docker exec drogist-mail ss --listening --tcp --numeric | grep -E ':(25|465|587|993) ' || true
docker exec drogist-mail supervisorctl status || true
