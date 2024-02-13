#!/bin/bash


git config --global credential.helper store
alias python=python3

#cd /share
#jupyter notebook --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.token='c444657f63b56d7b2c5fde71bb946b6d51902762cd9cd46e' &

# If prestart folder exists, run prestart scripts
DIR="/share/scripts"
if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Running prestart scripts"
  cd $DIR
  for f in *.sh; do
    bash "$f"
  done
fi


#cd /share/text-generation-webui
#./start_linux.sh --api --listen --trust-remote-code --model=mixtral-8x7b-instruct-v0.1.Q5_K_M.gguf &

sleep infinity

