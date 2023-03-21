# Kubernetes Shortcuts
deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) deploy

create-kind-cluster:
	kind create cluster --config ./k8s/kind/kind-config.yaml --name k8s-concepts
	kind export kubeconfig --name k8s-concepts
	$(MAKE) install-metrics-components
	$(MAKE) install-ingress-controller

deploy:
	kubectl apply -f k8s

delete:
	kubectl delete -f k8s

redeploy:
	$(MAKE) delete
	$(MAKE) deploy

port-forward: 
	kubectl port-forward svc/go-http-app-service 8000:80

# Dependecies Installing
install-metrics-components:
	kubectl apply -f k8s/metrics-server.yaml
	kubectl wait --namespace kube-system \
    --for=condition=available deployment/metrics-server \
    --timeout=60s

install-ingress-controller:
	helm install ingress-nginx ingress-nginx/ingress-nginx --namespace nginx --create-namespace

install-cert-manager:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml

# Stress Tests
stress-test-fortio:
	kubectl run -it fortio --rm --image=fortio/fortio -- load \
		-qps 800 \
		-t 120s \
		-c 70 \
		"http://go-http-app-service/healthz"

