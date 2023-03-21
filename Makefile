# Cluster Creation
deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) deploy

delete-from-scratch:
	kind delete cluster -n k8s-concepts

create-kind-cluster:
	kind create cluster --config ./k8s/kind/kind-config.yaml --name k8s-concepts
	kind export kubeconfig --name k8s-concepts
	$(MAKE) install-ingress-controller
	$(MAKE) install-cert-manager
	$(MAKE) install-metrics-components
	$(MAKE) config-contexts

# Kubernetes Shortcuts
deploy:
	kubectl apply -f k8s/namespaces.yaml
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
    --timeout=200s

install-ingress-controller:
	helm install ingress-nginx ingress-nginx/ingress-nginx --namespace nginx --create-namespace
	sleep 5
	kubectl wait --namespace nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=250s

install-cert-manager:
	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
	sleep 10
	kubectl wait --namespace cert-manager \
    --for=condition=available deployment/cert-manager \
    --timeout=300s

# Kubernetes Context
config-contexts:
	kubectl config set-context server \
		--namespace=server \
		--cluster=kind-k8s-concepts \
		--user=kind-k8s-concepts

	kubectl config set-context database \
		--namespace=database \
		--cluster=kind-k8s-concepts \
		--user=kind-k8s-concepts

	kubectl config view

database-context:
	kubectl config use-context database
	
server-context:
	kubectl config use-context server

default-context:
	kubectl config use-context kind-k8s-concepts

# Stress Tests
stress-test-fortio:
	kubectl run -it fortio --rm --image=fortio/fortio -- load \
		-qps 800 \
		-t 120s \
		-c 70 \
		"http://go-http-app-service/healthz"

