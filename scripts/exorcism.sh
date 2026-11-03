#!/usr/bin/env bash
# Fase 2: aïlla serveis TCP crítics; simulació per defecte.
set -euo pipefail
python3 - "$@" <<'PY'
import argparse
import csv
import ipaddress
import os
import re
import shlex
import shutil
import subprocess
import sys

parser = argparse.ArgumentParser(description="Aïllament dels hosts del CSV d'amenaces")
parser.add_argument("csv", nargs="?", default="data/ghost_hosts.csv")
parser.add_argument("--apply", action="store_true", help="Aplica les regles al tallafoc Linux")
args = parser.parse_args()

# Política específica de la simulació de la Issue #3.
critical_ports = {22, 443, 3389}
# Valida tot el fitxer abans de mostrar ordres o modificar el tallafoc.
targets = []
seen = set()
try:
    with open(args.csv, encoding="utf-8-sig", newline="") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != ["IP", "Amenaca", "Nivell", "Port_Infectat"]:
            raise ValueError("Capçalera esperada: IP,Amenaca,Nivell,Port_Infectat")
        for line, row in enumerate(reader, 2):
            if None in row or any(not value or not value.strip() for value in row.values()):
                raise ValueError(f"Fila {line}: camps absents, buits o addicionals")
            host = ipaddress.ip_address(row["IP"].strip())
            raw_port = row["Port_Infectat"].strip()
            if not re.fullmatch(r"[0-9]{1,5}", raw_port) or not 1 <= int(raw_port) <= 65535:
                raise ValueError(f"Fila {line}: Port_Infectat ha de ser un enter entre 1 i 65535")
            target = (host, int(raw_port))
            if target not in seen:
                targets.append(target)
                seen.add(target)
except (OSError, UnicodeError, ValueError, csv.Error) as error:
    sys.exit(f"Error: {error}")

selected = [(host, port) for host, port in targets if port in critical_ports]
if args.apply:
    if os.geteuid() != 0:
        sys.exit("Error: --apply requereix permisos de root")
    for binary in {"iptables" if host.version == 4 else "ip6tables" for host, _ in selected}:
        if shutil.which(binary) is None:
            sys.exit(f"Error: no s'ha trobat {binary}")

try:
    for host, port in targets:
        if port not in critical_ports:
            print(f"OMÈS: {host} TCP/{port} (port no crític)")
            continue
        binary = "iptables" if host.version == 4 else "ip6tables"
        # El port infectat correspon al servei del host remot:
        # origen en les respostes d'entrada, destinació en les peticions de sortida.
        for chain, direction, port_direction in [("INPUT", "-s", "--sport"), ("OUTPUT", "-d", "--dport")]:
            rule = [chain, direction, str(host), "-p", "tcp", port_direction, str(port), "-j", "DROP"]
            # Inserció al principi per no quedar darrere d'una regla ACCEPT.
            command = [binary, "-w", "-I", chain, "1", *rule[1:]]
            if args.apply:
                check = subprocess.run([binary, "-w", "-C", *rule], capture_output=True)
                if check.returncode == 1:
                    subprocess.run(command, check=True)
                elif check.returncode != 0:
                    raise subprocess.CalledProcessError(check.returncode, check.args, stderr=check.stderr)
                print(f"PROTEGIT: {chain} {host} TCP/{port}")
            else:
                print(f"SIMULACIÓ: {shlex.join(command)}")
except subprocess.CalledProcessError as error:
    sys.exit(f"Error de tallafoc: {error}. Poden haver-se aplicat regles anteriors.")
print(f"Parelles IP/port processades: {len(selected)}; omeses: {len(targets) - len(selected)}")
PY
