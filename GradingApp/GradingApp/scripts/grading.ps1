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
#StudentName=Jean-Pierre
#$resourceGroupName = "JPPMOCKLAB1"

### GLOBAL VARIABLES ###
$results = @()
$markColor = "red"

Function Get-ResourceAssignment ($resourceGroupName, $resourceType, $numberOfResources)
{
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

#$StudentName = "Jean-Pierre"
$results += "<HTML><h2>Engineer: $StudentName </h2>"
#$resourceGroupName = "JPPMOCKLAB1"

# Check Network Interfaces
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/networkInterfaces" 3
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of NICs...........$mark</font></h4>"

# Check VMs
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Compute/virtualMachines" 3
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of VMs...........$mark</font></h4>"

# Check Extensions
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Compute/virtualMachines/extensions" 7
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of VM Extensions...........$mark</font></h4>"

# Check Disk
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Compute/disks" 3
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of disks...........$mark</font></h4>"

# Check Public IP
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/publicIPAddresses" 3
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of Public IP addresses...........$mark</font></h4>"

# Check Network Security Groups
$mark = Get-ResourceAssignment $resourceGroupName "Microsoft.Network/networkSecurityGroups" 4
if($mark -eq "[PASSED]"){$markColor="green"}
else{$markColor="red"}
$results += "<h4><font color=$markColor>Checking number of Security Groups...........$mark</font></h4>"
$results += "</HTML>"


$userName = $creds.UserName
$securePassword = $creds.Password
$password = $creds.GetNetworkCredential().Password

$Username =$username
$Password = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $Username, $Password
$SMTPServer = "smtp.sendgrid.net"
$EmailFrom = "vic.perdana@dimensiondata.com"
$Subject = "Mock 001 Results for $studentName"
$Body = $results | out-string

Send-MailMessage -smtpServer $SMTPServer -Credential $credential -Usessl -Port 587 -from $EmailFrom -to $EmailTo -subject $Subject -Body $Body -BodyAsHtml


#https://s15events.azure-automation.net/webhooks?token=r7PPdtnafRDW%2fxZH%2bsHnQZCeiFHJyNb%2bEAXcYzRrE0E%3d



#https://s15events.azure-automation.net/webhooks?token=r7PPdtnafRDW%2fxZH%2bsHnQZCeiFHJyNb%2bEAXcYzRrE0E%3d
#https://s15events.azure-automation.net/webhooks?token=a6b%2bzN7Zuvd6x5CRZH84OBPv9CPZ0OOkT087vYVznqA%3d 


#$webhookData = {"WebhookName":"labgradinghook","RequestBody":"StudentName=Ron+Fritz&EmailTo=vic.perdana%40dimensiondata.com&ResourceGroup=JPPMOCKLAB1" "RequestHeader":{"Connection":"Keep-Alive","Expect":"100-continue","Host":"s15events.azure-automation.net" "x-ms-request-id":"f4da544b-c9f6-4cb2-b91d-cd4f6231fe30"}}
#bugZHNBV73:!]masxOG011(