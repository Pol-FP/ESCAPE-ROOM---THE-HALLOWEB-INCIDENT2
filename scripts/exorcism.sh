#!/usr/bin/env bash
# Fase 1: valida el contracte i prepara l'aïllament; simulació per defecte.
set -euo pipefail
python3 - "$@" <<'PY'
import argparse
import csv
import ipaddress
import os
import shlex
import shutil
import subprocess
import sys

parser = argparse.ArgumentParser(description="Aïllament dels hosts del CSV d'amenaces")
parser.add_argument("csv", nargs="?", default="data/ghost_hosts.csv")
parser.add_argument("--apply", action="store_true", help="Aplica les regles al tallafoc Linux")
args = parser.parse_args()

# Valida tot el fitxer abans de modificar el tallafoc.
hosts = []
try:
    with open(args.csv, encoding="utf-8-sig", newline="") as source:
        reader = csv.DictReader(source)
        if reader.fieldnames != ["IP", "Amenaca", "Nivell"]:
            raise ValueError("Capçalera esperada: IP,Amenaca,Nivell")
        for line, row in enumerate(reader, 2):
            if None in row or any(not value or not value.strip() for value in row.values()):
                raise ValueError(f"Fila {line}: camps absents, buits o addicionals")
            host = ipaddress.ip_address(row["IP"].strip())
            if host not in hosts:
                hosts.append(host)
except (OSError, ValueError, csv.Error) as error:
    sys.exit(f"Error: {error}")

if args.apply:
    if os.geteuid() != 0:
        sys.exit("Error: --apply requereix permisos de root")
    for binary in {"iptables" if host.version == 4 else "ip6tables" for host in hosts}:
        if shutil.which(binary) is None:
            sys.exit(f"Error: no s'ha trobat {binary}")

try:
    for host in hosts:
        binary = "iptables" if host.version == 4 else "ip6tables"
        for chain, direction in [("INPUT", "-s"), ("OUTPUT", "-d")]:
            rule = [chain, direction, str(host), "-j", "DROP"]
            command = [binary, "-w", "-A", *rule]
            if args.apply:
                check = subprocess.run([binary, "-w", "-C", *rule], capture_output=True)
                if check.returncode != 0:
                    subprocess.run(command, check=True)
                print(f"PROTEGIT: {chain} {host}")
            else:
                print(f"SIMULACIÓ: {shlex.join(command)}")
except subprocess.CalledProcessError as error:
    sys.exit(f"Error de tallafoc: {error}. Poden haver-se aplicat regles anteriors.")
print(f"Hosts processats: {len(hosts)}")
PY
