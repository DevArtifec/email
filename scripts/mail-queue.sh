#!/bin/sh
# Postfix queue + optional flush.
case "${1:-}" in
  flush) docker exec drogist-mail postqueue -f ;;
  *) docker exec drogist-mail mailq ;;
esac
