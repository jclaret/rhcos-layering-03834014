# Makefile to build, tag, and push a custom support tools image using Podman or Docker.

# Define default values for variables if not set.
IMAGE_NAME ?= networkmanager-1.42.2-30.rmroutes
REGISTRY ?= quay.io
USERNAME ?= jclaret
REPO ?= $(REGISTRY)/$(USERNAME)/$(IMAGE_NAME)
TAG ?= 4.14.38

# Detect container tool (Podman or Docker). Error out if neither is available.
TOOL_BIN ?= $(shell which podman 2>/dev/null || which docker 2>/dev/null)
ifeq ($(TOOL_BIN),)
$(error "No container tool found (podman or docker). Please install one and try again.")
endif

# Build the custom support tools image.
.PHONY: build
build:
	@echo "Building the image: $(IMAGE_NAME)"
	$(TOOL_BIN) build -t $(IMAGE_NAME) .

# Tag the custom support tools image.
# make tag TAG=turbostat20230317
.PHONY: tag
tag: build
	@echo "Tagging the image as: $(REPO):$(TAG)"
	$(TOOL_BIN) tag $(IMAGE_NAME) $(REPO):$(TAG)

# Push the custom support tools image to the registry.
# make push TAG=turbostat20230317
.PHONY: push
push: tag
	@echo "Pushing the image to: $(REPO):$(TAG)"
	$(TOOL_BIN) push $(REPO):$(TAG)

# Clean the local image.
.PHONY: clean
clean:
	@echo "Cleaning up local image: $(REPO):$(TAG)"
	$(TOOL_BIN) rmi -f $(IMAGE_NAME) $(REPO):$(TAG) || true

# Display usage if the user runs "make help".
.PHONY: help
help:
	@echo "Usage:"
	@echo "  make build           Build the image"
	@echo "  make tag             Tag the image"
	@echo "  make push            Push the image to the registry"
	@echo "  make clean           Remove the local image"
	@echo "Defaults:"
	@echo "  IMAGE_NAME=$(IMAGE_NAME)"
	@echo "  REGISTRY=$(REGISTRY)"
	@echo "  USERNAME=$(USERNAME)"
	@echo "  TAG=$(TAG)"
