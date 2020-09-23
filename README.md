# ML with Python

## Building

```bash
# GPU
make build-gpu
make test-gpu

# CPU
make build-cpu
```

## Running

```bash
# GPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=my_token \
    -p 8888:8888 \
    --mount type=bind,source=$(realpath ~),target=/data \
    --mount type=bind,source=/mnt/sda,target=/hdd \
    --mount type=bind,source=$(realpath ~),target=/notebooks \
    --gpus all \
    --name pyml-gpu \
    pyml-gpu:20.09

# CPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=my_token \
    -p 8888:8888 \
    --mount type=bind,source=$(realpath ~),target=/data \
    --mount type=bind,source=/mnt/sda,target=/hdd \
    --mount type=bind,source=$(realpath ~),target=/notebooks \
    --name pyml \
    pyml:20.09
```

## todo

- errors during image building
