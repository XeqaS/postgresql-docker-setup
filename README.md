# postgresql-docker-setup
Automatyczny docker z postgresql

# Skrypt Automatycznej Instalacji Docker i PostgreSQL

## Opis
Skrypt `setup_postgres_docker.sh` jest narzędziem do automatycznego konfigurowania środowiska PostgreSQL w oparciu o Docker i Docker Compose. Obsługuje instalację Dockera, konfigurację kontenerów PostgreSQL oraz automatyczne zarządzanie wersjami bazy danych, zapewniając wydajność, bezpieczeństwo i wygodę użytkowania.

---

## Funkcje
1. **Automatyczna instalacja:**
   - Docker i Docker Compose są instalowane i konfigurowane na Twoim systemie.
   - Tworzenie wymaganych folderów i plików konfiguracyjnych.

2. **Tworzenie środowiska PostgreSQL:**
   - Generowanie pliku `docker-compose.yml`, który definiuje kontener PostgreSQL.
   - Tworzenie pliku `.env`, zawierającego dane środowiskowe (nazwa użytkownika, hasło, baza danych).

3. **Zarządzanie wersjami PostgreSQL:**
   - Automatyczne sprawdzanie najnowszej dostępnej wersji PostgreSQL w ramach ustalonej serii (np. 15.x).
   - Aktualizacja obrazu PostgreSQL w kontenerze do najnowszej wersji.

4. **Walidacja i ochrona:**
   - Wykrywanie dużych zmian wersji PostgreSQL (np. z 15.x na 16.x) i blokowanie automatycznych aktualizacji w celu uniknięcia problemów z kompatybilnością.
   - Instrukcja ręcznej aktualizacji do nowej serii wersji.

5. **Historia wersji:**
   - Możliwość sprawdzenia obecnie zainstalowanej wersji PostgreSQL.

---

## Jak używać?

### 1. Pobierz skrypt
Skopiuj plik `setup_postgres_docker.sh` do swojego systemu i upewnij się, że ma prawa do uruchamiania:
```bash
chmod +x setup_postgres_docker.sh
