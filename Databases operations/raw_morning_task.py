#!/usr/bin/env python3
"""Parallel pre-market morning health checks across trading servers."""

import os
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed


def check_host(host: str, user: str, password: str) -> str:
    cmd = [
        "sshpass", "-p", password,
        "ssh", "-o", "ConnectTimeout=4", "-o", "StrictHostKeyChecking=no",
        f"{user}@{host}",
        "hostname && uptime -p && df -h / | awk 'NR==2 {print "Disk:", $5}'"
    ]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0:
        summary = " | ".join(line.strip() for line in res.stdout.splitlines() if line.strip())
        return f"[OK] {host}: {summary}"
    return f"[FAIL] {host}: {res.stderr.strip() or 'SSH unreachable'}"


def main():
    hosts = os.getenv("MCX_BSE_HOSTS", "10.0.0.1 10.0.0.2").split()
    user = os.getenv("REMOTE_USER", "root")
    password = os.getenv("SSH_PASS_BSE", "")

    with ThreadPoolExecutor(max_workers=min(10, len(hosts))) as pool:
        futures = {pool.submit(check_host, h, user, password): h for h in hosts}
        for fut in as_completed(futures):
            print(fut.result())


if __name__ == "__main__":
    main()
