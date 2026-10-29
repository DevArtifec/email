#!/bin/sh
# Offline backup of config + state + mail data. Output: /opt/drogist-mail-backup-TS.tar.gz
# The archive contains private DKIM keys and mailbox contents — store it accordingly.
set -eu
ts=$(date +%Y%m%d-%H%M%S)
tar czf "/opt/drogist-mail-backup-$ts.tar.gz" -C /opt drogist-mail/config drogist-mail/mail-state drogist-mail/mail-data
echo "/opt/drogist-mail-backup-$ts.tar.gz"
