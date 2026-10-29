#!/bin/sh
# Print the DNS-ready DKIM public record for each domain (verify before publishing).
for d in /opt/drogist-mail/config/opendkim/keys/*/; do
  [ -d "$d" ] || continue
  echo "== $(basename "$d") =="
  cat "$d"mail.txt 2>/dev/null || echo "no mail.txt — run: docker exec drogist-mail setup config dkim domain $(basename "$d")"
done
