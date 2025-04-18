#!/bin/bash
echo "🔥 Eliminando recursos de Kubernetes..."
kubectl delete -f ../kubernetes/hpa.yaml
kubectl delete -f ../kubernetes/service.yaml
kubectl delete -f ../kubernetes/deployment.yaml
echo "🧼 Limpieza completada."
