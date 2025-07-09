#!/bin/bash

# Colores
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

# Función para mostrar los pods en un mini-dashboard
show_pods() {
    clear
    echo -e "${YELLOW}📊 Estado actual de los pods:${NC}"
    kubectl get pods -o wide
}

echo -e "${BLUE}⏳ Paso 1: Desplegando la versión inicial...${NC}"
kubectl apply -f blue-deploy.yaml
kubectl apply -f service.yaml
sleep 5
show_pods
read -p "➡️ Pulsa Enter para continuar..."

echo -e "${BLUE}⬆️ Paso 2: Escalando el deployment a 4 réplicas...${NC}"
kubectl scale deployment web-blue --replicas=4
sleep 5
show_pods
read -p "➡️ Pulsa Enter para continuar..."

echo -e "${RED}💥 Paso 3: Simulando fallos eliminando 2 pods manualmente...${NC}"
PODS=$(kubectl get pods -l app=web -o name | head -n2)
for pod in $PODS; do
    echo -e "${RED}⚠️ Eliminando $pod...${NC}"
    kubectl delete $pod
    sleep 2
    show_pods
done

echo -e "${BLUE}⏳ Esperando que Kubernetes recree los pods eliminados...${NC}"
for i in {1..5}; do
    show_pods
    sleep 2
done

echo -e "${GREEN}🎉 ¡Kubernetes ha restaurado automáticamente las réplicas eliminadas!${NC}"
show_pods
