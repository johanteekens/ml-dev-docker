FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04
RUN apt-get update && \
    apt-get install -y python3.10 \
    python3-pip iputils-ping \
    build-essential wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
            
RUN pip3 install JPype1 jupyter pandas numpy seaborn scipy matplotlib pyNetLogo SALib 


# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH



RUN useradd -ms /bin/bash jupyter
USER jupyter
WORKDIR home/jupyter 
EXPOSE 8888                                           
ENTRYPOINT ["jupyter", "notebook","--allow-root","--ip=0.0.0.0","--port=8888","--no-browser","--notebook-dir=/share"]
