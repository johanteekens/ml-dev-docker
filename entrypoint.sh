#!/bin/bash


git config --global credential.helper store

cd /share
jupyter notebook --ip=0.0.0.0 --allow-root --no-browser &

sleep infinity

