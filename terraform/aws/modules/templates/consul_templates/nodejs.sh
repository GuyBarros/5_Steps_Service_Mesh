echo "==> get the chatapp from Github"
sudo git clone https://github.com/GuyBarros/anonymouse-realtime-chat-app /mnt/consul/chatapp/

echo "==> Create ChatApp no connect service definition"
sudo tee /mnt/consul/chatapp_noconnect.json.bkp > /dev/null <<EOF
{
  "service": {
    "name": "chat",
    "port": 5000,
    "tags": [
      "chat_no_connect"
    ],
    "check": {
      "id": "chat_port",
      "name": "chat port listening",
      "tcp": "localhost:5000",
      "interval": "5s",
      "timeout": "1s"
    }
  }
}
EOF

echo "==> Create ChatApp connect service definition"
sudo tee /mnt/consul/chatapp_connect.json.bkp > /dev/null <<EOF
{
  "service": {
    "name": "chat",
    "port": 5000,
    "connect": {
      "sidecar_service": {
        "tags": [
          "chatapp-proxy"
        ],
        "proxy": {
          "upstreams": [
            {
              "destination_name": "mongodb",
              "local_bind_port": 8888
            }
          ]
        }
      }
    },
    "tags": [ "chat_with_connect"],
    "check": {
      "id": "chat_port",
      "name": "chat port listening",
      "tcp": "localhost:5000",
      "interval": "5s",
      "timeout": "1s"
    }
  }
}
EOF

echo "==> Create Second ChatApp connect service definition"
sudo tee /mnt/consul/second_chatapp_connect.json.bkp > /dev/null <<EOF
{
  
  "service": {
    "name": "chat",
    "port": 5000,
    "connect": {
      "sidecar_service": {
        "tags": [
          "chatapp-proxy"
        ],
        "proxy": {
            "mesh_gateway": {
            "mode" : "local"
        },
          "upstreams": [
            {
              "destination_name": "mongodb",
              "datacenter": "dc1-eu-west-2",
              "local_bind_port": 8888
            }
          ]
        }
      }
    },
    "tags": [ "chat_with_connect"],
    "check": {
      "id": "chat_port",
      "name": "chat port listening",
      "tcp": "localhost:5000",
      "interval": "5s",
      "timeout": "1s"
    }
  }
}
EOF

echo "==> Script to Create or Update the ChatApp service definition"
sudo tee /mnt/consul/update_chatapp_definition.sh > /dev/null <<EOF
consul services register /mnt/consul/chatapp.json
EOF

echo "==> +x to the Create or Update script"
sudo chmod +x /mnt/consul/update_chatapp_definition.sh

echo "==> Create script to start envoy proxy"
sudo tee /mnt/consul/run_chatapp_proxy.sh > /dev/null <<EOF
consul connect envoy -admin-bind localhost:9006 -sidecar-for chat
EOF

echo "==> +x to script to start envoy proxy"
sudo chmod +x /mnt/consul/run_chatapp_proxy.sh