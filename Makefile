deploy: 
	./deploy.sh
	kubectl apply -f config/certificates.yaml
	kubectl apply -f config/deployment.yaml
	kubectl apply -f config/ingress.yaml
	kubectl apply -f config/service.yaml