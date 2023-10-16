# Variables
rgName="udacity-project-1"
location="eastus"
subscriptionId="d381139d-0fa2-4a19-a4a0-0df928a317be"
policyDefinition="deny-no-tag-policy"
policyApply="deny-no-tag-assignment"

# Create resource group
az group create \
 --name $rgName \
 --location $location

# Create policy rules
az policy definition create \
 --name $policyDefinition \
 --rules 'resource-policy.json' \
 --display-name "Deny resource creation without specific tag"

# Apply the policy rules
az policy assignment create \
 --name $policyApply \
 --scope '/subscriptions/d381139d-0fa2-4a19-a4a0-0df928a317be/providers/Microsoft.Authorization/policyDefinitions/deny-no-tag-policy' \
 --policy $policyDefinition \