# =============================================================================
# Make variables
# =============================================================================
SMCP_NAMESPACE=istio-system
SMCP_RELEASE=v1
APP_NAMESPACE=todos
SMGW_RELEASE=v1
GATEWAY_URL=todos.apps-crc.testing
# =============================================================================
# Plain openshift manifests
# =============================================================================
project:
	@cat src/manifests/project.yaml | PROJECT=$(NAME) envsubst | oc apply -f -

uninstall-project:
	@cat src/manifests/project.yaml | PROJECT=$(NAME) envsubst | oc delete -f -
# =============================================================================
# Service Mesh Gateway certificates
# =============================================================================
gateway-certs:
	@mkdir -p .certs
	@oc get secret router-certs-default \
  		-n openshift-ingress \
  		-o json | jq -r '.data."tls.crt"' | base64 -d > .certs/tls.crt
	@oc get secret router-certs-default \
  		-n openshift-ingress \
  		-o json | jq -r '.data."tls.key"' | base64 -d > .certs/tls.key
	@oc get configmap default-ingress-cert \
	  -n openshift-config-managed \
	  -o json | jq -r '.data."ca-bundle.crt"' > .certs/ca-bundle.crt
	@oc create secret generic gateway-certs -n $(SMCP_NAMESPACE)  \
  		--from-file=key=.certs/tls.key \
  		--from-file=cert=.certs/tls.crt \
  		--from-file=cacert=.certs/ca-bundle.crt
	@rm -r -f .certs

uninstall-gateway-certs:
	@oc delete secret gateway-certs -n $(SMCP_NAMESPACE)
# =============================================================================
# Service Mesh Control Plane targets
# =============================================================================
install-smcp:
	@helm install --namespace=$(SMCP_NAMESPACE) \
		--set smcp.enabled=true \
		--set smcp.name=default \
		--set smcp.namespace=$(SMCP_NAMESPACE) \
		--set smmr.enabled=true \
		--set smmr.name=default \
		--set smmr.namespace=$(SMCP_NAMESPACE) \
		--set "smmr.members={dev, todos}" \
		smcp-$(SMCP_RELEASE) \
		./src/helm/service-mesh

uninstall-smcp:
	@helm uninstall --namespace=$(SMCP_NAMESPACE) \
		smcp-$(SMCP_RELEASE)
# =============================================================================
# Service Mesh Gateway targets
# =============================================================================
install-gateway:
	@helm install --namespace $(APP_NAMESPACE) \
		--set istio.gateway.name=todos-gateway \
		--set istio.gateway.namespace=$(APP_NAMESPACE) \
		--set istio.gateway.hosts={"$(GATEWAY_URL)"} \
		service-mesh-gateway-$(SMGW_RELEASE) \
		./src/helm/service-mesh-gateway

uninstall-gateway:
	@helm uninstall --namespace $(APP_NAMESPACE) service-mesh-gateway-$(SMGW_RELEASE)

# =============================================================================
# Troubleshooting hacks
# =============================================================================
trouble:
	istioctl -n $(SMCP_NAMESPACE) proxy-config listeners deploy/istio-ingressgateway
	istioctl -n $(SMCP_NAMESPACE) proxy-config routes deploy/istio-ingressgateway
	istioctl -n $(SMCP_NAMESPACE) proxy-config endpoints deploy/istio-ingressgateway
