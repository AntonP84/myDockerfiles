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
    -e JUPYTER_TOKEN=py37 \
    -p 8888:8888 \
    --mount type=bind,source=$(realpath ~),target=/mnt/data \
    --mount type=bind,source=/mnt/sda,target=/hdd \
    --mount type=bind,source=$(realpath ~),target=/notebooks \
    --runtime=nvidia \
    --name pyml-gpu \
    pyml-gpu

# to check GPUs
docker exec pyml-gpu python -c "import tensorflow as tf; print(tf.config.experimental.list_physical_devices('GPU'));"

# CPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=py37 \
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
