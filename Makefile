# Docker FlexGet Image
# Copyright (c) Winston Astrachan 2020

help:
	@echo ""
	@echo "Usage: make COMMAND"
	@echo ""
	@echo "Docker FlexGet image makefile"
	@echo ""
	@echo "Commands:"
	@echo "  build        Build and tag image"
	@echo "  run          Start container in the background with locally mounted volume"
	@echo "  stop         Stop and remove container running in the background"
	@echo "  clean        Mark image for rebuild"
	@echo "  delete       Delete image and mark for rebuild"
	@echo ""

build: .flexget.img

.flexget.img:
	docker build -t wastrachan/flexget:latest .
	@touch $@

.PHONY: run
run: build
	docker run -v "$(CURDIR)/config:/config" \
	           --name flexget \
	           -e PUID=1111 \
	           -e PGID=1112 \
	           --restart unless-stopped \
	           -d \
	           wastrachan/flexget:latest

.PHONY: stop
stop:
	docker stop flexget
	docker rm flexget

.PHONY: clean
clean:
	rm -f .flexget.img

.PHONY: delete
delete: clean
	docker rmi -f wastrachan/flexget
