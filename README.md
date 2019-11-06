# ML with Python

## Building

```bash
# GPU
docker image build \
    --build-arg NB_UID=$(id -u $whoami) \
    --build-arg NB_GID=$(id -g $whoami) \
    -t pyml-gpu \
    -f pyml-gpu.dockerfile \
    .

# CPU
docker image build \
    --build-arg NB_UID=$(id -u $whoami) \
    --build-arg NB_GID=$(id -g $whoami) \
    -t pyml \
    -f pyml.dockerfile \
    .
```

## Running

```bash
# GPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=my_token \
    -p 8888:8888 \
    --mount type=bind,source=$(realpath ~),target=/mnt/data \
    --mount type=bind,source=/mnt/sda,target=/hdd \
    --mount type=bind,source=$(realpath ~),target=/notebooks \
    --gpus all \
    --name pyml-gpu \
    pyml-gpu

# to check GPUs
docker container run --rm --gpus all pyml-gpu python -c "import tensorflow as tf; print(tf.test.is_gpu_available(cuda_only=True));"

docker container run --rm --gpus all pyml-gpu python -c "import torch; print(torch.cuda.is_available());"

# CPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=my_token \
    -p 8888:8888 \
    --mount type=bind,source=$(realpath ~),target=/mnt/data \
    --mount type=bind,source=/mnt/sda,target=/hdd \
    --mount type=bind,source=$(realpath ~),target=/notebooks \
    --name pyml \
    pyml
```

## todo

- errors during image building
- merge two dockerfiles
