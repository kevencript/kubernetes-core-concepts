deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) apply-k8s

create-kind-cluster:
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	kind export kubeconfig --name $(NAMESPACE)
	$(MAKE) install-metrics-components

deploy:
	kubectl apply -f k8s
	sleep 3
	$(MAKE) port-forward

delete:
	kubectl delete -f k8s

redeploy:
	$(MAKE) delete
	$(MAKE) deploy
	sleep 3
	$(MAKE) port-forward

port-forward: 
	kubectl port-forward svc/go-http-app-service 8000:80

install-metrics-components:
	kubectl apply -f k8s/metrics-server.yaml
	kubectl wait --namespace kube-system \
    --for=condition=available deployment/metrics-server \
    --timeout=200s
