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
ksecret() {
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

kubectl-node-types() {
  response=$(kubectl get nodes -o json | jq -r '
  def age(ts):
    (now - (ts|fromdateiso8601)|floor) as $n |
    ($n/86400|floor) as $d | ($n%86400/3600|floor) as $h |
    ($n%3600/60|floor) as $m | ($n%60|floor) as $s |
    (if $d>0 then "\($d)d " else "" end) +
    (if $h>0 or $d>0 then "\($h)h " else "" end) +
    (if $m>0 or $h>0 or $d>0 then "\($m)m " else "" end) +
    "\($s)s";
  .items[] | [
    .metadata.name,
    (.metadata.labels["node.kubernetes.io/instance-type"] // .metadata.labels["beta.kubernetes.io/instance-type"] // "-"),
    (.metadata.labels["karpenter.sh/capacity-type"] // .metadata.labels["karpenter.io/capacity-type"] // "-"),
    (((.status.conditions[]? | select(.type=="Ready") | .status) // "Unknown") as $s |
      if $s=="True" then "Ready" elif $s=="False" then "NotReady" else "Unknown" end),
    ((.metadata.finalizers // []) | join(",")),
    (age(.metadata.creationTimestamp))
  ] | @tsv
  ')
  printf 'NODE NODE_TYPE CAPACITY_TYPE STATUS FINALIZERS AGE\n%s' "$response" | column -t
}

kubectl-node-health() {
  kubectl get nodes -o 'custom-columns=NAME:.metadata.name,CONDITIONS:.status.conditions[*].type,STATUS:.status.conditions[*].status'
}

kubectl-node-events() {
  local node="${1:-}" 
  if [[ -n "$node" ]]; then
    kubectl get events -w --field-selector involvedObject.kind=Node,involvedObject.name="$node"
    return
  fi
  kubectl get events -w --field-selector involvedObject.kind=Node
}
