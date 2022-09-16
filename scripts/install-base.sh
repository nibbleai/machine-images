#!/usr/bin/env bash
set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
ENV="$HERE/env.sh"

source $ENV

apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean

install-anaconda() {
  echo "Downloading Anaconda..."
  wget -q https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O /tmp/anaconda.sh
  bash /tmp/anaconda.sh -b -f -p $ANACONDA_DIR
  chmod -R 777 $ANACONDA_DIR
  echo "PATH=\"${ANACONDA_DIR}/bin:$PATH\"" > /etc/environment
  source /etc/environment
  rm /tmp/anaconda.sh
}
install-anaconda

upgrade-pip() {
  echo "Upgrading pip..."
  $ANACONDA_DIR/bin/pip install -U pip
}

install-aws-cli() {
  $ANACONDA_DIR/bin/pip install -U boto3
  $ANACONDA_DIR/bin/pip install awscli
}
install-aws-cli

install-code-server() {
  echo "Downloading code-server..."
  wget -q https://github.com/cdr/code-server/releases/download/v3.4.1/code-server-3.4.1-linux-amd64.tar.gz -O /tmp/code-server.tar.gz
  mkdir /usr/lib/code-server
  tar xzf /tmp/code-server.tar.gz -C /usr/lib/code-server --strip-components 1
  ln -s /usr/lib/code-server/code-server /usr/local/bin/code-server
  rm -rf /tmp/code*
}
install-code-server

install-nginx() {
  echo "Installing Nginx..."
  apt-get install nginx -y
  rm /etc/nginx/sites-enabled/default
  # Generate self-signed SSL certificates. Host is protected by CloudFlare
  mkdir -p $SSL_DIR
  openssl req -x509 -nodes -days 730 -newkey rsa:2048 \
    -keyout $SSL_PRIVATE_KEY -out $SSL_CERT \
    -subj "/C=FR/ST=FR/L=Paris/O=nibble/OU=nibble/CN=nibble.ai"
  # Generate Diffie-Hellman exchange key
  openssl dhparam -out $SSL_DH_PARAM 2048
}
install-nginx

install-supervisor() {
  echo "Installing Supervisor..."
  apt-get install supervisor -y
}
install-supervisor

install-nibble-auth-service() {
  echo "Installing nibble's authentication service..."
  # Required for app.nibble.ai to work properly.
  # https://github.com/nibbleai/auth-service
  $ANACONDA_DIR/bin/pip install https://github.com/nibbleai/auth-service/archive/0.1.zip
}
install-nibble-auth-service
