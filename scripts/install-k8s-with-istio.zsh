#!/bin/zsh
# deploy k3d cluster with extra memory (8G) for Istio install
k3d cluster create local-cluster --servers 1 --agents 1 --api-port 6443 --k3s-arg "--disable=traefik@server:0" --port 80:80@loadbalancer --port 8081:443@loadbalancer --agents-memory=8G --registry-create local-registry
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
cd "$PWD/istio-$ISTIO_VERSION/"
export PATH=$PWD/bin:$PATH

#https://istio.io/latest/docs/setup/install/operator/
#install istio operator:
#    NOTE: above command runs the operator by creating the following resources in the istio-operator namespace:
#    - The operator custom resource definition
#    - The operator controller deployment
#    - A service to access operator metrics
#    - Necessary Istio operator RBAC rules
istioctl operator init

#https://istio.io/latest/docs/setup/install/operator/
# deploy Istio default configuration profile using the operator, run the following command:
#     the default profile…
#     Ingress Gateway is enabled
#     Istiod is enabled
kubectl apply -f - <<EOF
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: default-istiocontrolplane
spec:
  profile: default
EOF
echo "Waiting for Istio to be ready..."
sleep 15

# https://istio.io/latest/docs/setup/getting-started/ 
kubectl label namespace default istio-injection=enabled

# certificate creaton for SSL/TLS termination
echo "Setting up local TLS"
kubectl -n istio-system create secret tls auth-frontend-deployment-tls --key=key.pem --cert=cert.pem

echo "Application via Istio Ingress (https): https://fe.sso.kidsloop.live:8443"
echo "Application via Istio Ingress (http):  http://fe.sso.kidsloop.live:8080"
#launch/verify application via Istio
echo "Cluster ready"
