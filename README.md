# Sabina Bonardi — Sito Web Logopedista

Landing page / vetrina professionale per la Dott.ssa Sabina Bonardi, logopedista iscritta all'Albo TSRM PSTRP di Brescia (n. 132). Presenta servizi, formazione, metodo di lavoro, sedi e contatti.

## Stack Tecnologico

Sito **completamente statico**: HTML5, CSS3 e JavaScript vanilla, zero dipendenze e zero step di build.

- **Font:** Cormorant Garamond (titoli) + Nunito (corpo testo)
- **Immagini:** AVIF con fallback PNG
- **Interazioni:** navbar sticky, menu mobile, reveal on scroll (IntersectionObserver)

## Struttura del Progetto

```
sabina-bonardi/
├── README.md
├── deploy.sh                 # deploy alternativo via rsync (vedi sotto)
├── nginx.conf.example        # config Nginx di esempio, da personalizzare
└── public/
    ├── index.html
    ├── style.css
    ├── main.js
    ├── _headers              # header per Cloudflare Pages
    └── images/
```

## Anteprima locale

Dalla cartella `public/`:

```bash
python3 -m http.server 8032 --bind 0.0.0.0
```

Poi apri `http://localhost:8032/`.

## Deploy su Cloudflare Pages

Il sito è pensato per essere pubblicato direttamente su Cloudflare Pages:

- **Framework preset:** `None`
- **Build command:** (vuoto)
- **Build output directory:** `public`
- **Root directory:** `/`

Il file `public/_headers` imposta cache lunga e immutabile per le immagini e alcuni header di sicurezza di base per tutte le pagine.

## Form contatti (Web3Forms)

Il form invia i dati via POST a `https://api.web3forms.com/submit` usando [Web3Forms](https://web3forms.com/). La `access_key` è visibile lato client per design del servizio: la sicurezza va garantita limitando i domini autorizzati dalla dashboard Web3Forms, non nascondendo la chiave.

## Deploy alternativo (rsync)

In alternativa a Cloudflare Pages, `deploy.sh` permette di pubblicare il contenuto di `public/` su un server Nginx proprio via rsync, configurando Nginx e ottenendo un certificato Let's Encrypt con Certbot. Va configurato tramite variabili d'ambiente, senza valori hardcoded nel repo:

```bash
DEPLOY_HOST=utente@host DEPLOY_DIR=/var/www/sito DOMAIN=example.com ./deploy.sh
```

`nginx.conf.example` è un riferimento di configurazione Nginx da adattare (path e dominio reali) se si usa questa modalità di deploy.

## Licenza

Il **codice** del sito (HTML/CSS/JS) è distribuito con licenza MIT, © 2026 Marco De Bona. I **contenuti** (testi, fotografie, immagini, nome e marchio della professionista) sono © 2026 Sabina Bonardi, tutti i diritti riservati: nessun riutilizzo senza autorizzazione scritta, incluse le fotografie che ritraggono persone reali. Dettagli completi nel file [`LICENSE`](./LICENSE).
