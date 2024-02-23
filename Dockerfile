FROM nvidia/cuda:12.2.2-devel-ubuntu22.04
ENV TZ=Europe/Amsterdam \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3.10 python2 \
    python3-pip iputils-ping \
    ffmpeg libavcodec-extra \
    epiphany apt-utils \
    build-essential wget \
    git vim \
    postgresql-client libpq-dev \
    alien dpkg-dev debhelper \
    libaio1 libaio-dev \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-tools-19.22.0.0.0-1.x86_64.rpm \
    && wget https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-devel-19.22.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.22-tools-19.22.0.0.0-1.x86_64.rpm \
    && alien -k --scripts oracle-instantclient19.22-devel-19.22.0.0.0-1.x86_64.rpm \
    && dpkg -i oracle-instantclient19.22-basic_19.22.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.22-sqlplus_19.22.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.22-tools_19.22.0.0.0-1_amd64.deb \
    && dpkg -i oracle-instantclient19.22-devel_19.22.0.0.0-1_amd64.deb \
    && rm oracle-instantclient*  -f 
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git \
    && export CMAKE_ARGS="-DLLAMA_CUBLAS=on" \
    && cd llama-cpp-python \
    && make build.cuda \
    && pip install -e .[all] \
    && cd .. \
    && rm -rf llama-cpp-python
RUN pip install torch
RUN pip install streamlit \
    accelerate bitsandbytes \
    doc2text pypdf \
    HuggingFace Prompts \
    docx2txt python-pptx \
    Pillow pydub \
    transformers  \
    psycopg2 asyncpg \ 
    pgvector cx_Oracle \
    peft datasets \
    idna pyautogen \
    markdownify requests \
    autogenstudio
RUN pip install jupyter notebook ipywidgets packaging 
RUN pip install flash-attn --no-build-isolation
RUN git clone --recurse-submodules https://github.com/run-llama/llama_index.git \
    && cd llama_index \
    && pip install -e .[all] \
    &&  cd .. \
    && rm -rf llama_index
RUN pip install llama-index-llms-huggingface llama-index-embeddings-huggingface llama-index-vector-stores-postgres llama-index-core llama-index-llms-openai llama-index-llms-replicate 
RUN pip install git+https://github.com/openai/whisper.git
RUN sed -i 's/view_support: bool = False/view_support: bool = True/g' /usr/local/lib/python3.10/dist-packages/llama_index/core/utilities/sql_wrapper.py
RUN wget https://vscodeserverlauncher.blob.core.windows.net/builds/setup-scripts/setup.sh 
RUN chmod u+x setup.sh \
    && ./setup.sh
COPY entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/entrypoint.sh
USER root 
WORKDIR /root 
EXPOSE 8888                                           
ENTRYPOINT ["entrypoint.sh"]
