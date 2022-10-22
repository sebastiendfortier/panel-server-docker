
FROM condaforge/mambaforge as conda

ENV PIP_ROOT_USER_ACTION ignore
ENV DEBIAN_NONINTERACTIVE true
ADD environment.yml /

EXPOSE 5006

SHELL ["/bin/bash", "-c"]

RUN mamba install -y -n base -c conda-forge conda-lock conda-pack && \
    mamba env create -n env -f /environment.yml && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl sudo libgl1-mesa-glx && \
    mkdir /node && \
    cd node && \
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get install -y nodejs
 
COPY panel.tar.gz /
COPY requirements.txt /

RUN mkdir /panel && \
    tar zxf /panel.tar.gz -C /panel && \
    source /opt/conda/bin/activate env && \
    python -m pip install --upgrade pip && \
    python -m pip install /panel/panel/. && \
    python -m pip install -r /requirements.txt && \
    conda deactivate && \
    conda-pack -n env
    
     
FROM ubuntu:20.04

COPY --from=conda env.tar.gz /env.tar.gz

SHELL ["/bin/bash", "-c"]

RUN mkdir /env && \
    tar zxf env.tar.gz -C /env && \
    rm -rf env.tar.gz && \
    source /env/bin/activate && \
    conda-unpack 
    
CMD source /env/bin/activate && panel serve --unused-session-lifetime 60000 --allow-websocket-origin='*' /data/*.ipynb

