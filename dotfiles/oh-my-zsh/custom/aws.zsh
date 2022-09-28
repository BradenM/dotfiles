# AWS Utils

auth-ecr() {
  if [[ $# -ge 2 ]]; then
    account_id="$1"
    ecr_repo="$2"
    region="${3:-us-east-1}"
    printf "Authenticating w/ ECS: (%s @ %s) [%s]" "${account_id}" "${ecr_repo}" "${region}"
    aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "${account_id}.dkr.ecr.${region}.amazonaws.com/${ecr_repo}"
  else
    echo 1>&2 "Usage: auth-ecr [ACCOUNT_ID] [ECR_REPO] (REGION=us-east-1)"
  fi
}

# Get EKS token
ekstoken() {
  cluster=$(kubectx -c | awk -F '/' '{print $2}')
  echo "Retrieving token for: ${cluster}"
  token=$(aws eks get-token --cluster "$cluster" | jq -r '.status.token')
  echo "$token" | wl-copy
  echo "Copied token to clipboard:"
  echo "$token"
}

#AWSume alias to source the AWSume script
alias awsume="source ${HOME}/.local/bin/awsume"

#Auto-Complete function for AWSume
fpath=(~/.awsume/zsh-autocomplete/ $fpath)
