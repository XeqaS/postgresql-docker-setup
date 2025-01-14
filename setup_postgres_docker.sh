#!/bin/bash
echo "🚀 Automatyczna instalacja Docker i PostgreSQL"

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

# Uruchamianie PostgreSQL w Dockerze
echo "🚢 Uruchamianie PostgreSQL w Dockerze..."
docker-compose down
docker-compose up -d || echo "⚠️ Problem z uruchamianiem Dockera. Upewnij się, że wylogowałeś się i zalogowałeś ponownie."

echo "✅ PostgreSQL gotowy! Użyj pliku .env do konfiguracji danych logowania."
¬