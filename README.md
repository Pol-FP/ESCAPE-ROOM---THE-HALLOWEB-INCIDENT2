# ESCAPE-ROOM---THE-HALLOWEB-INCIDENT2
Testing with chatgpt as Agent2 

## Fase 1 — Bitàcola de l’Agent 1

- **Responsable:** Agent 1 (Admin/Dades).
- **Branca assignada:** `projecte/spectral-data`.
- **Tasca:** preparar el diccionari d’amenaces a `data/ghost_hosts.csv`.

### Contracte de dades

Hem acordat amb l’Agent 2 utilitzar un CSV en UTF-8, separat per comes, amb aquesta estructura:

CSV:
IP,Amenaca,Nivell
192.0.2.10,ghost,alt

- `IP`: adreça IP del host que cal aïllar.
- `Amenaca`: nom o descripció de l’amenaça.
- `Nivell`: nivell de l’amenaça; inicialment utilitzem `alt`.

L’Agent 1 prepara i publica el CSV. L’Agent 2 desenvolupa `scripts/exorcism.sh` d’acord amb aquest contracte. Qualsevol canvi en l’estructura es coordinarà entre tots dos agents.

### Coordinació i estat

- Contracte de dades acceptat pels dos agents.
- L’Agent 2 ha preparat localment el script i ha comprovat la simulació de bloquejos i el rebuig d’IP invàlides.
- L’Agent 1 ha publicat data/ghost_hosts.csv a projecte/spectral-data i ha obert la PR #2.
- L’Agent 2 ha publicat el script i la bitàcola mitjançant la PR #1, ja fusionada a `main`.
- La integració a `main` es farà mitjançant Pull Requests amb revisió del company.

## Fase 1 — Bitàcola de l'Agent 2

- Agent 1: responsable de `projecte/spectral-data` i `data/ghost_hosts.csv`.
- Agent 2: responsable de `projecte/defense-script` i `scripts/exorcism.sh`.
- Inspecció remota: només s'ha trobat `main`, amb el README inicial. No hi havia altres branques ni issues en el moment de la consulta.
- Contracte de dades proposat per l'Agent 2 i acceptat per l'Agent 1 a la conversa: CSV UTF-8 separat per comes, amb capçalera `IP,Amenaca,Nivell`. Exemple acordat: `192.0.2.10,ghost,alt`.
- L'Agent 1 ha publicat el CSV a `projecte/spectral-data`. L'Agent 2 valida les tres columnes, les IP i els camps obligatoris abans de preparar cap bloqueig.
- En aquesta fase es processen tots els hosts del CSV; `Amenaca` i `Nivell` són metadades. No s'ha pactat encara cap filtre per nivell.
- L'script funciona en simulació per defecte i evita duplicar hosts. `--apply` aplica regles INPUT/OUTPUT al tallafoc Linux de la màquina local, amb permisos root; no configura encaminadors ni altres equips.
- La inspecció posterior de `projecte/spectral-data` ha permès validar el CSV publicat per l’Agent 1.
- Validació local: sintaxi Bash correcta, simulació INPUT/OUTPUT correcta, eliminació de hosts duplicats i rebuig d'una IP invàlida. No s'han aplicat regles reals.
- Es publiquen els fitxers a la branca de l'Agent 2 per a revisió mitjançant PR; la integració a `main` queda pendent de revisió creuada.

### Descoberta a la branca de l’Agent 1

- Revisada la PR #2 de `projecte/spectral-data`, commit `5fdaf52e7e2557aeec859376efbbdd205307210b`.
- `data/ghost_hosts.csv` conté la capçalera pactada `IP,Amenaca,Nivell` i el host `192.0.2.10,ghost,alt`.
- Simulació amb aquest contingut: un host processat i dues regles previstes (INPUT i OUTPUT), sense aplicar bloquejos reals.

- Revisió creuada de l’Agent 1 a la PR #1: s’ha simplificat el README retirant les incidències de connexió i l’apartat d’execució.

La columna `Port_Infectat` i el filtre de ports s’abordaran a la fase 2, coordinadament amb l’Agent 1.

## Fase 2 — Bitàcola de l’Agent 1

- **Responsable:** Agent 1 (Admin/Dades).
- **Branca assignada:** `projecte/spectral-data`.
- **Tasca:** investigar la branca `feature/nightmare-code` i identificar les pistes del canvi de protocol.

### Pistes trobades

Al fitxer ocult `.incident/protocol.env` s’han identificat els requisits següents:

- **Contracte de dades:** el CSV ha d’incorporar la columna `Port_Infectat`, amb aquesta capçalera: `IP,Amenaca,Nivell,Port_Infectat`.
- **Ports crítics:** en aquesta simulació, es consideren crítics els ports `22`, `443` i `3389`.
- **Protocol de transport:** `TCP`.
- **Ports no crítics:** l’script els ha d’ometre (`skip`).
- **Mode per defecte:** simulació (`dry-run`), sense aplicar canvis reals al tallafoc.
- **Representació de les dades:** cada fila correspon a una parella IP/port. Una mateixa IP pot aparèixer en diverses files amb ports diferents.

### Coordinació amb l’Agent 2

Abans de modificar el CSV, es coordinarà el nou contracte amb l’Agent 2 a la branca compartida `hotfix/protocol-update`, perquè les dades i l’script siguin compatibles.

## Fase 3 — Bitàcola de l’Agent 1

- **Responsable:** Agent 1 (Admin/Dades).
- **Branca:** `projecte/spectral-data`.

### Revisió i consolidació

- Revisada i aprovada la PR #5, que incorpora la matriu de monitoratge a `reports/dashboard.md`.
- Incorporats els canvis de `main` a la branca individual, conservant les bitàcoles dels dos agents i la documentació del hotfix.
- Preparada la PR final per integrar les troballes de la fase 2 i aquesta bitàcola de la fase 3.

### Estat del projecte

- `v0.1-alpha`: contracte inicial i script d’aïllament.
- `v0.2-beta`: columna `Port_Infectat` i filtratge de ports crítics.
- Issue #3 tancada després d’integrar el hotfix.
- Pendent: revisió i integració de les PR finals, auditoria final i publicació de `v1.0-gold`.
