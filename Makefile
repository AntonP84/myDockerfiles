TAG=21.08

define BUILD_ARGS
	--build-arg NB_UID=$$(id -u $$whoami) \
	--build-arg NB_GID=$$(id -g $$whoami)
endef

build-cpu:
	docker image build ${BUILD_ARGS} \
		--build-arg DEVICE=cpu \
		-t pyml:${TAG} \
		.

build-gpu:
	docker image build ${BUILD_ARGS} \
		--build-arg DEVICE=gpu \
		-t pyml-gpu:${TAG} \
		.

test-gpu:
	@echo Test TensorFlow 
	@docker container run --rm --gpus all pyml-gpu:${TAG} python -c "import tensorflow as tf; print('# GPUs:', len(tf.config.list_physical_devices('GPU')));"
	@echo
	@echo Test PyTorch
	@docker container run --rm --gpus all pyml-gpu:${TAG} python -c "import torch; print('GPU is available:', torch.cuda.is_available());"