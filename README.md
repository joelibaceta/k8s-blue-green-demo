# 🚀 Blue/Green Deployment Demo en Kubernetes (Playground Edition)

Esta demo muestra:  
✅ Cómo Kubernetes mantiene el *estado deseado* recreando pods eliminados.  
✅ Cómo realizar un despliegue **Blue/Green** para cambiar versiones sin downtime.  
✅ Cómo observar el proceso en tiempo real desde un único terminal.  

⚠️ **Nota importante**: Este playground es un entorno sandbox temporal.  
No uses credenciales personales ni datos sensibles. Todo se borra al cerrar la sesión.

---

## 📦 Contenido

- `blue-deploy.yaml` → Deployment y ConfigMap de la versión **Blue**.  
- `green-deploy.yaml` → Deployment y ConfigMap de la versión **Green**.  
- `service.yaml` → Service que redirige el tráfico a **Blue** (luego se cambia a **Green**).  
- `demo.sh` → Script interactivo que guía la demo paso a paso.

---

## ⚙️ Pre-setup en el Playground

El playground no viene con un cluster listo, así que debes inicializarlo:  

1. **Inicializa el cluster maestro:**  
```bash
kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr=10.5.0.0/16
```

2. **Configura kubectl para usar el cluster:**
(Si sudo no está disponible, usa como root)
```bash
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
```
3. **Aplica la red de pods (Kube-router):**
```bash
kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml
```
✅ Espera unos segundos hasta que todos los pods estén en estado Running: `kubectl get pods -A`
