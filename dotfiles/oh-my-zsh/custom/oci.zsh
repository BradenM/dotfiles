# OCI related items.

# Docker / Compose
unalias dcrm
alias dcrm='docker compose run --rm'

# Minikube
alias mk='minikube'

# Kubectx
alias kctx='kubectx'

# Kubernetes
alias kevents="k get events --sort-by=.metadata.creationTimestamp"

# Get Secret
ksecret () {
  k get secret -n "${3:-default}" "$1" --output="jsonpath={.data.${2}}" | base64 --decode
}
# Update Secret
kupsecret() {
  secretName="$1"
  secretKey="$2"
  secretValue="$3"
  kubectl get secret -n "${4:-default}" "$secretName" -o json | jq --arg newVal "$(echo -n ${secretValue} | base64 -w 0)" $(printf '.data["%s"]=$newVal' "$secretKey") | kubectl apply -f -
}

# KubeSpy
alias kspy='kubespy'
