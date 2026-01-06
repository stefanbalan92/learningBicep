
targetScope = 'subscription'

@description('Deployment location for RGs and regional resources.')
param location string = 'westeurope'

@description('Core resource group name (shared/network).')
param coreRgName string = 'isblab1-core-rg'

@description('Workload resource group name (VM, NIC, disks).')
param workloadRgName string = 'isblab1-workload-rg'

@description('VNet name in the core RG.')
param vnetName string = 'labvm-vnet'

@description('Default subnet name.')
param subnetName string = 'default'

@description('VNet address space.')
param vnetAddressPrefix string = '10.1.0.0/16'

@description('Default subnet address prefix.')
param subnetAddressPrefix string = '10.1.1.0/24'

@description('VM size')
param vmSize string = 'Standard_B2ts_v2'

@description('Availability zone: -1 = regional, or 1/2/3')
@allowed([-1, 1, 2, 3])
param availabilityZone int = -1

@description('Name for the VM.')
param vmName string = 'labvm01'

@description('Admin username for Linux.')
param adminUsername string = 'azureuser'

@description('SSH public key (PUBLIC key).')
@secure()
param sshPublicKey string

// --- Create resource groups in West Europe ---
resource coreRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: coreRgName
  location: location
  tags: {
    workload: 'core'
    region: location
  }
}

resource workloadRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: workloadRgName
  location: location
  tags: {
    workload: 'workload'
    region: location
  }
}

// --- VNet+Subnet module (deployed into Core RG) ---
module coreVnet 'vnet.bicep' = {
  name: 'core-vnet'
  scope: resourceGroup(coreRgName)
  params: {
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    location: location // ensure VNet in West Europe
  }
  dependsOn: [ coreRg ]
  
}
  

// Subnet resource ID from the VNet module
var subnetResourceId = coreVnet.outputs.subnetId

// --- VM (AVM) into Workload RG in West Europe Zone 3 ---

// Ubuntu 22.04 LTS image
var imageReference = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-jammy'
  sku: '22_04-lts'
  version: 'latest'
}

// Required disk shape for AVM 0.21.0
var osDisk = {
  name: '${vmName}-osdisk'
  diskSizeGB: 30
  caching: 'ReadWrite'
  managedDisk: { storageAccountType: 'Standard_LRS' }
}

// Private NIC, single IP config into the core subnet
var nicConfigurations = [
  {
    name: '${vmName}-nic0'
    ipConfigurations: [
      {
        name: 'ipconfig01'
        subnetResourceId: subnetResourceId
      }
    ]
  }
]

// AVM Virtual Machine module (pinned version)
module labvm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: 'avm-labvm01'
  scope: resourceGroup(workloadRgName)
  params: {
    name: vmName
    osType: 'Linux'
    vmSize: vmSize
    availabilityZone: availabilityZone
    nicConfigurations: nicConfigurations
    osDisk: osDisk
    imageReference: imageReference
    adminUsername: adminUsername
    publicKeys: [
      { path: '/home/${adminUsername}/.ssh/authorized_keys', keyData: sshPublicKey }
    ]
    disablePasswordAuthentication: true   // <-- add this line
    // Optional: identity / diagnostics can be added later
  }
  dependsOn: [
    workloadRg
  ]
}

// Helpful outputs
output workloadRgNameOut string = workloadRgName
output vmNameOut string = vmName
output subnetIdOut string = subnetResourceId
