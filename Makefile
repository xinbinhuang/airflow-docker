IMAGE ?= xinbinhuang/airflow-docker


.PHONY: build
build: 
	docker build -t $(IMAGE) . 

.PHONY: bash
bash:
	docker run -it --rm -p 8080:8080 $(IMAGE) 

.PHONY: web
web: 
	docker run -d --name=web -p 8080:8080 $(IMAGE) webserver
	echo "'web' is running..."

.PHONY: scheduler
scheduler:
	docker exec -d web airflow scheduler

CONT-LS = $(shell docker ps -aq)

.PHONY: rm
rm:	
	docker rm $(CONT-LS)

.PHONY: stop
stop: 
	docker stop $(CONT-LS)

