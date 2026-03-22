#!/usr/bin/env bash

set -e

REPO="https://github.com/AlKurpiakov/audit"
INSTALL_DIR="$HOME/.audit"
BIN_DIR="/usr/local/bin"
TMP_DIR="/tmp/audite_install"

check_dependency(){
	if ! command -v $1 >/dev/null 2>&1; then

		echo "Installing dependency: $1"

        if [ "$1" == "mailutils" ] && command -v apt >/dev/null 2>&1; then
            echo "Configuring postfix for automatic install..."

            echo "postfix postfix/main_mailer_type select Internet Site" | sudo debconf-set-selections

            echo "postfix postfix/mailname string $(hostname -f)" | sudo debconf-set-selections
            
            export DEBIAN_FRONTEND=noninteractive
        fi


		if command -v apt >/dev/null 2>&1; then
			sudo apt update
			sudo DEBIAN_FRONTEND=noninteractive apt install -y $1
		elif command -v yum >/dev/null 2>&1; then
                	sudo yum install -y $1
		elif command -v pacman >/dev/null 2>&1; then
                	sudo pacman install -y $1
		else
			echo "Install $1 manually"
			exit 1
		fi
	fi
}

echo "Audit installation:"
echo

echo "Checking dependencies..."
echo

check_dependency git
check_dependency awk
check_dependency ps
check_dependency ss
check_dependency mailutils

echo "Dependencies OK"
echo 

echo "Cloning repository..."
echo 

rm -rf "$TMP_DIR"
git clone $REPO $TMP_DIR

echo "Installing files"
echo

rm -rf $INSTALL_DIR
mkdir -p $INSTALL_DIR

cp -r "$TMP_DIR/." "$INSTALL_DIR/"
rm -rf $TMP_DIR

chmod +x $INSTALL_DIR/audit



echo "Creating config files"
echo

read -p "Enter your e-mail for alerts: " ALERT_EMAIL </dev/tty

CFG_FILE="$INSTALL_DIR/config"

cat << EOF > "$CFG_FILE"
EMAIL=$ALERT_EMAIL
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



