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
```
2. Uruchom skrypt  
W terminalu uruchom skrypt:

```bash
./setup_postgres_docker.sh
```

3. Wyloguj się i zaloguj ponownie  
Jeśli jest to pierwsza instalacja Dockera, konieczne będzie wylogowanie się i zalogowanie ponownie, aby użytkownik został poprawnie dodany do grupy `docker`.

4. Obsługa plików  
Po uruchomieniu skryptu:

- Plik `docker-compose.yml` znajdziesz w folderze `~/postgresql-docker`.
- Plik `.env` zawiera dane użytkownika, hasło oraz nazwę bazy danych, które możesz edytować według potrzeb.

### Struktura projektu

- `docker-compose.yml` – konfiguracja Docker Compose dla PostgreSQL.
- `.env` – dane środowiskowe (nazwa użytkownika, hasło, baza danych).
- `setup_postgres_docker.sh` – główny skrypt instalacyjny.

### Wymagania systemowe

- **System operacyjny**: Ubuntu/Debian lub inny system zgodny z `apt`.
- **Uprawnienia administratora**: Wymagane do instalacji Dockera i konfiguracji systemu.
- **Narzędzia**:
  - `curl`
  - `jq` (do przetwarzania JSON).

---

### Automatyczna aktualizacja PostgreSQL

- Skrypt sprawdza dostępność nowszych wersji PostgreSQL w ramach ustalonej serii (np. 15.x).  
- Jeśli nowsza wersja jest dostępna, kontener zostaje automatycznie zaktualizowany.  
- W przypadku dużych zmian (np. z 15.x na 16.x), użytkownik otrzymuje instrukcję przeprowadzenia aktualizacji ręcznej.

---

### Uwagi dotyczące bezpieczeństwa

- Upewnij się, że plik `.env` zawierający dane środowiskowe jest chroniony przed nieautoryzowanym dostępem.  
- Regularnie aktualizuj obrazy Dockera, aby korzystać z najnowszych poprawek bezpieczeństwa.

---

### Przykładowy plik `.env`

```plaintext
POSTGRES_USER=default_user
POSTGRES_PASSWORD=default_password
POSTGRES_DB=default_db
```

---

### Dodatkowe informacje

- Aby dowiedzieć się więcej o Dockerze: [Docker Docs](https://docs.docker.com)  
- Aby dowiedzieć się więcej o PostgreSQL: [PostgreSQL Docs](https://www.postgresql.org/docs/)  
- Problemy z konfiguracją? Skontaktuj się z administratorem systemu lub otwórz zgłoszenie w repozytorium projektu.

---

🎉 **Skrypt gotowy do użytku!** Ciesz się automatycznym zarządzaniem PostgreSQL w Dockerze!
