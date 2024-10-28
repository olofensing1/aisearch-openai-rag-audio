metadata description = 'Creates an Azure Container Registry and an Azure Container Apps environment.'
param name string
param location string = resourceGroup().location
param tags object = {}

param containerAppsEnvironmentName string
param containerRegistryName string
param containerRegistryResourceGroupName string = ''
param containerRegistryAdminUserEnabled bool = false
param logAnalyticsWorkspaceResourceId string
param virtualNetworkSubnetId string = ''
@allowed(['Consumption', 'D4', 'D8', 'D16', 'D32', 'E4', 'E8', 'E16', 'E32', 'NC24-A100', 'NC48-A100', 'NC96-A100'])
param workloadProfile string

var workloadProfiles = workloadProfile == 'Consumption'
  ? [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  : [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
      {
        minimumCount: 0
        maximumCount: 2
        name: workloadProfile
        workloadProfileType: workloadProfile
      }
    ]

@description('Optional user assigned identity IDs to assign to the resource')
param userAssignedIdentityResourceIds array = []

module containerAppsEnvironment 'br/public:avm/res/app/managed-environment:0.5.2' = {
  name: '${name}-container-apps-environment'
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId

    managedIdentities: empty(userAssignedIdentityResourceIds) ? {
      systemAssigned: true
    } : {
      userAssignedResourceIds: userAssignedIdentityResourceIds
    }

    name: containerAppsEnvironmentName
    // Non-required parameters
    infrastructureResourceGroupName: containerRegistryResourceGroupName
    infrastructureSubnetId: virtualNetworkSubnetId
    location: location
    tags: tags
    zoneRedundant: false
    workloadProfiles: workloadProfiles
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.3.1' = {
  name: '${name}-container-registry'
  scope: !empty(containerRegistryResourceGroupName)
    ? resourceGroup(containerRegistryResourceGroupName)
    : resourceGroup()
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: containerRegistryAdminUserEnabled
    acrSku: 'Premium'
    exportPolicyStatus: 'enabled' // Nodig om public network access in te kunnen schakelen
    publicNetworkAccess: 'Enabled' // Schakel publieke toegang in of uit
    networkRuleSetDefaultAction: 'Deny' // Blokkeer alle toegang, tenzij specifiek toegestaan
    // Specificeer de toegestane IP-adressen
    networkRuleSetIpRules: [
       {
         action: 'Allow'
         value: '77.160.9.240'}
          {
            action: 'Allow'
            value: '62.59.40.1/32' // rdw ip
          }
          {
            action: 'Allow'
            value: '4.231.160.36/32' // container app env
          }
          {
            action: 'Allow'
            value: '4.175.195.54/32' // container app env
          }
                    // Azure IPs
          {
            action: 'Allow'
            value: '4.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '9.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '13.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '20.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '23.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '40.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '48.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '50.85.0.0/16'
          }
          {
            action: 'Allow'
            value: '51.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '52.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '57.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '64.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '65.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '68.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '70.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '72.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '74.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '85.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '94.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '98.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '102.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '103.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '104.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '108.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '111.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '131.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '132.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '134.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '135.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '137.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '138.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '151.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '157.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '158.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '167.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '168.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '172.205.0.0/16'
          }
          {
            action: 'Allow'
            value: '191.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '193.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '199.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '202.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '204.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '207.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '209.0.0.0/8'
          }
          {
            action: 'Allow'
            value: '213.0.0.0/8'
          }
       ]
     }
    //tags: tags
    }


output defaultDomain string = containerAppsEnvironment.outputs.defaultDomain
output environmentName string = containerAppsEnvironment.outputs.name
output environmentId string = containerAppsEnvironment.outputs.resourceId

output registryLoginServer string = containerRegistry.outputs.loginServer
output registryName string = containerRegistry.outputs.name
