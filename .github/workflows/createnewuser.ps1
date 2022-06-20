Param (
[string]$uname ,
[string]$password, 
[string]$apitoken,
[Parameter(Mandatory = $false)]
 [ValidateSet('Admin','Client')]
[string]$role,
[string]$path1,
[string]$path2
)
$username = $uname.ToLower()
write-output "hello World"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
if (-not("dummy" -as [type])) {
    add-type -TypeDefinition @"
using System;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public static class Dummy {
    public static bool ReturnTrue(object sender,
        X509Certificate certificate,
        X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }
    public static RemoteCertificateValidationCallback GetDelegate() {
        return new RemoteCertificateValidationCallback(Dummy.ReturnTrue);
    }
}
"@
}

[System.Net.ServicePointManager]::ServerCertificateValidationCallback = [dummy]::GetDelegate()

Switch ($role)
{
"Admin"
{


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("filemage-api-token", "$apitoken")
$headers.Add("Content-Type", "application/json")

$body = "{
`n  `"username`": `"$uname`",
`n  `"password`": `"$password`",
`n  `"endpointId`": 1,
`n  `"disabled`": false,
`n  `"home`": {
`n    `"path`": `"$path1`",
`n    `"sub`": true,
`n    `"grants`": `"full`"
`n  }
`n}"

$response = Invoke-RestMethod 'https://10.152.250.17/users/' -Method 'POST' -Headers $headers -Body $body
Invoke-RestMethod "https://10.152.250.17/users/$($response.id)/" -Method 'Get' -Headers $headers
$response | ConvertTo-Json
}
"Client"
{$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("filemage-api-token", "$apitoken")
$headers.Add("Content-Type", "application/json")

$body = "{
`n  `"username`": `"$uname`",
`n  `"password`": `"$password`",
`n  `"endpointId`": 1,
`n  `"disabled`": false,
`n  `"home`": {
`n    `"path`": `"$path2`",
`n    `"sub`": true,
`n    `"grants`": `"full`"
`n  }
`n}"

$response = Invoke-RestMethod 'https://10.152.250.17/users/' -Method 'POST' -Headers $headers -Body $body
Invoke-RestMethod "https://10.152.250.17/users/$($response.id)/" -Method 'Get' -Headers $headers
$response | ConvertTo-Json}}
© 2022 GitHub, Inc.
Terms
Privacy
