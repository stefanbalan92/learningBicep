
targetScope = 'resourceGroup'

@description('VNet name.')
param vnetName string

@description('VNet address space.')
param vnetAddressPrefix string = '10.1.0.0/16'

@description('Subnet name.')
param subnetName string = 'default'

@description('Subnet prefix.')
param subnetAddressPrefix string = '10.1.1.0/24'

@description('Explicit location for VNet (must match VM region).')
param location string = 'westeurope'

// Create VNet with one subnet in West Europe
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ vnetAddressPrefix ] }
    subnets: [
      {
        name: subnetName
        properties: { addressPrefix: subnetAddressPrefix }
      }
    ]
  }
}

output subnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
