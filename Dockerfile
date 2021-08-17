ARG DEVICE
FROM ubuntu:20.04 AS base-cpu
FROM nvidia/cuda:11.4.1-cudnn8-devel-ubuntu20.04 AS base-gpu
FROM base-${DEVICE} AS base

ARG DEVICE
ARG NB_USER=user
ARG NB_UID=1000
ARG NB_GID=1000

ENV TERM=xterm \
	DEBIAN_FRONTEND=noninteractive \
	PROMPT_DIRTRIM=2 \
	HOME=/home/${NB_USER} \
	PATH=$PATH:/home/${NB_USER}/.local/bin \
	PYTHONDONTWRITEBYTECODE=True \
	PYTHONIOENCODING=utf-8

USER root
WORKDIR /home/root

COPY setup-environment.sh .
RUN chmod +x setup-environment.sh && \
	./setup-environment.sh

USER ${NB_UID}:${NB_GID}
WORKDIR ${HOME}

RUN if [ "${DEVICE}" = "gpu" ]; then \
		pip install --no-cache-dir -qU tensorflow==2.6.0 && \
		pip install --no-cache-dir -qU torch==1.9.0+cu111 torchvision==0.10.0+cu111 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html; \
	else \
		pip install --no-cache-dir -qU tensorflow-cpu==2.6.0 && \
		pip install --no-cache-dir -qU torch==1.9.0+cpu torchvision==0.10.0+cpu torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html; \
	fi

COPY --chown=${NB_UID}:${NB_GID} requirements.txt .
RUN pip install --no-cache-dir -qU -r requirements.txt

# enable Jupyter extensions
ENV JUPYTER_TOKEN=123
COPY --chown=${NB_UID}:${NB_GID} setup-nbextensions.sh .
RUN chmod +x setup-nbextensions.sh && \
	./setup-nbextensions.sh

# Jupyter, TensorBoard, NNI, MLFlow
EXPOSE 8888 6006 8080 5000

VOLUME /data
VOLUME /notebooks
VOLUME /hdd

# create jupyter notebook
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--notebook-dir=/notebooks"]