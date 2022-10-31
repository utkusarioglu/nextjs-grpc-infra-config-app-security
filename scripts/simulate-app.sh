#!/bin/bash

simulate_app() {
  kubectl -n vault exec vault-0 -- vault read \
    -format=json \
    auth/approle/role/web-app/role-id > \
    artifacts/web-app.role-id.json
  

  kubectl -n vault exec vault-0 -- vault write \
    -format=json \
    -force \
    auth/approle/role/web-app/secret-id > \
    artifacts/web-app.secret-id.json

  kubectl -n vault exec vault-1 -- vault write \
    -format=json \
    auth/approle/login \
    role_id="$(jq -r .data.role_id artifacts/web-app.role-id.json)" \
    secret_id="$(jq -r .data.secret_id artifacts/web-app.secret-id.json)" > \
    artifacts/web-app.login.json

  sleep 30;

  for attempt in {1..4}; do
    sleep 10;
    echo "Attempt $attempt"
    if [ $attempt -gt 3 ]; then
      echo "This one should fail"
    fi
    echo $(kubectl -n vault exec vault-1 -- sh -c "\
      VAULT_TOKEN=\"$(jq -r .auth.client_token artifacts/web-app.login.json)\" \
      vault read \
      -format=json \
      secrets/mysql/web-app \
    ") | jq '.data'
    echo
  done
}
simulate_app
