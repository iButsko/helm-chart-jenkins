
#!/bin/bash
# Remove helm charts
helm delete db helms/db/
helm delete web helms/web/
helm delete words helms/words/
kubectl delete -f helms/ingress-controller.yaml

# Remove Istio
kubectl delete -f samples/addons
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-
