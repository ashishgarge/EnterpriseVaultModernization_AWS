Store installation media on S3:
s3://enterprise-vault-installers/
Enterprise Vault Installation Script
$EVMedia = " s3://enterprise-vault-installers/"
Start-Process "$EVMedia\setup (x64).exe" -ArgumentList "/s /clone_wait /v "LOGFILE=\"D:\Logs\EVinstall.log\" COMPONENTS=VAULT" -Wait
