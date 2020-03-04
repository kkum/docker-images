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
    az acr login --name $Repository ;
    # tag the file fot repository
    docker image tag $tag $repositoryTag;
    # push the image
    docker image push $repositoryTag;
}
if($RemoveFile.IsPresent){
    Remove-Item $TagFile
}
