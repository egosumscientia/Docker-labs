#!/bin/bash
kubectl run -i --tty load-generator --image=busybox /bin/sh <<EOF2
while true; do wget -q -O- http://web-service; done
EOF2
