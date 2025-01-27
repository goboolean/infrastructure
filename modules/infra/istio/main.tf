resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.24.2"

  timeout = 300
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = "istio-system"
  version    = "1.24.2"

  depends_on = [helm_release.istio_base]
  timeout    = 300
}

resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  version    = "1.24.2"

  depends_on = [helm_release.istiod]
  timeout    = 300
}

data "kubernetes_service" "istio_ingressgateway" {
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-system"
  }

  depends_on = [helm_release.istio_ingressgateway]
}
