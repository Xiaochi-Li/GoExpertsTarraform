[
  {
    "name": "test",
    "image": "${image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "memoryReservation": ${memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${container_port}
        "protocol": "tcp"
      }
    ]
  }
]
