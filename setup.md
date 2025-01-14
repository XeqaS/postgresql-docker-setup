





Okej, wygląda na to, że poprawiona wersja skryptu powinna być bardziej kompletna, zawierając zarówno instalację i konfigurację Dockera oraz Docker Compose, jak i nowe funkcje związane z walidacją i aktualizacją PostgreSQL. Poniżej pełna, połączona wersja skryptu, zawierająca wszystkie poprzednie funkcjonalności oraz nowe mechanizmy zarządzania wersjami PostgreSQL:

Kompletny skrypt:
bash
Skopiuj kod
#!/bin/bash
echo "🚀 Automatyczna instalacja Docker i PostgreSQL"

# Ustawienia docelowej głównej wersji PostgreSQL
POSTGRES_MAJOR_VERSION="15"
POSTGRES_IMAGE_BASE="postgres"

# Funkcja sprawdzająca najnowszą wersję PostgreSQL w ramach `POSTGRES_MAJOR_VERSION`
get_latest_patch_version() {
  echo "🔍 Sprawdzanie najnowszej dostępnej wersji PostgreSQL z serii ${POSTGRES_MAJOR_VERSION}.x..."
  LATEST_PATCH=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/${POSTGRES_IMAGE_BASE}/tags" | \
    jq -r '.results[].name' | \
    grep "^${POSTGRES_MAJOR_VERSION}\.[0-9]\+$" | \
    sort -V | \
    tail -n1)

  if [ -z "$LATEST_PATCH" ]; then
    echo "❌ Nie udało się znaleźć najnowszej wersji PostgreSQL dla serii ${POSTGRES_MAJOR_VERSION}.x"
    exit 1
  fi

  echo "✅ Najnowsza wersja PostgreSQL dla serii ${POSTGRES_MAJOR_VERSION}.x to: $LATEST_PATCH"
  echo "$LATEST_PATCH"
}

# Funkcja aktualizująca obraz PostgreSQL
update_postgres_image() {
  LATEST_PATCH=$(get_latest_patch_version)

  echo "🔄 Aktualizacja obrazu PostgreSQL do wersji $LATEST_PATCH..."
  docker-compose down
  docker-compose pull postgres
  docker-compose up -d
  echo "✅ Obraz PostgreSQL zaktualizowany do wersji $LATEST_PATCH."
}

# Funkcja sprawdzająca obecną wersję PostgreSQL
check_current_postgres_version() {
  CURRENT_VERSION=$(docker exec postgres_db postgres --version 2>/dev/null | awk '{print $3}')
  echo "🔍 Obecna wersja PostgreSQL w kontenerze to: $CURRENT_VERSION"
  echo "$CURRENT_VERSION"
}

# Aktualizacja systemu
echo "🔄 Aktualizacja systemu..."
sudo apt update && sudo apt upgrade -y

# Instalacja Dockera
echo "🐳 Instalowanie Dockera..."
sudo apt install -y docker.io

# Włączanie Dockera przy starcie systemu
echo "🛠️ Konfiguracja Dockera..."
sudo systemctl enable docker
sudo systemctl start docker

# Dodanie użytkownika do grupy docker
echo "👤 Dodawanie użytkownika do grupy Docker..."
sudo usermod -aG docker $USER
echo "ℹ️ Użytkownik dodany do grupy 'docker'. Wyloguj się i zaloguj ponownie, aby zmiany zadziałały."

# Instalacja Docker Compose
echo "📦 Instalowanie Docker Compose..."
sudo apt install -y curl
sudo curl -L "https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Tworzenie katalogu na plik docker-compose.yml
echo "📂 Tworzenie katalogu dla PostgreSQL..."
mkdir -p ~/postgresql-docker && cd ~/postgresql-docker

# Tworzenie pliku docker-compose.yml
echo "✍️ Tworzenie pliku docker-compose.yml..."
cat <<EOF > docker-compose.yml
services:
  postgres:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_USER: \${POSTGRES_USER}
      POSTGRES_PASSWORD: \${POSTGRES_PASSWORD}
      POSTGRES_DB: \${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
EOF

# Tworzenie pliku .env z przykładowymi danymi
echo "📄 Tworzenie pliku .env z przykładowymi danymi..."
if [ ! -f .env ]; then
  cat <<EOF > .env
POSTGRES_USER=default_user
POSTGRES_PASSWORD=default_password
POSTGRES_DB=default_db
EOF
  echo "✅ Plik .env utworzony."
else
  echo "⚠️ Plik .env już istnieje. Pomijam tworzenie."
fi

# Sprawdzanie aktualnej wersji PostgreSQL
CURRENT_VERSION=$(check_current_postgres_version || echo "brak")
LATEST_PATCH=$(get_latest_patch_version)

# Walidacja większej zmiany (np. z 15.x na 16.x)
if [[ "$CURRENT_VERSION" != "" && "$CURRENT_VERSION" != $POSTGRES_MAJOR_VERSION* ]]; then
  echo "⚠️ Wykryto dużą aktualizację wersji PostgreSQL (${CURRENT_VERSION} → ${LATEST_PATCH})."
  echo "🔒 Automatyczna aktualizacja została zablokowana, aby uniknąć potencjalnych problemów z kompatybilnością."
  echo "📝 Instrukcja ręcznej aktualizacji:"
  echo "1. Zmień główną wersję PostgreSQL w skrypcie:"
  echo "   - Otwórz plik setup_postgres_docker.sh."
  echo "   - Znajdź linię: POSTGRES_MAJOR_VERSION=\"$POSTGRES_MAJOR_VERSION\""
  echo "   - Zmień wartość na nową wersję, np.: POSTGRES_MAJOR_VERSION=\"16\""
  echo "2. Uruchom ponownie skrypt, aby pobrać nowy obraz PostgreSQL."
  echo "3. Upewnij się, że aplikacje korzystające z bazy danych są zgodne z nową wersją."
  exit 1
fi

# Porównanie wersji i aktualizacja, jeśli wymagana
if [ "$CURRENT_VERSION" != "$LATEST_PATCH" ]; then
  echo "⚠️ Wersja PostgreSQL w kontenerze ($CURRENT_VERSION) jest starsza od najnowszej ($LATEST_PATCH)."
  update_postgres_image
else
  echo "✅ PostgreSQL jest aktualny ($CURRENT_VERSION)."
fi

echo "🎉 Skrypt zakończony!"
Co zawiera skrypt:
Instalacja Dockera i Docker Compose – pełna konfiguracja systemu.
Tworzenie plików Docker Compose i .env – łatwe dostosowanie konfiguracji PostgreSQL.
Automatyczna aktualizacja PostgreSQL w ramach serii (15.x) – z walidacją i zabezpieczeniami.
Instrukcja ręcznej aktualizacji do nowej serii (16.x) – dla dużych zmian.
