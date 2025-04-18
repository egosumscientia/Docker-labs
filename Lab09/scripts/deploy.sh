#!/bin/bash
echo "⛵ Desplegando recursos en Kubernetes..."
kubectl apply -f ../kubernetes/deployment.yaml
kubectl apply -f ../kubernetes/service.yaml
kubectl apply -f ../kubernetes/hpa.yaml
echo "✅ Despliegue completo."
