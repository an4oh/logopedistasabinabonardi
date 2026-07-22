#!/bin/bash
# Deploy script generico via rsync + Nginx + Let's Encrypt (Certbot)
# Configurare tramite variabili d'ambiente prima dell'esecuzione:
#   DEPLOY_HOST  utente@host del server remoto (es. user@example.com)
#   DEPLOY_DIR   directory remota di destinazione (es. /var/www/sito)

DEPLOY_HOST="${DEPLOY_HOST:?variabile DEPLOY_HOST non impostata (es. utente@host)}"
DEPLOY_DIR="${DEPLOY_DIR:?variabile DEPLOY_DIR non impostata (es. /var/www/sito)}"
NGINX_CONF="/etc/nginx/sites-available/sabina-bonardi"
DOMAIN="${DOMAIN:?variabile DOMAIN non impostata (es. example.com)}"

echo "==> [1/4] Copia file del sito sul server remoto..."
ssh ${DEPLOY_HOST} "sudo mkdir -p ${DEPLOY_DIR} && sudo chown \$(whoami):\$(whoami) ${DEPLOY_DIR}"
rsync -avz --delete public/ ${DEPLOY_HOST}:${DEPLOY_DIR}/

echo "==> [2/4] Installazione Nginx e Certbot (se non presenti)..."
ssh ${DEPLOY_HOST} "
  sudo apt-get update -qq &&
  sudo apt-get install -y nginx certbot python3-certbot-nginx
"

echo "==> [3/4] Configurazione Nginx iniziale (solo HTTP per il challenge)..."
ssh ${DEPLOY_HOST} "
  sudo tee /etc/nginx/sites-available/sabina-bonardi-tmp > /dev/null <<'EOF'
server {
    listen 80;
    server_name ${DOMAIN};
    root ${DEPLOY_DIR};
    index index.html;
    location / { try_files \$uri \$uri/ =404; }
}
EOF
  sudo ln -sf /etc/nginx/sites-available/sabina-bonardi-tmp /etc/nginx/sites-enabled/sabina-bonardi &&
  sudo nginx -t && sudo systemctl reload nginx
"

echo "==> [4/4] Ottenimento certificato Let's Encrypt..."
ssh ${DEPLOY_HOST} "
  sudo certbot --nginx -d ${DOMAIN} --non-interactive --agree-tos --email admin@${DOMAIN} --redirect
"

echo ""
echo "==> Installazione config Nginx definitiva (con HTTPS)..."
scp nginx.conf.example ${DEPLOY_HOST}:/tmp/sabina-bonardi.conf
ssh ${DEPLOY_HOST} "
  sudo mv /tmp/sabina-bonardi.conf ${NGINX_CONF} &&
  sudo rm -f /etc/nginx/sites-available/sabina-bonardi-tmp &&
  sudo ln -sf ${NGINX_CONF} /etc/nginx/sites-enabled/sabina-bonardi &&
  sudo nginx -t && sudo systemctl reload nginx
"

echo ""
echo "==> Rinnovo automatico certificato (cron già gestito da Certbot)."
echo "    Per verificare: ssh ${DEPLOY_HOST} 'sudo certbot renew --dry-run'"
echo ""
echo "✓  Deploy completato!"
echo "   Visita https://${DOMAIN}"
