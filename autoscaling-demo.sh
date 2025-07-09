#!/bin/bash

# Colores
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

echo -e "${BLUE}⏳ Paso 1: Desplegando la versión inicial...${NC}"
kubectl apply -f blue-deploy.yaml
kubectl apply -f service.yaml
sleep 3

echo -e "${YELLOW}📡 Estado actual de los pods:${NC}"
kubectl get pods -o wide
sleep 3

echo -e "${BLUE}⬆️ Paso 2: Escalando el deployment a 4 réplicas...${NC}"
kubectl scale deployment web-blue --replicas=4
sleep 2

echo -e "${YELLOW}📡 Estado de los pods después de escalar:${NC}"
kubectl get pods -o wide
sleep 4

echo -e "${GREEN}✅ Ahora hay 4 pods ejecutándose.${NC}"
sleep 2

echo -e "${RED}💥 Paso 3: Simulando fallos matando 2 pods manualmente...${NC}"
PODS=$(kubectl get pods -l app=web -o name | head -n2)
for pod in $PODS; do
    echo -e "${RED}⚠️ Eliminando $pod...${NC}"
    kubectl delete $pod
    sleep 1
done

echo -e "${YELLOW}📡 Estado de los pods después de matar algunos:${NC}"
kubectl get pods -o wide
sleep 3

echo -e "${BLUE}⏳ Esperando que Kubernetes recree los pods eliminados...${NC}"
sleep 5

echo -e "${YELLOW}📡 Estado final de los pods (deberían volver a ser 4):${NC}"
kubectl get pods -o wide
sleep 3

echo -e "${GREEN}🎉 ¡Kubernetes ha restaurado automáticamente las réplicas eliminadas!${NC}"
