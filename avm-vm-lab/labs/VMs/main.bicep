
targetScope = 'resourceGroup'

param vmName string = 'cheapvm'
param adminUsername string = 'azureuser'
@secure()
param sshPublicKey string
param subnetResourceId string

var imageReference = {
  publisher: 'Canonical'
  offer: '0001-com-ubuntu-server-jammy'
  sku: '22_04-lts'
  version: 'latest'
}

var osDisk = {
  
name: '${vmName}-osdisk'
  diskSizeGB: 30
  caching: 'ReadWrite'
  managedDisk: {             // <- REQUIRED by the module's type definition
    storageAccountType: 'Standard_LRS'
  }

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

module vm 'br/public:avm/res/compute/virtual-machine:0.21.0' = {
  name: 'avm-cheapvm'
  params: {
    name: vmName
    osType: 'Linux'
    vmSize: 'Standard_B1s' // Cheapest size
    availabilityZone: -1
    nicConfigurations: nicConfigurations
    osDisk: osDisk
    imageReference: imageReference
    adminUsername: adminUsername
    publicKeys: [
      { path: '/home/${adminUsername}/.ssh/authorized_keys', keyData: sshPublicKey }
    ]
  }
}
