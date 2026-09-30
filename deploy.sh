#!/bin/bash
set -e

# --- PARAMETRISEIDUT ARVOT ---
# Käytetään ensimmäistä argumenttia IP:nä, jos se annetaan. Muuten käytetään oletusta.
REMOTE_IP=${1:-"62.204.14.226"}
# Käytetään toista argumenttia porttina, jos se annetaan. Muuten käytetään 2376.
REMOTE_PORT=${2:-"2376"}

export DOCKER_HOST="tcp://${REMOTE_IP}:${REMOTE_PORT}"
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH="./keys/pro"
# ----------------------------

echo "🚀 Aloitetaan käyttöönotto kohteeseen: ${DOCKER_HOST}"

echo "📥 Haetaan uusimmat kuvat..."
docker-compose pull

echo "🛑 Pysäytetään vanhat palvelut..."
docker-compose down

echo "🆙 Käynnistetään uusi versio..."
docker-compose up -d

echo "🧹 Siivotaan käyttämättömät resurssit..."
docker image prune -f
docker volume prune -f || true

echo "✅ Valmista! (Done)"

echo "📊 Nykyiset kontit:"
docker-compose ps

echo "🌐 Sovellus on käytettävissä osoitteessa: http://gramps.local"
