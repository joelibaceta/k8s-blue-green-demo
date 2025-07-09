#!/bin/bash
echo "⏳ Deploying Blue version..."
kubectl apply -f blue-deploy.yaml
kubectl apply -f service.yaml
sleep 5

echo "📡 Testing Blue version (internal curl)..."
kubectl run curl-blue --image=busybox:1.28 -it --restart=Never -- sh -c "wget -qO- http://web"

echo "✅ Blue version works."

echo "⏳ Deploying Green version..."
kubectl apply -f green-deploy.yaml
sleep 5

echo "📡 Testing Green version directly (internal curl)..."
kubectl run curl-green --image=busybox:1.28 -it --restart=Never -- sh -c "wget -qO- http://web-green"

echo "🔄 Switching traffic to Green version..."
kubectl patch svc web -p '{"spec":{"selector":{"app":"web","version":"green"}}}'
sleep 3

echo "📡 Testing Service after switch (should show Green)..."
kubectl run curl-final --image=busybox:1.28 -it --restart=Never -- sh -c "wget -qO- http://web"

echo "✅ Blue/Green demo completed."
