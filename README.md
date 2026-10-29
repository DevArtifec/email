# email — drogist-mail

Standalone mail server for the drogist.ai stack, running on the Hostinger VPS
(`145.14.157.73`, `srv967886.hstgr.cloud`) as the `drogist-mail` container.

[docker-mailserver](https://docker-mailserver.github.io/docker-mailserver/v14.0/) `14.0.0` —
Postfix + Dovecot + OpenDKIM/OpenDMARC + Fail2ban in one container. It serves the
`mail.bedenwellnessflevoland.nl` identity that n8n workflows use to send drogist.ai mail
(login magic links, drogist escalations) — sender `vera@mail.bedenwellnessflevoland.nl`.

## Layout on the VPS

```
/opt/drogist-mail/
  docker-compose.yml   ← this repo's compose (deployed copy)
  mailserver.env       ← from mailserver.env.example (gitignored)
  config/              → /tmp/docker-mailserver  (accounts, DKIM keys, TLS — never commit)
  mail-data/           → /var/mail               (mailboxes)
  mail-state/          → /var/mail-state         (rspamd/clamav/fail2ban state)
  mail-logs/           → /var/log/mail
```

Docker network: `root_default` (external — shared with `root-n8n-1`, `root-traefik-1`).
**Never restart the whole stack for a mail change**; restart only `drogist-mail`.

## Deploy / update

```sh
ssh <vps>
cd /opt/drogist-mail
# place updated docker-compose.yml + mailserver.env here, then:
docker compose up -d mailserver
scripts/health.sh          # container status + listeners + supervisor
scripts/logs.sh 200        # follow the unified mail log
```

## DNS

`dns/DNS-RECORDS.md` — the five `mail.*` records (A/MX/SPF/DKIM/DMARC) + Hostinger PTR.
Only the subdomain is touched; the apex stays on Google Workspace.
Verify `scripts/dkim-public.sh` output against the file before publishing.

## Accounts

```sh
scripts/account-add.sh vera@mail.bedenwellnessflevoland.nl 'STRONG-PASSWORD'
scripts/account-list.sh
```

The n8n SMTP credential uses the mailbox + this server. On the shared `root_default`
network the host is `drogist-mail` port `587` — from outside it's
`mail.bedenwellnessflevoland.nl:587` (STARTTLS).

## TLS

`SSL_TYPE=self-signed` today — a test configuration. Before trusted/production delivery:

1. `SSL_TYPE=letsencrypt` in `mailserver.env` (or mount manual certs + `SSL_TYPE=manual`),
   `docker compose up -d`.
2. Remove `allowUnauthorizedCerts` from the n8n SMTP credentials.
3. Re-test outbound + IMAPS.

## Known gaps (handover 2026-10-14, still open)

- The five `mail.*` DNS records were **not resolvable** at handover — publish + verify
  per `dns/DNS-RECORDS.md`, then run a real external send test.
- PTR for `145.14.157.73` must be set to `mail.bedenwellnessflevoland.nl` in the Hostinger
  panel (was `srv967886.hstgr.cloud`). No PTR = spam-folder delivery at best.
- Self-signed TLS (above).
- The compose healthcheck already carries the `--numeric` fix for the
  `:smtp`-vs-`:25` probe false-negative.

## Ops scripts

| Script | What it does |
|---|---|
| `health.sh` | Container status + SMTP/IMAP listeners + supervisorctl |
| `logs.sh [N]` | Tail N lines of the unified mail log (`-f`) |
| `mail-queue.sh [flush]` | Postfix queue / flush |
| `account-add.sh`, `account-list.sh` | Mailbox management |
| `dkim-public.sh` | DNS-ready DKIM record per domain |
| `backup.sh` | tar config + state + mailboxes to `/opt/drogist-mail-backup-*.tar.gz` |

## Boundaries

- No secrets in this repo — mailbox passwords, DKIM private keys and `mailserver.env`
  stay on the VPS (`config/opendkim/keys/` is gitignored).
- App-side senders live elsewhere: n8n workflows (`drogist-mail` webhook) and the app's
  `MAIL_WEBHOOK_URL`/`N8N_WEBHOOK_SECRET` — this repo is only the server itself.
