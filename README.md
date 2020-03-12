# Deploying spark to k8s

## Procedure

1. helm install spark bitnami/spark -n spark -f values.yaml
2. deploy docker image as job to same k8s cluster