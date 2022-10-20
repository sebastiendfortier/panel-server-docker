
FROM condaforge/mambaforge as conda

ENV PIP_ROOT_USER_ACTION ignore
ENV DEBIAN_NONINTERACTIVE true
ADD environment.yml /

EXPOSE 5006

SHELL ["/bin/bash", "-c"]

RUN mamba install -y -n base -c conda-forge conda-lock && \
    mamba env create -n env -f /environment.yml

 
#COPY panel.tar.gz /

#RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#    git



#RUN /opt/conda/bin/activate env && \
#    tar zxf panel.tar.gz && \
#    cd /panel && \
#    python -m pip install .

RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-glx && \
    apt-get autoremove && \
    apt-get clean

CMD /opt/conda/bin/activate env && /opt/conda/envs/env/bin/panel serve --allow-websocket-origin='*' /data/*.ipynb

