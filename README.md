# ESCAPE-ROOM---THE-HALLOWEB-INCIDENT2
Testing with chatgpt as Agent2

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

## Fase 2 — Preparació de l’escenari simulat (Agent 2)

- A petició de l’Agent 1, l’Agent 2 ha preparat artificialment `feature/nightmare-code` i la Issue #3. No són aportacions del professor.
- La branca de laboratori parteix del `main` de la fase 1 (`38312dc`). Conté una mostra inerta i pistes del canvi de protocol; no s’ha integrat a `main`.
- La política de ports TCP crítics 22, 443 i 3389 és una decisió explícita d’aquesta simulació, ja que l’enunciat no els concreta.
- Es reserva `hotfix/protocol-update`, que es crearà des de `main`, per coordinar el canvi de CSV de l’Agent 1 i el canvi de script de l’Agent 2. Encara no s’ha implementat el hotfix.
- Topologia: branca contaminada separada per a investigació; hotfix compartit per mantenir junts els canvis dependents; integració a `main` exclusivament amb PR revisada.

### Descoberta al hotfix compartit

- Inspeccionat el commit `013abcf` de l’Agent 1 a `hotfix/protocol-update`: el CSV incorpora `Port_Infectat` amb els ports 22, 443, 3389 i 8080; la mateixa IP apareix amb 22 i 443.
- El parser de la fase 1 només admet tres columnes i rebutja aquest esquema. L’Agent 2 adapta el parser i el filtre en el mateix hotfix abans de demanar la integració.
