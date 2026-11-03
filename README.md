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
- La creació i publicació del CSV de l’Agent 1 està pendent.
- La integració a `main` es farà mitjançant Pull Requests amb revisió del company.
