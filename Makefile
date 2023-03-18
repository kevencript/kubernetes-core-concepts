deploy-from-scratch:
	$(MAKE) create-kind-cluster
	$(MAKE) apply-k8s

create-kind-cluster:
	kind create cluster --config kind-config.yaml --name $(NAMESPACE)
	kind export kubeconfig --name $(NAMESPACE)

deploy:
	kubectl apply -f k8s

delete:
	kubectl delete -f k8s

redeploy:
	$(MAKE) delete
	$(MAKE) deploy
	sleep 3
	$(MAKE) port-forward

port-forward: 
	kubectl port-forward svc/go-http-app-service 8000:80