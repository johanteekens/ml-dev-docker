# This is my machine learning development docker container.

I use this container and compose file for llama / AI development. /root/.cache is shared as well so all containers can share the same models. It includes everything for my daily use. llama-cpp-python is compiled from source because it would not work any oher way.

```
Based on: 
  nvidia/cuda:12.2.2-devel-ubuntu22.04
Ubuntu Packages: 
  python3.10 
  python3-pip 
  iputils-ping 
  ffmpeg 
  libavcodec-extra 
  epiphany 
  build-essential 
  git 
  vim 
  postgresql-client 
  libpq-dev 
PIP Packages
  llama-cpp-python (compiled and installed from source/git)
  jupyter notebook and ipywidgets
  streamlit
  llama-index 
  accelerate 
  bitsandbytes 
  doc2text 
  pypdf 
  HuggingFace 
  Prompts 
  docx2txt 
  python-pptx 
  Pillow 
  pydub 
  transformers  
  psycopg2 
  asyncpg 
  pgvector
```
