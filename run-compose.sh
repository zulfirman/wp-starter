#!/bin/bash
# ==============================================================
# Docker Compose Environment Runner for WordPress Multi-Env
# Supports: dev | staging | prod
# Actions: up | restart | down
# ==============================================================

# Don’t exit immediately on error
set -u

# ---------- CONFIG ----------
ENV_DIR="./docker/environment"
COMPOSE_PREFIX="docker-compose"
PROJECT_NAME="WordPress Multi-Env"
# ----------------------------

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}=== $PROJECT_NAME ===${NC}\n"

# ---------- ENV SELECTION ----------
while true; do
  echo "Select environment:"
  echo "  1) dev"
  echo "  2) staging"
  echo "  3) prod"
  read -rp "Enter choice [1-3]: " ENV_CHOICE
  case $ENV_CHOICE in
    1) ENV="dev"; break ;;
    2) ENV="staging"; break ;;
    3) ENV="prod"; break ;;
    *) echo -e "${YELLOW}Invalid choice. Please enter 1, 2, or 3.${NC}\n" ;;
  esac
done

COMPOSE_FILE="${COMPOSE_PREFIX}.yml"
ENV_FILE="${ENV_DIR}/.env.${ENV}"

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo -e "${RED}❌ Missing compose file: ${COMPOSE_FILE}${NC}"
  read -rp "Press Enter to close..."
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo -e "${RED}❌ Missing environment file: ${ENV_FILE}${NC}"
  read -rp "Press Enter to close..."
  exit 1
fi

# ---------- ACTION SELECTION ----------
while true; do
  echo ""
  echo "Select action:"
  echo "  1) build & up"
  echo "  2) restart"
  echo "  3) down"
  read -rp "Enter choice [1-3]: " ACTION_CHOICE
  case $ACTION_CHOICE in
    1) ACTION="up"; break ;;
    2) ACTION="restart"; break ;;
    3) ACTION="down"; break ;;
    *) echo -e "${YELLOW}Invalid choice. Please enter 1, 2, or 3.${NC}\n" ;;
  esac
done

# ---------- SUMMARY ----------
echo ""
echo -e "${GREEN}Environment:${NC} ${ENV}"
echo -e "${GREEN}Compose file:${NC} ${COMPOSE_FILE}"
echo -e "${GREEN}Env file:${NC} ${ENV_FILE}"
echo -e "${GREEN}Action:${NC} ${ACTION}"
echo ""

# ---------- ACTIONS ----------
echo -e "${CYAN}Executing Docker Compose...${NC}"
echo ""

# Wrap docker compose in a try-catch–like block
if ! {
  case $ACTION in
    up)
      echo -e "${CYAN}🚀 Building and starting containers...${NC}"
      docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" up -d --build
      ;;
    restart)
      echo -e "${CYAN}🔁 Restarting containers...${NC}"
      docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" restart
      ;;
    down)
      echo -e "${CYAN}🧹 Stopping and removing containers...${NC}"
      docker compose -f "${COMPOSE_FILE}" --env-file "${ENV_FILE}" down -v
      ;;
  esac
}; then
  echo ""
  echo -e "${RED}❌ An error occurred while running Docker Compose.${NC}"
  echo -e "${YELLOW}Please check the message above for details.${NC}"
  read -rp "Press Enter to close..."
  exit 1
fi

echo ""
echo -e "${GREEN}✅ Done.${NC}"
read -rp "Press Enter to close..."
