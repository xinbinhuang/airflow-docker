IMAGE ?= xinbinhuang/airflow-docker


.PHONY: build
build: 
	docker build -t $(IMAGE) . 

.PHONY: web
web: 
	docker run -d -p 8080:8080 $(IMAGE) webserver

.PHONY: rm
rm:	
	docker rm $(docker ps -aq)