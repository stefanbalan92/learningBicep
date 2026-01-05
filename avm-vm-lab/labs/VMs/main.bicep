
targetScope = 'resourceGroup'

@description('VM size')
param vmSize string = 'Standard_D2s_v3'

@description('Availability zone: -1 = regional, or 1/2/3')
@allowed([-1, 1, 2, 3])
param availabilityZone int = 3

@description('Name for the VM.')
param vmName string = 'labvm01'   // <---- Declare vmName here

@description('Admin username for Linux.')
param adminUsername string = 'azureuser'

@description('SSH public key (PUBLIC key).')
@secure()
param sshPublicKey string

@description('Subnet resource ID where the NIC will attach.')
param subnetResourceId string

// Ubuntu 22.04 LTS
var imageReference = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-jammy'
  sku: '22_04-lts'
  version: 'latest'
}

// Required osDisk shape for this module version
var osDisk = {
  name: '${vmName}-osdisk'
  diskSizeGB: 30
  caching: 'ReadWrite'
  managedDisk: { storageAccountType: 'Standard_LRS' }
}

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

module labvm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: 'avm-labvm01'
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
  }
}
