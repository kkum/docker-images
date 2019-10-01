$userName = versusmind
$repositories = (az acr repository list -n $userName | ConvertFrom-Json) | Where-Object {  $_ -notlike 'start*' -and $_ -notlike '*qube'}

foreach( $repositoryName in $repositories){
     $tags = (az acr repository show-tags --name $userName --repository $repositoryName | ConvertFrom-Json) | Where-Object { $_ -notlike "*1903"}

    foreach($tag in $tags){
        az acr repository delete -n $userName --image ${repositoryName}:${tag} --yes
    }
}