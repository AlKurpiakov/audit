# Audit

Lightweight Linux server monitoring tool written in Bash.

## Features

- Real-time dashboard (TUI)
- CPU / Memory / Disk monitoring
- Port and process inspector
- Alert system with email notifications
- Background agent (systemd)

## Usage
Show all statistic about server behavior
```bash
audit dashboard
```
Show cpu/ram/disk usage
```bash
audit monitor
```
Show information about port usage
```bash
audit ports
```
Show top 10 processes on server ordered by cpu usage
```bash
audit processes
```
Start alert agent
```bash
audit agent
```
---

You may use agent with systemd
```bash
sudo systemctl daemon-reload
sudo systemctl enable audit
sudo systemctl start audit
```
The alert agent will start and send emails about strange behavior on the server.

## Installation

```bash
curl -sSL https://raw.githubusercontent.com/AlKurpiakov/audit/main/install.sh | bash
```
