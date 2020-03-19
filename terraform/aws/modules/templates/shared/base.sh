#!/usr/bin/env bash
echo "==> Common Deployment Options Start"

echo "==> libc6 issue workaround"
echo 'libc6 libraries/restart-without-asking boolean true' | sudo debconf-set-selections

function install_from_url {
  cd /tmp && {
    curl -sfLo "$${1}.zip" "$${2}"
    unzip -qq "$${1}.zip"
    sudo mv "$${1}" "/usr/local/bin/$${1}"
    sudo chmod +x "/usr/local/bin/$${1}"
    rm -rf "$${1}.zip"
  }
}

function ssh-apt {
  sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq \
    --allow-downgrades \
    --allow-remove-essential \
    --allow-change-held-packages \
    -o Dpkg::Use-Pty=0 \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    "$@"
}

echo "--> Adding helper for IP retrieval"
sudo tee /etc/profile.d/ips.sh > /dev/null <<EOF
function private_ip {
  curl -s http://169.254.169.254/latest/meta-data/local-ipv4
}

function public_ip {
  curl -s http://169.254.169.254/latest/meta-data/public-ipv4
}
EOF
source /etc/profile.d/ips.sh

echo "--> Updating apt-cache"
ssh-apt update

echo "--> Updating apt to get the latest version of NodeJS and NPM"
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -


echo "--> Installing common dependencies"
ssh-apt install \
  ansible \
  mongodb-server \
  nodejs \
  unzip

echo "--> creating mongodb data dir"
mkdir -p /data/db/

echo "--> Setting hostname..."
echo "${node_name}" | sudo tee /etc/hostname
sudo hostname -F /etc/hostname

echo "--> Adding hostname to /etc/hosts"
sudo tee -a /etc/hosts > /dev/null <<EOF

# For local resolution
$(private_ip)  ${node_name} ${node_name}.node.consul
EOF


echo "--> Install Envoy"
curl -sL 'https://getenvoy.io/gpg' | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb \
$(lsb_release -cs) \
stable"
sudo apt-get update && sudo apt-get install -y getenvoy-envoy
envoy --version

echo "==> Common Deployment Options Completed!"
