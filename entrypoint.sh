#!/bin/bash

/opt/conda/etc/profile.d/conda.sh
#conda activate env

git config --global credential.helper store

cd /share
jupyter notebook --ip=0.0.0.0 --allow-root --no-browser &

sleep infinity

#jupyter notebook --allow-root --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir=/share
