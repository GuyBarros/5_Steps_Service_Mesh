
echo "==> Create Proxy defaults so that all services use gateway"
sudo tee /mnt/consul/proxy-defaults.json.bkp > /dev/null <<EOF
{
    "Kind": "proxy-defaults",
    "Name": "global",
"MeshGateway" : {
  "mode" : "local"
}
}
EOF


echo "==> Create Service defaults to make MongoDB use a gateway"
sudo tee /mnt/consul/mongodb.hcl.bkp > /dev/null <<EOF
Kind = "service-defaults"
Name = "mongodb"
Protocol = "http"
MeshGateway = {
  mode = "local"
}
EOF

echo "==> Create a Service Router to route Mongodb from DC2 to DC1"
sudo tee /mnt/consul/mongodb-resolver.hcl.bkp > /dev/null <<EOF
kind = "service-resolver"
name = "mongodb"
redirect {
service    = "mongodb"
  datacenter = "dc1-eu-west-2"
}
EOF

echo "==> Create a script to apply Consul reloadble configuration"
sudo tee /mnt/consul/mongodb-resolver.hcl.bkp > /dev/null <<EOF
consul config write proxy-defaults.json
consul config write mongodb.hcl
consul config write mongodb-resolver.hcl
EOF