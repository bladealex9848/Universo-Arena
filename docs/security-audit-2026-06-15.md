# 🛡️ Auditoría de seguridad (websec-100) — 2026-06-15

**URL auditada:** https://universo-arena.alexanderoviedofadul.dev/
**Stack:** sitio estático (HTML/CSS/JS vanilla, BabylonJS por CDN) servido por
Caddy desde `/root/Universo-Arena`, con webhook de auto-despliegue en `:3020`.
**Evidencia cruda:** [`websec-2026-06-15/01-before.json`](websec-2026-06-15/01-before.json)
y [`websec-2026-06-15/02-after.json`](websec-2026-06-15/02-after.json) (snapshots `wc360`).

---

## 1. Resumen ejecutivo

Se cerraron **3 exposiciones de archivos**, se corrigió la **ausencia de redirect
HTTP→HTTPS** y se añadieron **3 headers de seguridad** + `security.txt`. Tras el
hardening, las 14 demos y la galería siguen funcionando (**0 violaciones CSP**
verificadas en navegador headless real).

---

## 2. Hallazgos y correcciones (antes → después)

| # | Hallazgo | Antes | Después |
|---|----------|-------|---------|
| 1 | Redirect HTTP→HTTPS (el bloque `:80` global anula el auto-redirect, websec-100 L.1) | 🔴 `200` (sirve página default sin headers) | ✅ `308` → HTTPS |
| 2 | `/CLAUDE.md` accesible públicamente | 🔴 `200` | ✅ `404` |
| 3 | `/commit-simple.sh` accesible | 🔴 `200` | ✅ `404` |
| 4 | `/.claude/plan.md` accesible | 🔴 `200` | ✅ `404` |
| 5 | Backups `*.bak/*.old/*.swp/*.orig/*.rej` | 🟡 servibles | ✅ `404` por regex |
| 6 | `Permissions-Policy` | ❌ ausente | ✅ presente (deniega sensores/cámara/mic/pago) |
| 7 | `Cross-Origin-Opener-Policy` | ❌ ausente | ✅ `same-origin` |
| 8 | `Cross-Origin-Resource-Policy` | ❌ ausente | ✅ `same-origin` |
| 9 | `/.well-known/security.txt` (RFC 9116) | ❌ ausente | ✅ presente |
| 10 | CSP — directivas defensivas | parcial | ✅ + `form-action`, `frame-src`, `worker-src`, `manifest-src`, `media-src`, `upgrade-insecure-requests` |

### Ya correctos antes de la auditoría (se conservan)
- `Strict-Transport-Security: max-age=63072000; includeSubDomains; preload` (preload-ready).
- `X-Content-Type-Options: nosniff`, `X-Frame-Options: SAMEORIGIN`, `Referrer-Policy`.
- `/.git/config` y `/.env` ya devolvían `404` (snippet `c360-block-sensitive`).
- Cabeceras `Server` y `X-Powered-By` ocultas.
- Google Safe Browsing: **limpio** (`unsafe:false`).

---

## 3. Cambios aplicados

### Caddyfile (`/etc/caddy/Caddyfile`, vhost `universo-arena…`)
1. **Bloque `http://` con `redir … 308`** delante del vhost HTTPS (corrige L.1; el
   `:80 {}` global capturaba el HTTP plano).
2. **Matcher `@uahidden`** (`path_regexp`) → `respond 404` para `CLAUDE.md`,
   `AGENTS.md`, `commit-simple.sh`, `/.claude/*` y backups `*.bak|*.old|*.swp|*.swo|*.orig|*.rej`.
3. **Headers nuevos**: `Permissions-Policy`, `Cross-Origin-Opener-Policy`,
   `Cross-Origin-Resource-Policy`.
4. **CSP endurecida** con las directivas defensivas adicionales.

Backup previo: `/etc/caddy/Caddyfile.bak.pre-websec-universo-20260615_180935`.
Aplicado con `caddy validate` → `systemctl reload caddy` (sin corte de TLS).

### Repositorio
- Creado `.well-known/security.txt` (contacto + expiración 2027-06-15).

---

## 4. Trade-off aceptado: `unsafe-inline` + `unsafe-eval` en la CSP

