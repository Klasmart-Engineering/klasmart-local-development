kubectl create namespace istio-system --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace istio-ingress --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace istio-operator --dry-run=client -o yaml | kubectl apply -f -
kubectl label namespace default istio-injection=enabled || true
kubectl label namespace istio-ingress istio-injection=enabled || true
