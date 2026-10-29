# config/ — mounted at `/tmp/docker-mailserver`

docker-mailserver reads every file in this directory on container start.
On the VPS this lives at `/opt/drogist-mail/config` — **do not commit its contents**:
it contains mailbox definitions and the DKIM private key.

Expected live contents (reference):

| Path | What it is |
|---|---|
| `postfix-accounts.cf` | Mailbox credentials — created by `setup email add user@domain` |
| `postfix-virtual.cf` | Aliases (optional) |
| `opendkim/keys/<domain>/mail.private` | **Private DKIM key — never commit/publish** |
| `opendkim/keys/<domain>/mail.txt` | DNS TXT record to publish (public part) |
| `ssl/` | Cert material when SSL_TYPE=manual |

Manage accounts/keys through `docker exec drogist-mail setup …`
(see `scripts/`) rather than editing these files by hand.
