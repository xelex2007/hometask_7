
write-host "Connect to your AzureRM account:"
connect-azurermaccount

$adminusername = read-host "Enter admin login"
$keyvaultname = read-host "Enter vault name"
write-host "Getting parameters for deployment . . . "
$keyvaults = Get-AzureRmKeyVault
foreach($keyvault in $keyvaults){
    if($keyvault.vaultname -eq $keyvaultname){
        $keyvaultresourceid = $keyvault.ResourceId
    }
    else {
        write-host "There is no such vault in your account, reenter vault name"
        $keyvaultname = read-host "Enter vault name"
    }
}
$secretname = (Get-AzureKeyVaultSecret -VaultName $keyvaultname | where-object{$_.name -like "admin*"}).name

write-host "Deployment . . . "
New-AzureRmResourceGroupDeployment -ResourceGroupName testrg -TemplateFile .\deployment.json -adminUsername $adminusername -keyvaultid $keyvaultresourceid -secretname $secretname