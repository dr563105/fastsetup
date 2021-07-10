set -eou pipefail

cd

case "$OSTYPE" in
  darwin*)  DOWNLOAD=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh; ;;
  #linux*)   DOWNLOAD=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh; ;;
  #linux*)   DOWNLOAD=https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh; ;;
  linux*)   DOWNLOAD=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh; ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

case "$SHELL" in
  /bin/zsh*)   SHELL_NAME=zsh; ;;
  /bin/bash*)  SHELL_NAME=bash ;;
  /usr/local/bin/fish*) SHELL_NAME=fish ;;
  *)        echo "unknown: $SHELL" ;;
esac

cat << EOF > .condarc
channels:
  - fastai
  - fastchan
  - defaults
channel_priority: strict
EOF

wget -q $DOWNLOAD
#bash Miniconda3*.sh -b
#~/miniconda3/bin/conda init $SHELL_NAME
#rm Miniconda3*.sh
bash Miniforge3*.sh* -b
~/miniforge3/bin/conda init $SHELL_NAME
rm Miniforge3*.sh*

cd -