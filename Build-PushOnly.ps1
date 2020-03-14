    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Repository = "versusmind",
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $TagFile,
        [Alias("Rm")]
        [switch] $RemoveFile

    )

Get-Content $TagFile| ForEach-Object {
    $tag = $_ ;
    $repositoryTag = "$($Repository).azurecr.io/$($tag)" ;
    #Ensure login
    $tagId = $(docker images "$tag" --format "{{.ID}}")
    $repositoryTagId = $(docker images "$tag" --format "{{.ID}}")

    # (re)tag the file for repository if necessary
    if ( ($null -eq $repositoryTagId) -or ($tagId -ne $repositoryTagId)) {
        docker image tag $tag $repositoryTag;
    }

    # push the image
    az acr login --name $Repository ;
    docker image push $repositoryTag;
}
if($RemoveFile.IsPresent){
    Remove-Item $TagFile
}
