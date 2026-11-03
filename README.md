# ESCAPE-ROOM---THE-HALLOWEB-INCIDENT2
Testing with chatgpt as Agent2

## Fase 1 — Bitàcola de l'Agent 2

- Agent 1: responsable de `projecte/spectral-data` i `data/ghost_hosts.csv`.
- Agent 2: responsable de `projecte/defense-script` i `scripts/exorcism.sh`.
- Inspecció remota: només s'ha trobat `main`, amb el README inicial. No hi havia altres branques ni issues en el moment de la consulta.
- Contracte de dades proposat per l'Agent 2 i acceptat per l'Agent 1 a la conversa: CSV UTF-8 separat per comes, amb capçalera `IP,Amenaca,Nivell`. Exemple acordat: `192.0.2.10,ghost,alt`.
- L'Agent 1 publicarà el CSV. L'Agent 2 valida les tres columnes, les IP i els camps obligatoris abans de preparar cap bloqueig.
- En aquesta fase es processen tots els hosts del CSV; `Amenaca` i `Nivell` són metadades. No s'ha pactat encara cap filtre per nivell.
- L'script funciona en simulació per defecte i evita duplicar hosts. `--apply` aplica regles INPUT/OUTPUT al tallafoc Linux de la màquina local, amb permisos root; no configura encaminadors ni altres equips.
- Inicialment la integració de GitHub retornava 403. En tornar a provar, s'ha pogut crear `projecte/defense-script` a partir del commit inicial de `main`, `169f3285fad6eacf50b7686c1707bfc52e34b6b9`.
- En aquesta segona inspecció encara no apareixia la branca de l'Agent 1 al remot. El contracte s'ha acordat a la conversa; falta validar-lo amb el CSV publicat per l'Agent 1.
- Validació local: sintaxi Bash correcta, simulació INPUT/OUTPUT correcta, eliminació de hosts duplicats i rebuig d'una IP invàlida. No s'han aplicat regles reals.
- Es publiquen els fitxers a la branca de l'Agent 2 per a revisió mitjançant PR; la integració a `main` queda pendent de revisió creuada.

### Execució

Requisits: Bash i Python 3. Per aplicar regles: Linux amb `iptables` i/o `ip6tables`.

Des de l'arrel del projecte:

```bash
bash scripts/exorcism.sh data/ghost_hosts.csv
# Aplicació explícita, en l'entorn de laboratori:
sudo bash scripts/exorcism.sh data/ghost_hosts.csv --apply
```

Cada host es bloqueja com a origen d'entrada i destinació de sortida. Les regles no són persistents entre reinicis. Una fallada durant l'aplicació pot deixar regles anteriors aplicades.

La columna `Port_Infectat` i el filtre de ports s'abordaran a la fase 2, coordinadament amb l'Agent 1.
