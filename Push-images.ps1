$d2kir_images = $(docker images "d2kir.azurecr.io/*" --format "{{ .Repository}}:{{.Tag}}")
$vm_images = $(docker images "versusmind.azurecr.io/*" --format "{{ .Repository}}:{{.Tag}}")


($d2kir_images | Measure-Object).Count
($vm_images | Measure-Object).Count

$vm_images |
ForEach-Object {
    az acr login --name versusmind ;
    docker image push $_ ;
}