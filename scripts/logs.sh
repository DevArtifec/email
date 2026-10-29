#!/bin/sh
# Live mail log tail (postfix + dovecot, docker-mailserver unified log).
docker logs -f --tail "${1:-100}" drogist-mail
