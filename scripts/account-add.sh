#!/bin/sh
# Create a mailbox: ./account-add.sh vera@mail.bedenwellnessflevoland.nl 'PASSWORD'
set -eu
[ $# -ge 2 ] || { echo "usage: $0 user@domain 'password'"; exit 1; }
docker exec drogist-mail setup email add "$1" "$2"
echo "created $1 — list all: ./account-list.sh"
