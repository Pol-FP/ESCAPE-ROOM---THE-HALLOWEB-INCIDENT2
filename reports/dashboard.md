# Matriu de monitoratge — The Halloweb Incident

Escenari didàctic simulat. Aquesta matriu descriu el resultat esperat amb el CSV de v0.2-beta; no és telemetria d’un servidor real. No s’han aplicat regles al tallafoc durant les proves.

## Repartiment de l’auditoria

- Agent 2: prepara la matriu i aporta els resultats de les proves del script.
- Agent 1: revisa les IP, els ports i el resultat esperat respecte del CSV abans d’aprovar la PR.

## Estat de les amenaces

| IP | Amenaça | Nivell | Port infectat | Protocol | Política | Resultat esperat en simulació |
| --- | --- | --- | --- | --- | --- | --- |
| 192.0.2.10 | ghost | alt | 22 | TCP | Crític | Dues regles previstes: INPUT origen/22 i OUTPUT destinació/22 |
| 192.0.2.10 | ghost | alt | 443 | TCP | Crític | Dues regles previstes: INPUT origen/443 i OUTPUT destinació/443 |
| 192.0.2.20 | spectre | alt | 3389 | TCP | Crític | Dues regles previstes: INPUT origen/3389 i OUTPUT destinació/3389 |
| 192.0.2.30 | phantom | baix | 8080 | TCP | No crític | Omesa; cap regla prevista |

Total: quatre parelles IP/port, tres seleccionades, una omesa i sis regles simulades. La selecció depèn del port; el nivell és una metadada.

## Evidències de mitigació

| Element | Evidència | Estat |
| --- | --- | --- |
| Contracte inicial | PR #1 i PR #2; v0.1-alpha sobre 38312dc | Integrat |
| Mostra contaminada simulada | scripts/nightmare.sh a feature/nightmare-code | Aïllada; fora de main |
| Política de la simulació | .incident/protocol.env a feature/nightmare-code | TCP 22, 443 i 3389; altres ports omesos |
| Actualització coordinada | CSV de l’Agent 1 i script de l’Agent 2 a hotfix/protocol-update; PR #4 | Revisada i integrada |
| Validació | Set proves unittest i comprovació de sintaxi Bash | Superades abans de la PR #4 |
| Fita 2 | v0.2-beta sobre 7c94db3; Issue #3 tancada | Completada |
| Resolució de col·lisions | b8dd407 conserva les dues bitàcoles en un commit amb dos pares | Registrada |
| Fita final | Consolidació de bitàcoles, revisions finals i v1.0-gold | Pendent en crear aquest informe |

## Reproducció de l’auditoria

Des de l’arrel del repositori, amb Bash i Python 3:

```bash
bash scripts/exorcism.sh data/ghost_hosts.csv
python3 -m unittest discover -s tests -v
```

La primera ordre és una simulació per defecte. Les proves cobreixen ports crítics/no crítics, múltiples ports del mateix host, duplicats, IPv6, ports invàlids, IP invàlida, esquema antic, camps incorrectes i límits de ports. L’aplicació real amb --apply no s’ha validat contra un tallafoc real.
