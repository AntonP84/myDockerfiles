FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ARG NB_USER=user
ARG NB_UID=1234
ARG NB_GID=123

ENV TERM=xterm \
	DEBIAN_FRONTEND=noninteractive \
	PROMPT_DIRTRIM=2 \
	HOME=/home/${NB_USER} \
	PATH=$PATH:/home/${NB_USER}/.local/bin

USER root
WORKDIR /home/root

COPY setup-environment.sh .
RUN chmod +x setup-environment.sh && \
	./setup-environment.sh

ENV PYTHON_VERSION=3.7.3 \
	PYTHONDONTWRITEBYTECODE=True \
	PYTHONIOENCODING=utf-8
COPY setup-python.sh .
RUN chmod +x setup-python.sh && \
	./setup-python.sh

COPY requirements.txt .
RUN pip install -qU -r requirements.txt && \
	pip install -qU tensorflow-gpu==1.13.1 && \
	pip install -qU https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp37-cp37m-linux_x86_64.whl && \
	python -m nltk.downloader punkt

COPY kaggle.json ${HOME}/.kaggle/
RUN chmod 600 ${HOME}/.kaggle/kaggle.json && \
	chown ${NB_UID}:${NB_GID} ${HOME}/.kaggle/kaggle.json
	
# enable Jupyter extensions
ENV JUPYTER_TOKEN=py37
COPY snippets.json ${HOME}/.local/share/jupyter/nbextensions/snippets/
COPY setup-nbextensions.sh .
RUN chmod +x setup-nbextensions.sh && \
	./setup-nbextensions.sh
        
RUN chown -hR ${NB_UID}:${NB_GID} ${HOME}

USER ${NB_UID}:${NB_GID}
WORKDIR ${HOME}

# Jupyter, TensorBoard, NNI
EXPOSE 8888 6006 8080

VOLUME /mnt/data
VOLUME /notebooks
VOLUME /hdd

# create jupyter notebook
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--allow-root", "--ip=0.0.0.0", "--notebook-dir=/notebooks"]