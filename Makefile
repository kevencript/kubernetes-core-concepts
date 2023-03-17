deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) apply-k8s

create-kind-cluster:
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	kind export kubeconfig --name $(NAMESPACE)

apply-k8s:
	kubectl apply -f k8s

delete-k8s:
	kubectl delete -f k8s