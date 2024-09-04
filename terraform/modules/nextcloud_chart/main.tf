resource "helm_release" "nextcloud" {

    name = "${var.helm_release}" 
    repository = "${var.helm_repository}"
    chart = "${var.chart}"
    version = "${var.version}" //git version; releases
    
    

}