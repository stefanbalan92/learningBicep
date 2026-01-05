
using './main.bicep'

param vmName = 'cheapvm'
param adminUsername = 'azureuser'
param sshPublicKey = 'ssh-rsa AAAA...your-public-key...'
param subnetResourceId = '/subscriptions/152f080d-f706-4335-aa03-cf88ca4534e2/resourceGroups/isblab1-core-rg/providers/Microsoft.Network/virtualNetworks/isblab1-vnet/subnets/default'
