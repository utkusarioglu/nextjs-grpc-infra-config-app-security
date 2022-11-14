#!/bin/bash

source scripts/terraform-checks.sh || exit 2

check_env
check_repo_config

resources=${1:-$DEFAULT_KUBECTL_WATCH_RESOURCES}
namespace_sorted="po svc ds sts"
wide="po no sts ing"

echo "watch '\
  for resource in $resources; do \
    echo \$resource; \
    kubectl get \$resource \
      -A \
      \$(if echo "$namespace_sorted" | grep -q \$resource; then \
        echo \"--sort-by=.metadata.namespace\"; \
      fi) \
      \$(if echo "$wide" | grep -q \$resource; then \
        echo \"-o=wide\"; \
      fi) \
      ; \
    echo; \
  done\
'" | \
tr -s " " | \
sh
