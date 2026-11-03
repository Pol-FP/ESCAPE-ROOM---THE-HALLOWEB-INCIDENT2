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

## Fase 2 — Implementació del hotfix compartit

- Escenari artificial preparat a petició de l’Agent 1: branca `feature/nightmare-code` i Issue #3; no és una aportació del professor.
- Agent 1: commit `013abcf`, CSV amb capçalera `IP,Amenaca,Nivell,Port_Infectat`, ports crítics 22/443/3389 i cas no crític 8080. La IP 192.0.2.10 té dos ports diferents.
- Agent 2: adaptació del parser i de les regles a parelles IP/port. Es valida tot el CSV abans de produir ordres o modificar el tallafoc. Ports vàlids: enters entre 1 i 65535; la política del laboratori selecciona només TCP 22, 443 i 3389.
- Es dedupliquen parelles IP/port sense perdre ports diferents del mateix host. IPv4 i IPv6 utilitzen iptables i ip6tables, respectivament.
- El servei infectat correspon al host remot: INPUT filtra la IP i el port d’origen; OUTPUT filtra la IP i el port de destinació. Les regles noves s’insereixen al principi de la cadena.
- Simulació per defecte; l’aplicació real continua requerint `--apply`, permisos root i el tallafoc corresponent. No s’han aplicat bloquejos reals en les proves.
- Proves: `bash -n scripts/exorcism.sh` i `python3 -m unittest discover -s tests -v`; set proves superades (ports crítics/no crítics, duplicats, IPv6, ports invàlids, IP invàlida, esquema antic, camps incorrectes i límits de ports).
- Amb el CSV de l’Agent 1: tres parelles crítiques, sis regles simulades i una parella omesa (TCP/8080).
- Aïllament: la mostra inerta `scripts/nightmare.sh` és a `feature/nightmare-code`; no s’ha incorporat al hotfix ni a `main`. No correspon fer revert d’un codi que no s’ha integrat.
- Topologia: el hotfix parteix de `main` després de v0.1-alpha i reuneix commits diferenciats dels dos agents per coordinar canvis dependents. La integració es farà per PR revisada.
- Revisió i merge del hotfix completats a la PR #4; v0.2-beta publicada sobre `7c94db3` i Issue #3 tancada. Les bitàcoles individuals es consoliden a la fase 3.

## Fase 2 — Preparació de l’escenari simulat (Agent 2)

- A petició de l’Agent 1, l’Agent 2 ha preparat artificialment `feature/nightmare-code` i la Issue #3. No són aportacions del professor.
- La branca de laboratori parteix del `main` de la fase 1 (`38312dc`). Conté una mostra inerta i pistes del canvi de protocol; no s’ha integrat a `main`.
- La política de ports TCP crítics 22, 443 i 3389 és una decisió explícita d’aquesta simulació, ja que l’enunciat no els concreta.
- Es reserva `hotfix/protocol-update`, que es crearà des de `main`, per coordinar el canvi de CSV de l’Agent 1 i el canvi de script de l’Agent 2. Encara no s’ha implementat el hotfix.
- Topologia: branca contaminada separada per a investigació; hotfix compartit per mantenir junts els canvis dependents; integració a `main` exclusivament amb PR revisada.

### Descoberta al hotfix compartit

- Inspeccionat el commit `013abcf` de l’Agent 1 a `hotfix/protocol-update`: el CSV incorpora `Port_Infectat` amb els ports 22, 443, 3389 i 8080; la mateixa IP apareix amb 22 i 443.
- El parser de la fase 1 només admet tres columnes i rebutja aquest esquema. L’Agent 2 adapta el parser i el filtre en el mateix hotfix abans de demanar la integració.

## Fase 3 — Bitàcola de l’Agent 2

- Preparat `reports/dashboard.md` a `feature/status-dashboard`: l’Agent 2 ha creat la matriu i l’Agent 1 l’ha revisada i aprovada a la PR #5. Dashboard integrat a `main` mitjançant commit de merge.
- Incorporat el contingut actual de `main` a `projecte/defense-script` i consolidada manualment la documentació de l’Agent 2. S’han conservat les bitàcoles de la fase 1, el registre del hotfix i tots els fitxers de codi, dades, proves i informe del main actualitzat.
- Aquesta consolidació s’ha fet amb l’API Git de GitHub, amb un commit de dos pares; no s’ha executat un merge local des del terminal de l’Agent 2. La resolució local de conflictes de l’Agent 1 està registrada al commit `b8dd407`.
- Topologia final: branques individuals per a les bitàcoles, branca compartida per als canvis dependents del protocol i branca d’auditoria per a la matriu. Cap d’aquestes aportacions s’integra a main sense PR revisada.
- Pendent: integrar la bitàcola final de l’Agent 1, revisar les PR finals i publicar v1.0-gold després de l’auditoria final.
