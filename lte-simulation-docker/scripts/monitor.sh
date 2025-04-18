#!/bin/bash
echo "Contenedores LTE:"
docker ps -a --filter "name=hss\|name=mme\|name=pgw" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
