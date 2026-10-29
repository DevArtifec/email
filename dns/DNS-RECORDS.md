# DNS records — drogist-mail

Zone: `bedenwellnessflevoland.nl` (GoDaddy). **Only the `mail` subdomain** — the apex
serves a separate site on Google Workspace (`MX smtp.google.com`, `SPF include:_spf.google.com`);
do not touch apex records.

| Type | Name | Value | Priority / TTL |
|---|---|---|---|
| A | `mail` | `145.14.157.73` | — / 600 |
| MX | `mail` | `mail.bedenwellnessflevoland.nl` | 10 / 600 |
| TXT | `mail` | `v=spf1 mx -all` | — / 600 |
| TXT | `mail._domainkey.mail` | DKIM public key below | — / 600 |
| TXT | `_dmarc.mail` | `v=DMARC1; p=quarantine; adkim=r; aspf=r` | — / 600 |

**PTR (Hostinger panel):** `145.14.157.73` → `mail.bedenwellnessflevoland.nl`
(was `srv967886.hstgr.cloud` at the 2026-10-14 check — must be set for inbox delivery).

## DKIM public key (verified on the server 2026-10-14)

Paste as **one string**, no line breaks:

```
v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqoGSJM3U3AYrcEBOz+RkPghLz9VFJNuL8+IVcMJvvrjiKCLaE5U9c5ikNfk+9HifvnUv9A9sDwDyBURJiPxU+8r4rSZ1lXMhlAOfwpD2SR9YRxrY70nGsUofz+hTjkQE5TIQw9fQb2MrR7HdEYl+ekJ2Zl0mzHuaYp15E2CHgN/VDwiDDJRVNSUei83aqB8h2gwtkDSD2mdcO/4LUoHBbwtdBB3cjZJTOhNfbFWdqz688jb03iiFMsqLlXff249tv8Zj4oQ1Zq/BsgvTC6wWVERRDlgZ4smWNTg57mJQxr8EvRWa99JrSrZJBVGb0Fkb9thl+6oYD26jMd7t0unUHwIDAQAB
```

This is a *public* key by design — the private key lives in `config/opendkim/keys/` on the VPS
and is never committed or published. **Re-verify against `scripts/dkim-public.sh` before
publishing — it may have been rotated.**

## Status notes (handover 2026-10-14)

- The five subdomain records were **not resolvable** at handover — this file is a publication
  plan, not proof of external delivery.
- After publishing: `dig MX mail.bedenwellnessflevoland.nl`, `dig TXT mail._domainkey.mail`,
  then a real outbound test to a controlled mailbox (check DKIM-Signature + SPF pass headers).
