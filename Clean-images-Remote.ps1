az acr repository list --name versusmind -o table | Where-Object {
    $_.indexof("sitecore") -ge 0
} | ForEach-Object {
    az acr repository delete -n versusmind --repository $_ --yes
}
az acr repository list --name versusmind -o table | Where-Object {
    $_.indexof("mssql-developer") -ge 0
} | ForEach-Object {
    az acr repository delete -n versusmind --repository $_ --yes
}
az acr repository list --name versusmind -o table | Where-Object {
    $_.indexof("windows-hosts-writer") -ge 0
} | ForEach-Object {
    az acr repository delete -n versusmind --repository $_ --yes
}