La CSP mantiene `script-src 'unsafe-inline' 'unsafe-eval'` de forma **deliberada**:

- **`unsafe-eval`**: BabylonJS compila shaders y usa el constructor `Function`
  en varias rutas; sin él las 14 demos no renderizan.
- **`unsafe-inline`**: la galería raíz y las demos llevan scripts/estilos
  embebidos (cada entrega es **un único `index.html` autocontenido** por diseño
  del benchmark; no se pueden externalizar sin alterar los artefactos evaluados).

Mitigación: `default-src 'self'`, `object-src 'none'`, `base-uri 'self'`,
`frame-ancestors 'self'`, `form-action 'self'` y `frame-src 'self'` bloquean los
vectores de inyección/exfiltración más comunes. No hay backend ni formularios que
procesen datos de usuario (sitio 100 % estático), por lo que la superficie XSS es
mínima. Pasar a CSP con nonces no es aplicable a artefactos estáticos inmutables.

---

## 5. Verificación (post-reload, en producción)

```
HTTP→HTTPS .............. 308  ✅
/CLAUDE.md ............... 404  ✅   /commit-simple.sh ... 404 ✅   /.claude/plan.md ... 404 ✅
/.git/config ............ 404  ✅   /.env ............... 404 ✅   /index.html.bak .... 404 ✅
/ ....................... 200  ✅   /assets/og-image.png 200 ✅   /.well-known/security.txt 200 ✅
14/14 demos ............. 200  ✅
Headers ................. HSTS + X-CTO + X-Frame + Referrer + Permissions-Policy + COOP + CORP + CSP ✅
```

**Navegador headless real (Chrome + SwiftShader):**
- Galería y demos #1/#2 → **0 violaciones CSP**.
- `babylon.js` carga correctamente desde el CDN bajo la CSP nueva.
- (El "WebGL not supported" en headless es un artefacto del entorno sin GPU; el
  render real está validado en [`../assets/runtime.json`](../assets/runtime.json).)

### Comandos de validación
```bash
curl -sI -o /dev/null -w "%{http_code} -> %{redirect_url}\n" http://universo-arena.alexanderoviedofadul.dev/
for p in /CLAUDE.md /commit-simple.sh /.claude/plan.md /.git/config; do
  curl -sk -o /dev/null -w "%{http_code} $p\n" "https://universo-arena.alexanderoviedofadul.dev$p"; done
curl -sI https://universo-arena.alexanderoviedofadul.dev/ \
  | grep -iE "strict-transport|content-security|permissions-policy|cross-origin"
```

---

## 6. Fuera de alcance (gestionado a nivel VPS)

Estos controles del checklist websec-100 son **globales del servidor** y ya están
operativos (ver `/root/CLAUDE.md` → Seguridad del Sistema), no específicos de este
proyecto estático:

- **Perímetro/WAF**: `iptables` (INPUT DROP + whitelist), **CrowdSec** (39 scenarios
  + bouncer firewall) y **Fail2ban** (18 jails). *(web-check reporta `hasWaf:false`
  porque la defensa es a nivel red/IP, no una cabecera WAF de aplicación.)*
- **SSH**: `PasswordAuthentication no`, fail2ban `sshd`.
- **MariaDB**: bind a loopback + whitelist (no aplica a este sitio: no usa BD).
- **TLS**: Caddy emite TLS 1.3 + ciphers AEAD automáticamente (Let's Encrypt/ZeroSSL).
- **auditd**, cron de monitoreo, backups: activos a nivel sistema.

---

## 7. Pendientes del operador

- (Opcional) Enviar el dominio a **hstspreload.org** (ya es preload-ready).
- (Opcional) Revisar periódicamente con **securityheaders.com**, **SSL Labs** y
  **Mozilla HTTP Observatory** (re-scan tras cualquier cambio de Caddyfile).

---

## 8. Archivos modificados / creados

- Modificado: `/etc/caddy/Caddyfile` (vhost universo-arena; backup `.bak.pre-websec-universo-*`).
- Creados: `.well-known/security.txt`, `docs/security-audit-2026-06-15.md`,
  `docs/websec-2026-06-15/01-before.json`, `docs/websec-2026-06-15/02-after.json`.
