output "istio_ingress_ip" {
  value       = data.kubernetes_service.istio_ingressgateway.status.0.load_balancer.0.ingress.0.ip
}
