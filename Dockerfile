FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04
ENV TZ=Europe/Amsterdam \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3.10 \
    python3-pip iputils-ping \
    ffmpeg libavcodec-extra \
    epiphany jupyter-notebook \
    build-essential wget \
    git vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN pip install streamlit \
    llama-index ipywidgets \
    accelerate bitsandbytes \
    doc2text pypdf \
    HuggingFace Prompts \
    docx2txt python-pptx \
    Pillow pydub           


COPY entrypoint.sh /usr/local/bin
RUN chmod 777 /usr/local/bin/entrypoint.sh
USER root 
WORKDIR /root 
EXPOSE 8888                                           
ENTRYPOINT ["entrypoint.sh"]
