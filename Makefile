TAG=21.04

define BUILD_ARGS
	--build-arg NB_UID=$$(id -u $$whoami) \
	--build-arg NB_GID=$$(id -g $$whoami)
endef

build-cpu:
	docker image build ${BUILD_ARGS} \
		--build-arg IMAGE=ubuntu:20.04 \
		-t pyml:${TAG} \
		.

build-gpu:
	docker image build ${BUILD_ARGS} \
		--build-arg USE_GPU=true \
		--build-arg IMAGE=nvidia/cuda:11.1-devel-ubuntu20.04 \
		-t pyml-gpu:${TAG} \
		.

test-gpu:
	@echo Test TensorFlow 
	@docker container run --rm --gpus all pyml-gpu:${TAG} python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'));"
	@echo
	@echo Test PyTorch
	@docker container run --rm --gpus all pyml-gpu:${TAG} python -c "import torch; print(torch.cuda.is_available());"