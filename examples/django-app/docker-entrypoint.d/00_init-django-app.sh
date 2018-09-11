#!/bin/bash
set -e

C_YELLOW='\e[1;33m'
C_RESET='\e[0m'

echo -e "${C_YELLOW}==> Django project check started${C_RESET}"
gosu app python manage.py check
echo -e "${C_YELLOW}==> Django project check completed${C_RESET}"

echo -e "\n${C_YELLOW}==> Django migrations started${C_RESET}"
gosu app python manage.py migrate --no-input
echo -e "${C_YELLOW}==> Django migrations completed${C_RESET}"
