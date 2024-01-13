FROM nvidia/cuda:12.2.2-devel-ubuntu22.04
ENV TZ=Europe/Amsterdam \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3.10 \
    python3-pip iputils-ping \
    ffmpeg libavcodec-extra \
    epiphany apt-utils \
    build-essential wget \
    git vim \
    postgresql-client libpq-dev \
    alien dpkg-dev debhelper \
    libaio1 libaio-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://download.oracle.com/otn_software/linux/instantclient/1921000/oracle-instantclient19.21-basic-19.21.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1921000/oracle-instantclient19.21-sqlplus-19.21.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1921000/oracle-instantclient19.21-tools-19.21.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1921000/oracle-instantclient19.21-devel-19.21.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.21-basic-19.21.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.21-sqlplus-19.21.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.21-tools-19.21.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.21-devel-19.21.0.0.0-1.x86_64.rpm \
    && dpkg -i oracle-instantclient19.21-basic_19.21.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.21-sqlplus_19.21.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.21-tools_19.21.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.21-devel_19.21.0.0.0-1_amd64.deb
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git \
    && export CMAKE_ARGS="-DLLAMA_CUBLAS=on" \
    && cd llama-cpp-python \
    && make build.cuda \
    && pip install -e .[all]
RUN pip install torch
RUN git clone --recurse-submodules https://github.com/run-llama/llama_index.git \
    && cd llama_index \
    && sed -i 's/view_support: bool = False/view_support: bool = True/g' llama_index/utilities/sql_wrapper.py \
    && pip install -e .[all]
RUN pip install streamlit \
    accelerate bitsandbytes \
    doc2text pypdf \
    HuggingFace Prompts \
    docx2txt python-pptx \
    Pillow pydub \
    transformers  \
    psycopg2 asyncpg \ 
    pgvector cx_Oracle \
    causal-conv1d mamba-ssm
RUN pip install jupyter notebook ipywidgets 
RUN pip install flash-attn --no-build-isolation
COPY entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/entrypoint.sh
USER root 
WORKDIR /root 
EXPOSE 8888                                           
ENTRYPOINT ["entrypoint.sh"]
