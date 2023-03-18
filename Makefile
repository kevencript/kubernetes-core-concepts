deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) apply-k8s

create-kind-cluster:
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	kind export kubeconfig --name $(NAMESPACE)
	$(MAKE) install-metrics-components

deploy:
	kubectl apply -f k8s
	$(MAKE) port-forward

delete:
	kubectl delete -f k8s

redeploy:
	$(MAKE) delete
	$(MAKE) deploy
	$(MAKE) port-forward

port-forward: 
	sleep 4
	kubectl port-forward svc/go-http-app-service 8000:80

install-metrics-components:
	kubectl apply -f k8s/metrics-server.yaml
	kubectl wait --namespace kube-system \
    --for=condition=available deployment/metrics-server \
    --timeout=60s

stress-test-fortio:
	kubectl run -it fortio --rm --image=fortio/fortio -- load \
		-qps 800 \
		-t 120s \
		-c 70 \
		"http://go-http-app-service/healthz"

