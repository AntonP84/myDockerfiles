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
		pip install --no-cache-dir -qU tensorflow-gpu==2.1.0 && \
		pip install --no-cache-dir -qU torch==1.4.0 torchvision==0.5.0; \
	else \
		pip install --no-cache-dir -qU tensorflow-cpu==2.1.0 && \
		pip install --no-cache-dir -qU torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html; \
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