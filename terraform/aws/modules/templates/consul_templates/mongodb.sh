echo "==> Create Mongodb no connect service definition"
sudo tee /mnt/consul/mongodb_noconnect.json.bkp > /dev/null <<EOF
{
    "service": {
      "name": "mongodb",
      "port": 27017,
       "tags" : ["mongodb_no_connect"],
       "check": {
            "id": "mongodb_port",
            "name": "mongodb port listening",
            "tcp": "localhost:27017",
            "interval": "10s",
            "timeout": "1s"
        }
    }
  }

EOF

echo "==> Create Mongodb connect service definition"
sudo tee /mnt/consul/mongodb_connect.json.bkp > /dev/null <<EOF
{
    "service": {
      "name": "mongodb",
      "port": 27017,
      "tags" : ["mongodb_connect"],
       "check": {
            "id": "mongodb_port",
            "name": "mongodb port listening",
            "tcp": "localhost:27017",
            "interval": "10s",
            "timeout": "1s"
  },
      "connect": {
        "sidecar_service": { }
      }
    }
  }

EOF

echo "==> Script to Create or Update the Mongodb service definition"
sudo tee /mnt/consul/update_mongo_definition.sh > /dev/null <<EOF
consul services register /mnt/consul/mongodb.json
EOF

echo "==> +x to the Create or Update script"
sudo chmod +x /mnt/consul/update_mongo_definition.sh

echo "==> Create script to start envoy proxy"
sudo tee /mnt/consul/run_mongodb_proxy.sh > /dev/null <<EOF
consul connect envoy -admin-bind localhost:9005 -sidecar-for mongodb
EOF

echo "==> +x to script to start envoy proxy"
sudo chmod +x /mnt/consul/run_mongodb_proxy.sh