ARG IMAGE
FROM ${IMAGE}

ARG USE_GPU=false
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

RUN if ${USE_GPU}; then \
		pip install --no-cache-dir -qU tensorflow==2.4.1 && \
		pip install --no-cache-dir -qU torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html; \
	else \
		pip install --no-cache-dir -qU tensorflow-cpu==2.4.1 && \
		pip install --no-cache-dir -qU torch==1.8.1+cpu torchvision==0.9.1+cpu torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html; \
	fi

COPY requirements.txt .
RUN pip install --no-cache-dir -qU -r requirements.txt && \
	python -c "import nltk;nltk.download('punkt')"

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