# Helm
## Steps
- Install helm `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash`

- Super hi-tech deployment command `helm template . -f values.yaml > applyMe.yaml && kubectl apply -f applyMe.yaml`

