
FROM condaforge/mambaforge as conda

ENV PIP_ROOT_USER_ACTION ignore
ENV DEBIAN_NONINTERACTIVE true
ADD environment.yml /

EXPOSE 5006

SHELL ["/bin/bash", "-c"]

RUN mamba install -y -n base -c conda-forge conda-lock && \
    mamba env create -n env -f /environment.yml

 
#COPY panel-0.14.1rc1.tar.gz /

#RUN apt-get update && \
#    apt-get install -y --no-install-recommends \
#    sudo \
#    curl

#RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&\
#    apt-get install -y nodejs

#RUN tar zxf panel-0.14.1rc1.tar.gz

#RUN /opt/conda/bin/activate env 

#RUN cd /panel-0.14.1rc1 && python -m pip install .

RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-glx && \
    apt-get autoremove && \
    apt-get clean

#CMD tail -F /dev/null
CMD /opt/conda/bin/activate env && /opt/conda/envs/env/bin/panel serve /data/*.ipynb

