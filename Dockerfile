ARG IMAGE
FROM ${IMAGE}

ARG USE_GPU=false
ARG NB_USER=user
ARG NB_UID=1234
ARG NB_GID=123

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

COPY requirements.txt .
RUN pip install --no-cache-dir -qU -r requirements.txt && \
	python -m nltk.downloader punkt

RUN if ${USE_GPU}; then \
		# pip install --no-cache-dir -qU tensorflow-gpu==2.3.1 && \  # waiting for CUDA 11 support
		pip install --no-cache-dir -qU tensorflow-cpu==2.3.1 && \
		pip install --no-cache-dir -qU torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio===0.7.0 -f https://download.pytorch.org/whl/torch_stable.html; \
	else \
		pip install --no-cache-dir -qU tensorflow-cpu==2.3.1 && \
		pip install --no-cache-dir -qU torch==1.7.0+cpu torchvision==0.8.1+cpu torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html; \
	fi
	
# enable Jupyter extensions
ENV JUPYTER_TOKEN=123
COPY setup-nbextensions.sh .
RUN chmod +x setup-nbextensions.sh && \
	./setup-nbextensions.sh
        
RUN chown -hR ${NB_UID}:${NB_GID} ${HOME}

USER ${NB_UID}:${NB_GID}
WORKDIR ${HOME}

# Jupyter, TensorBoard, NNI
EXPOSE 8888 6006 8080

VOLUME /data
VOLUME /notebooks
VOLUME /hdd

# create jupyter notebook
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--notebook-dir=/notebooks"]