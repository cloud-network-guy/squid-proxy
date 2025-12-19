SERVICE = squid-proxy
PORT = 3128
PLATFORM := linux/amd64
DOCKER_PORT := 3128

include Makefile.env

all: docker
docker: docker-build docker-run

docker-build:
	docker build --tag $(SERVICE) --platform $(PLATFORM) .

docker-run:
	docker run -p $(DOCKER_PORT)\:$(PORT) $(SERVICE)

docker-push:
	docker push $(SERVICE)

