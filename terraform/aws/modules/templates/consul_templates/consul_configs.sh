
echo "==> Create Proxy defaults so that all services use gateway"
sudo tee /mnt/consul/proxy-defaults.json > /dev/null <<EOF
{
    "Kind": "proxy-defaults",
    "Name": "global",
"MeshGateway" : {
  "mode" : "local"
}
}
EOF


echo "==> Create Service defaults to make MongoDB use a gateway"
sudo tee /mnt/consul/mongodb.hcl > /dev/null <<EOF
Kind = "service-defaults"
Name = "mongodb"
Protocol = "http"
MeshGateway = {
  mode = "local"
}
EOF

echo "==> Create a Service Router to route Mongodb from DC2 to DC1"
sudo tee /mnt/consul/mongodb-resolver.hcl > /dev/null <<EOF
kind = "service-resolver"
name = "mongodb"
redirect {
service    = "mongodb"
  datacenter = "dc1-eu-west-2"
}
EOF

echo "==> Create a script to apply Consul reloadble configuration"
sudo tee /mnt/consul/consul_config_scrips.sh > /dev/null <<EOF
consul config write proxy-defaults.json
consul config write mongodb.hcl
consul config write mongodb-resolver.hcl
EOF

echo "==> Makethe  Consul reloadble configuration executable"
sudo chmod +x /mnt/consul/consul_config_scrips.sh

echo "==> Create a script to create run Consul Connect Envoy Gateways"
sudo tee /mnt/consul/run_gateway.sh > /dev/null <<EOF
consul connect envoy  -mesh-gateway -register  -service "gateway" -address "$(private_ip):8700" -wan-address "$(public_ip):8700" -admin-bind "127.0.0.1:19007"
EOF

echo "==> Make the Consul Connect Envoy Gateways executable"
sudo chmod +x /mnt/consul/run_gateway.sh


