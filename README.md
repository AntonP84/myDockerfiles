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
    -p 8888:8888 -p 6006:6006 -p 8080:8080 \
    -v $(realpath ~):/mnt/data -v $(realpath ~):/notebooks -v /mnt/sda:/hdd \
    --runtime=nvidia \
    --name pyml-gpu \
    pyml-gpu

# to check GPUs
docker exec pyml-gpu python -c "import tensorflow as tf; tf.enable_eager_execution(config=tf.ConfigProto(log_device_placement=True)); print(tf.reduce_mean(tf.random_normal([10000, 10000])))"

# CPU
docker container run -d --rm \
    -e JUPYTER_TOKEN=py37 \
    -p 8888:8888 \
    -v $(realpath ~):/mnt/data -v $(realpath ~):/notebooks -v /mnt/sda:/hdd \
    --name pyml \
    pyml
```

## todo

- errors during image building
- merge two dockerfiles
- use pyTorch for the latest CUDA
