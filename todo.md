#!/bin/bash

# 1. Sprawdzanie wymaganych narzędzi przed instalacją
check_dependencies() {
  for cmd in curl jq docker docker-compose; do
    if ! command -v $cmd &> /dev/null; then
      echo "❌ $cmd nie jest zainstalowane. Instaluję..."
      sudo apt install -y $cmd
    fi
  done
}

# 2. Lepsza obsługa błędów
trap "echo '⛔ Przerwano skrypt. Czyści środowisko.'; docker-compose down" INT TERM EXIT

# 3. Automatyczna konfiguracja użytkownika po dodaniu do grupy Docker
configure_docker_user() {
  newgrp docker <<EOF
echo "✅ Teraz możesz korzystać z Dockera bez wylogowywania."
EOF
}

# 4. Weryfikacja aktualnej wersji Dockera i Docker Compose
verify_docker_version() {
  REQUIRED_VERSION="20.10.0"
  INSTALLED_VERSION=$(docker --version | awk '{print $3}' | sed 's/,//')
  if [[ "$(printf '%s\n' "$REQUIRED_VERSION" "$INSTALLED_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]]; then
    echo "⚠️ Wersja Dockera ($INSTALLED_VERSION) jest starsza niż wymagana ($REQUIRED_VERSION). Zaktualizuj Dockera."
  fi
}

# 5. Obsługa argumentów
POSTGRES_MAJOR_VERSION="15"
INSTALL_POSTGRES=true

while [[ $# -gt 0 ]]; do
  case $1 in
    --version)
      POSTGRES_MAJOR_VERSION="$2"
      shift
      ;;
    --docker-only)
      INSTALL_POSTGRES=false
      ;;
    --help)
      echo "Użycie: ./script.sh [--version <wersja>] [--docker-only] [--help]"
      exit 0
      ;;
    *)
      echo "Nieznany argument: $1"
      exit 1
      ;;
  esac
  shift
done

# 6. Organizacja zmiennych środowiskowych
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "⚠️ Plik .env nie istnieje. Upewnij się, że został utworzony."
  exit 1
fi

# 7. Opcja czyszczenia środowiska
clean_environment() {
  echo "🧹 Usuwanie kontenerów i wolumenów PostgreSQL..."
  docker-compose down -v
}

# 8. Logowanie do pliku
exec > >(tee -i install.log)
exec 2>&1

# 9. Podnoszenie bezpieczeństwa
TMP_ENV=$(mktemp)
cp .env $TMP_ENV
export $(grep -v '^#' $TMP_ENV | xargs)
chmod 600 .env

# 10. Dodanie pomocy (wyświetlone wcześniej w --help)
if [[ "$1" == "--help" ]]; then
  echo "Użycie: ./script.sh [--version <wersja>] [--docker-only] [--help]"
  exit 0
fi

# Wywołanie funkcji
check_dependencies
verify_docker_version

if $INSTALL_POSTGRES; then
  echo "✅ Instalacja PostgreSQL w wersji $POSTGRES_MAJOR_VERSION..."
  # Tutaj dodaj logikę instalacji PostgreSQL
else
  echo "⚙️ Pominięto instalację PostgreSQL."
fi

echo "✅ Skrypt zakończył działanie pomyślnie."
