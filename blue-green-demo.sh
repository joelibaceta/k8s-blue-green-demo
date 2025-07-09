#!/bin/bash

# Colores
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin color

echo -e "${BLUE}⏳ Paso 1: Desplegando la versión BLUE...${NC}"
kubectl apply -f blue-deploy.yaml
kubectl apply -f service.yaml
sleep 2

echo -e "${YELLOW}📡 Estado de los pods (Blue)...${NC}"
kubectl get pods -o wide
sleep 3

echo -e "${YELLOW}🔗 Endpoints del servicio web (apunta a Blue)...${NC}"
kubectl get endpoints web
sleep 3

echo -e "${GREEN}✅ Versión BLUE desplegada.${NC}"
sleep 2

echo -e "${BLUE}⏳ Paso 2: Desplegando la versión GREEN...${NC}"
kubectl apply -f green-deploy.yaml
sleep 2

echo -e "${YELLOW}📡 Estado de los pods (Green)...${NC}"
kubectl get pods -o wide
sleep 3

echo -e "${YELLOW}🔗 Endpoints del servicio web-green (Green)...${NC}"
kubectl get endpoints web-green
sleep 3

echo -e "${GREEN}✅ Versión GREEN desplegada.${NC}"
sleep 2

echo -e "${BLUE}🔄 Paso 3: Cambiando el tráfico de BLUE → GREEN...${NC}"
kubectl patch svc web -p '{"spec":{"selector":{"app":"web","version":"green"}}}'
sleep 2

echo -e "${YELLOW}📡 Endpoints del servicio web después del cambio (apunta a Green)...${NC}"
kubectl get endpoints web
sleep 3

echo -e "${GREEN}🎉 ¡Demo Blue/Green completada!${NC}"
sleep 2

echo -e "${YELLOW}🌐 Probando el servicio desde dentro del cluster:${NC}"
kubectl run curl-test --image=busybox:1.28 -it --restart=Never -- sh -c "wget -qO- http://web"

echo -e "${GREEN}✅ ¡Tráfico ahora servido por la versión GREEN!${NC}"
