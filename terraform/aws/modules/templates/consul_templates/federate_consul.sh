
echo "==> Create script to federate consul"
sudo tee /mnt/consul/federate_consul.sh > /dev/null <<EOF
consul join -wan <SECONDARY_SERVER>
EOF

echo "==> +x to script to start envoy proxy"
sudo chmod +x /mnt/consul/federate_consul.sh
