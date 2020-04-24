param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [Alias("Registry")]
    [string] $Repository,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $TagFile,
    [switch] $TagOnly,
    [Alias("Rm")]
    [switch] $RemoveFile

)

Get-Content $TagFile | ForEach-Object {
    $tag = $_ ;
    Write-Host "Processing $tag"
    $repositoryTag = "$($Repository).azurecr.io/$($tag)" ;
    Write-Host "Processing $repositoryTag"

    $tagId = $(docker images "$tag" --format "{{.ID}}")
    $repositoryTagId = $(docker images "$repositoryTag" --format "{{.ID}}")

    # (re)tag the file for repository if necessary
    if ( ($null -eq $repositoryTagId) -or ($tagId -ne $repositoryTagId)) {

        Write-Host "Tagging $tag to $repositoryTag"
        docker image tag $tag $repositoryTag;
    }
    if (!$TagOnly.IsPresent) {
        #Ensure login
        az acr login --name $Repository ;
        # push the image
        docker image push $repositoryTag;
    }
}
if ($RemoveFile.IsPresent) {
    Remove-Item $TagFile
}
