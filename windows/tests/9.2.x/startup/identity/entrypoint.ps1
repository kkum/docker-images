Write-Host "### Configuring Identity Server"

$xdts = [System.Collections.ArrayList]@(); `
$xdts.AddRange(@(Get-ChildItem -Path 'C:\\src\\Config\\production\\*.xml.xdt' -Recurse)); `
$xdts |ForEach-Object {
    Write-Host $_.FullName
    $destinationPath = ($_.FullName -replace "C:\\src", "C:\\inetpub\\wwwroot")
    Write-Host $destinationPath
    Copy-Item $_.FullName $destinationPath -Verbose
}

Write-Host "### Transform xdts"
$xdts = [System.Collections.ArrayList]@(); `
$xdts.AddRange(@(Get-ChildItem -Path 'C:\\inetpub\\wwwroot\\Config\\production\\*.xml.xdt' -Recurse)); `
$xdts | ForEach-Object { (Get-Content -Path $_.FullName).Replace('${identity_client_certificate_thumbprint}', $env:IDENTITY_CLIENT_CERT_THUMBPRINT) | Out-File -FilePath $_.FullName -Encoding utf8; }; `
$xdts | ForEach-Object { & 'C:\\tools\\scripts\\Invoke-XdtTransform.ps1' -Path $_.FullName.Replace('.xdt', '') -XdtPath $_.FullName -XdtDllPath 'C:\\tools\\bin\\Microsoft.Web.XmlTransform.dll'; }; `
$xdts | ForEach-Object { Remove-Item -Path $_.FullName; };
