
#!/bin/bash
# Remove helm charts
helm delete db helm-charts/db/
helm delete web helm-charts/web/
helm delete words helm-charts/words/
kubectl delete -f helm-charts/ingress-controller.yaml

# Remove Istio
kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
