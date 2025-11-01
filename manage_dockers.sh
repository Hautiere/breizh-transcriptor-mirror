#!/bin/bash
set -euo pipefail

# ==========================================
# 🐳 Breizh Transcriptor Docker Manager
# ==========================================
# Usage :
#   ./manage_dockers.sh rebuild   → Nettoie, reconstruit et relance les conteneurs
#   ./manage_dockers.sh stop      → Arrête et supprime les conteneurs
#   ./manage_dockers.sh clean     → Supprime conteneurs + images
#   ./manage_dockers.sh -h | --help → Affiche cette aide
# ==========================================

# --- Couleurs & icônes ---
GREEN="\033[1;32m"   # ✅ Succès
YELLOW="\033[1;33m"  # ⚠️  Info
RED="\033[1;31m"     # ❌ Erreur
BLUE="\033[1;34m"    # ℹ️  Étape
RESET="\033[0m"      # Fin de couleur

ICON_OK="🟩"
ICON_WARN="🟨"
ICON_ERR="🟥"
ICON_STEP="🟦"

# --- Variables globales ---
BACKEND_NAME="breizh_backend"
FRONTEND_NAME="breizh_frontend"

# --- Vérification que Docker est lancé ---
if ! docker info >/dev/null 2>&1; then
  echo -e "${ICON_ERR} ${RED}Docker n'est pas lancé. Ouvre Docker Desktop et réessaie.${RESET}"
  exit 1
fi

# --- Fonction aide ---
show_help() {
  echo -e "${BLUE}${ICON_STEP} Breizh Transcriptor Docker Manager${RESET}"
  echo
  echo -e "${YELLOW}Usage :${RESET}"
  echo "  ./manage_dockers.sh rebuild    → Nettoie, reconstruit et relance les conteneurs"
  echo "  ./manage_dockers.sh stop       → Arrête et supprime les conteneurs"
  echo "  ./manage_dockers.sh clean      → Supprime conteneurs + images"
  echo "  ./manage_dockers.sh -h | --help → Affiche cette aide"
  echo
  echo -e "${YELLOW}Raccourcis utiles :${RESET}"
  echo "  docker ps        → liste les conteneurs en cours"
  echo "  docker logs -f breizh_backend   → suit les logs du backend"
  echo "  docker logs -f breizh_frontend  → suit les logs du frontend"
  echo
  echo -e "${GREEN}Exemples :${RESET}"
  echo "  ./manage_dockers.sh stop"
  echo "  ./manage_dockers.sh clean"
  echo "  ./manage_dockers.sh rebuild"
}

# --- Fonction pour arrêter et supprimer les conteneurs ---
stop_containers() {
  echo -e "${YELLOW}${ICON_STEP} Arrêt des conteneurs...${RESET}"
  docker stop $BACKEND_NAME 2>/dev/null || true
  docker rm $BACKEND_NAME 2>/dev/null || true
  docker stop $FRONTEND_NAME 2>/dev/null || true
  docker rm $FRONTEND_NAME 2>/dev/null || true
  echo -e "${GREEN}${ICON_OK} Conteneurs arrêtés et supprimés.${RESET}"
}

# --- Fonction pour supprimer les images ---
clean_images() {
  echo -e "${YELLOW}${ICON_STEP} Suppression des anciennes images...${RESET}"
  docker rmi breizh-backend 2>/dev/null || true
  docker rmi breizh-frontend 2>/dev/null || true
  echo -e "${GREEN}${ICON_OK} Images supprimées.${RESET}"
}

# --- Fonction pour reconstruire les dockers ---
rebuild() {
  stop_containers
  clean_images

  echo -e "${BLUE}${ICON_STEP} Construction du backend...${RESET}"
  cd backend
  docker build -t breizh-backend .
  cd ..

  echo -e "${BLUE}${ICON_STEP} Construction du frontend...${RESET}"
  cd frontend
  docker build -t breizh-frontend .
  cd ..

  echo -e "${YELLOW}${ICON_STEP} Lancement des conteneurs...${RESET}"
  docker run -d -p 8000:8000 --name $BACKEND_NAME breizh-backend
  docker run -d -p 4300:80 --name $FRONTEND_NAME breizh-frontend

  echo -e "${GREEN}${ICON_OK} Tout est prêt !${RESET}"
  echo
  echo -e "${BLUE}👉 Backend :${RESET}  http://localhost:8000/docs"
  echo -e "${BLUE}👉 Frontend :${RESET} http://localhost:4300"
}

# --- Choix de l'action ---
ACTION="${1:-help}"

case "$ACTION" in
  stop)
    stop_containers
    ;;
  clean)
    stop_containers
    clean_images
    ;;
  rebuild)
    rebuild
    ;;
  -h|--help|help)
    show_help
    ;;
  *)
    echo -e "${RED}${ICON_ERR} Erreur : commande inconnue '$ACTION'${RESET}"
    echo "Utilisez './manage_dockers.sh -h' pour l'aide."
    exit 1
    ;;
esac
