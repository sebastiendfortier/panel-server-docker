
FROM condaforge/mambaforge as conda

ENV PIP_ROOT_USER_ACTION ignore

ADD environment.yml /

EXPOSE 5006

SHELL ["/bin/bash", "-c"]

RUN mamba install -y -n base -c conda-forge conda-lock && \
    mamba env create -f /environment.yml && \
#    mamba install -n env /conda-lock.yml && \
#    mamba clean -afy && \
#    pip cache remove "*" 

#RUN find /root/.conda/envs/env -name '*.a' -delete
#RUN rm -rf /root/.conda/envs/env/conda-meta
#RUN rm -rf /root/.conda/envs/env/include
#RUN find /opt/conda/envs/env -name '__pycache__' -type d -exec rm -rf '{}' '+' 
#RUN find /opt/conda/envs/env/lib/python3.10/site-packages -name 'tests' -type d -exec rm -rf '{}' '+'
#RUN find /opt/conda/envs/env/lib/python3.10/site-packages -name '*.pyx' -delete 

COPY panel-0.14.1rc1.tar.gz /

RUN mkdir /panel && tar zxf panel-0.14.1rc1.tar.gz --directory /panel

RUN /opt/conda/bin/activate env 

RUN python -m pip install /panel/.

RUN conda pack -n env

RUN mkdir /env

RUN tar zxf env.tar.gz --directory /env

FROM ubuntu:18.04

COPY --from=conda /root/.conda/envs./env /env


RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-glx && \
    apt-get autoremove && \
    apt-get clean

CMD PATH=$PATH:/env/bin /env/bin/panel serve /data/*.ipynb

