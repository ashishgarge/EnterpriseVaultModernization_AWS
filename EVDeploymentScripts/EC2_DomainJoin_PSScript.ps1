# ---------------------------------------------------
# Variables
# ---------------------------------------------------
$DomainName = "corp.company.com"
$DomainOU = "OU=EnterpriseVault,OU=Servers,DC=corp,DC=company,DC=com"
# Retrieve credentials from Secrets Manager
6
$Secret = (Get-SECSecretValue `
-SecretId "DomainJoinCredentials").SecretString
$Creds = $Secret | ConvertFrom-Json
$User = $Creds.username
$Pass = $Creds.password
$SecurePass = ConvertTo-SecureString $Pass -AsPlainText -Force
$Credential = New-Object `
System.Management.Automation.PSCredential `
($User,$SecurePass)
# ---------------------------------------------------
# Rename Computer
# ---------------------------------------------------
$InstanceID = Invoke-RestMethod `
http://169.254.169.254/latest/meta-data/instance-id
Rename-Computer -NewName "EV-$($InstanceID.Substring(0,6))"
# ---------------------------------------------------
# Join Domain
# ---------------------------------------------------
Add-Computer `
-DomainName $DomainName `
-Credential $Credential `
-OUPath $DomainOU `
-Restart