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
- Pendent: revisió creuada, merge, comprovació del resultat a main i publicació de v0.2-beta. Les bitàcoles individuals es consolidaran a la fase 3.
