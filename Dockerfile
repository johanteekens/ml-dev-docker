FROM nvidia/cuda:12.2.2-devel-ubuntu22.04
ENV TZ=Europe/Amsterdam \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3.10 \
    python3-pip iputils-ping \
    ffmpeg libavcodec-extra \
    epiphany \
    build-essential wget \
    git vim \
    postgresql-client libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git \
    && export CMAKE_ARGS="-DLLAMA_CUBLAS=on" \
    && cd llama-cpp-python \
    && make build.cuda \
    && pip install -e .[all]
RUN pip install torch 
RUN pip install flash-attn --no-build-isolation
RUN pip install causal-conv1d
RUN pip install pip install mamba-ssm
RUN pip install jupyter notebook ipywidgets 
RUN pip install streamlit \
    llama-index \
    accelerate bitsandbytes \
    doc2text pypdf \
    HuggingFace Prompts \
    docx2txt python-pptx \
    Pillow pydub \
    transformers  \
    psycopg2 asyncpg \ 
    pgvector
COPY entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/entrypoint.sh
USER root 
WORKDIR /root 
EXPOSE 8888                                           
ENTRYPOINT ["entrypoint.sh"]
