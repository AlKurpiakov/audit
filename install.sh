#!/usr/bin/env bash

set -e

REPO="https://github.com/AlKurpiakov/audit"
INSTALL_DIR="$HOME/.audit"
BIN_DIR="/usr/local/bin"
TMP_DIR="/tmp/audite_install"

check_dependency(){
	if ! command -v $1 >/dev/null 2>&1; then
		echo "Installing dependency: $1"
		if command -v apt >/dev/null 2>&1; then
			sudo apt update
			sudo apt install -y $1
		elif command -v yum >/dev/null 2>&1; then
                	sudo yum install -y $1
		elif command -v pacman >/dev/null 2>&1; then
                	sudo pacman install -y $1
		else
			echo "Install $1 manualy"
			exit 1
		fi
	fi
}

echo "Audite installation:"
echo

echo "Checking dependencies..."
echo

check_dependency(git)
check_dependency(aws)
check_dependency(ps)
check_dependency(ss)
check_dependency(mail)

echo "Dependencies OK"
echo 

read -p "Enter your e-mail for alerts: " EMAIL
echo

echo "Cloning repository..."
echo 

rm -rf $TMP_DIR
git clone $REPO $TMP_DIR

echo "Installing files"
echo

rm -rf $INSTALL_DIR
mkdir $INSTALL_DIR

cp $TMP_DIR/* $INSTALL_DIR
rm -rf $TMP_DIR

chmode +x $INSTALL_DIR/audit


echo "Creatiing config files"
echo

mkdir $INSTALL_DIR

CFG_FILE="$INSTALL_DIR/config"

cat << EOF > $CFG_FILE
EMAIL=$EMAIL
CPU_ALERT=90
MEM_ALERT=90
DISK_ALERT=90
EOF

echo "Installing audit agent service..."

SERVICE_FILE="/etc/systemd/system/audit.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Audit Agent
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/audit agent
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Installing CLI"
echo

sudo ln -sf $INSTALL_DIR/audit $BIN_DIR/audit

echo "Installation complete"
echo
echo "RUN:"
echo
echo "audit dashboard"
echo



