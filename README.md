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
