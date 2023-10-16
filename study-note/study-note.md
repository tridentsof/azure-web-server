Packer:
  - If we want to provide the packer client_id , secret_id, we have to create rbac:
  az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"

  