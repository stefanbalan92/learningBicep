
using './main.bicep'

param location = 'westeurope'                // Region for RGs + VNet + VM
param coreRgName = 'isblab1-core-rg'
param workloadRgName = 'isblab1-workload-rg'

param vnetName = 'labvm-vnet'
param subnetName = 'default'
param vnetAddressPrefix = '10.1.0.0/16'
param subnetAddressPrefix = '10.1.1.0/24'

param vmSize = 'Standard_B2ts_v2'
param availabilityZone = -1
param vmName = 'labvm01'
param adminUsername = 'azureuser'

// Paste your PUBLIC key (from Cloud Shell: cat ~/.ssh/id_rsa.pub)
param sshPublicKey = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAw1SS0aCjF36mEEg4nk/uZFu2oZWMv2Qj3G84iJsmfrV3Xm34BF8zexj1mgKIa1NyCaBMKWxcAkjon7BVVF/Qp8cxmMlGFeF9OTKkp9Y8GokcWNAGy7EOfWAl4MR4z7nNZSFFpDdbmJHKu/mHNEqu7FwUXp5jTlyoaZ96Jp5F2UiZ3WIBM7YsqU9n1vhhPLo+3WQcE5DTBfZf+FmxlpbO13i7Gmb2wYhWPfovwG7d2sof8rl2yITYwB0Dk0h7S+FfBRVvdO3mOcFGeRd+d2ugLqvF6CWej8UjEcQ3W3ChRXf7qsrJMLUMV+l2YgD16s3BoUizSQRwmF4ncrXzCiMZcFp1FRqEhSjXt5c4tMgTfGCdem6VdPnjFUmFamPBZFVbeBeAGvRTAopJ9AWhR0B+GF66XAw96FNe5FkwIRQ+QuISJEZb/FX//pW5HhNDg5f+DTP4W0ituGpsRZq59Xbn0Awo5oWWuLA2t4s1ADRwS7YO+5/rz+2pJGWzI6r6iTreJiyQR7ln5A2Ie8KVUcBd/VUtEsLg2sNQfzGDQSRuSVGmdWrNcvA/5nMuOQIphRAipdIpvCmeTms+4SCgJbrM31Xhh9UMLFQAfB1J7uOvT2v8NqIpo8QPxfWArRZ1tZo9QI9RwlJY6nPdcP/Wrlj2Vlk8q5r3YDMd5vXHImKM8w== stefan@lab'
