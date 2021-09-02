Login -
`ssh -i <path-to-pem-file> ubuntu@<ip-address>`

```
sudo apt update && sudo apt -y install git
git clone https://github.com/dr563105/fastsetup.git
cd fastsetup
sudo ./ubuntu-initial.sh
```

Reboot and login back -
`ssh -i <path-to-pem-file> -L localhost:8888:localhost:8888 ubuntu@<ip-address>`

```
cd fastsetup
./setup-conda.sh
source ~/.zshrc (or source ~/.bashrc)
conda install mamba -n base -c fastchan

ubuntu-drivers devices
sudo apt-fast install -y nvidia-driver-470-server
sudo modprobe nvidia
nvidia-smi

conda create -n <envname> -y
conda create -n fastbookenv -y
conda activate fastbookenv

mamba install fastbook python=3.8 -c fastai -c fastchan -y
conda install pytorch torchaudio torchvision python=3.8 cudatoolkit=11.1 -c fastchan -y
```

Sanity checks -
```
$which python
/home/ubuntu/miniconda3/envs/fastbookenv/bin/python
$python --version
Python 3.8.5
$python
>>>import torch
>>>torch.version.cuda
'11.1'
>>>torch.cuda.is_available()
True
>>> torch.cuda.device_count()
1
>>>torch.cuda.current_device()
0
>>>torch.cuda.get_device_name(0)
'Tesla T4'
```

Download notebook and run -
```
cd
git clone https://github.com/fastai/fastbook
cd fastbook
jupyter notebook
```
