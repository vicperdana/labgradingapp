# Script that will check the current subscription 

[CmdletBinding()]
param
(
    [Parameter (Mandatory = $false)]
    [object] $WebhookData
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

## Grab data from webhook ##
if ($WebHookData){

    # Collect properties of WebhookData
    $WebhookName     =     $WebHookData.WebhookName
    $WebhookHeaders  =     $WebHookData.RequestHeader
    $WebhookBody     =     $WebHookData.RequestBody

    # Collect individual headers. Input converted from JSON.
    $InputData = (ConvertFrom-Json -InputObject $WebhookBody)
    Write-Output "WebhookBody: $InputData"
    $StudentName = $InputData.StudentName
    $resourceGroupName = $InputData.resourceGroup
    $EmailTo = $InputData.EmailTo
    Write-Output -InputObject ('Runbook started from webhook {0} by {1}.' -f $WebhookName, $StudentName)
}
else
{
   Write-Error -Message 'Runbook was not started from Webhook' -ErrorAction stop
}

$results += "<HTML><h2>Engineer: $StudentName </h2>"

### GLOBAL VARIABLES ###
$results = @()
$markColor = "red"
Function Send-EmailOnFailure()
{
        $creds = Get-AutomationPSCredential -Name 'sendgrid'

    $userName = $creds.UserName
    $securePassword = $creds.Password
    $password = $creds.GetNetworkCredential().Password

    $Username =$username
    $Password = ConvertTo-SecureString $password -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential $Username, $Password
    $SMTPServer = "smtp.sendgrid.net"
    $EmailFrom = "vic.perdana@dimensiondata.com"
    $Subject = "MOCK 003 Grade: Resource group $resourceGroupName not found - please check before running again"
    $Body = " "

    Send-MailMessage -smtpServer $SMTPServer -Credential $credential -Usessl -Port 587 -from $EmailFrom -to $EmailTo -subject $Subject -Body $Body -BodyAsHtml
}
Function Get-ResourceAssignment ($resourceGroupName, $resourceType, $numberOfResources)
{
    try{
        $ErrorActionPreference = 'Stop'
        $res = Get-AzureRmResource -ResourceGroupName $resourceGroupName | Where-Object {$_.ResourceType -eq $resourceType}
        if ($res.Count -ge $numberOfResources)
        {
            $mark = "[PASSED]"
        }
        else 
        {
            $mark = "[FAILED]"
        } 
        return $mark
    }
    catch {
        Send-EmailOnFailure
        Exit
    } 
}

$results += "<HTML><h2>Engineer: $StudentName </h2>"

# Check Application Gateway 
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/applicationGateways" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking App Gateway(s)...........$mark</font></h4>"

# Check Storage Account
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Storage/storageAccounts" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking Storage Account(s)...........$mark</font></h4>"

# Check Runbook
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Automation/automationAccounts/runbooks" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking Runbook(s)...........$mark</font></h4>"

# Check Automation Account
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Automation/automationAccounts" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking Automation Account(s)...........$mark</font></h4>"

# Check VNET 
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/virtualNetworks" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking VNET(s)...........$mark</font></h4>"

# Check Recovery Services Vault
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.RecoveryServices/vaults" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking ASR vault(s)...........$mark</font></h4>"

# Check Network Interfaces
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/networkInterfaces" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking NIC(s)...........$mark</font></h4>"

# Check VMs
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Compute/virtualMachines" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking VM(s)...........$mark</font></h4>"

# Check Disk
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Compute/disks" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking disk(s)...........$mark</font></h4>"

# Check Public IP
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/publicIPAddresses" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking Public IP address(es)...........$mark</font></h4>"

# Check Network Security Groups
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/networkSecurityGroups" 1
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking Security Group(s)...........$mark</font></h4>"
$results += "</HTML>"


$creds = Get-AutomationPSCredential -Name 'sendgrid'

$userName = $creds.UserName
$securePassword = $creds.Password
$password = $creds.GetNetworkCredential().Password

$Username =$username
$Password = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $Username, $Password
$SMTPServer = "smtp.sendgrid.net"
$EmailFrom = "vic.perdana@dimensiondata.com"
$Subject = "Mock 003 Results for $studentName"
$Body = $results | out-string

Send-MailMessage -smtpServer $SMTPServer -Credential $credential -Usessl -Port 587 -from $EmailFrom -to $EmailTo -subject $Subject -Body $Body -BodyAsHtml