# fastsetup
This fork is similar to fastai's but adds support to make default shell as zsh and some
additional instructions.

## Important update(as of Sep 2, 2021):
Due to current dependency conflicts with mamba, fastbook, and fastchan(a fastai conda channel), it is tedious
to install fastbook with CUDA enabled pytorch and other dependent packages with a simple command.
Changes in execution are seen in step 3, 5, and 6. Also added sanity checks for verifying if cuda installed is working.

Click **[TLDR](https://github.com/dr563105/blob/main/tldr.md)** to get the TLDR version
of this readme.

### Setup all the things

Login using `ssh -i <path-to-pem-file> ubuntu@<ip-address>` (ubuntu for ubuntu EC2
instance, ec2-user for amazon AMI, and so on). We will be using ubuntu ec2 g4dn instance.

#### (Alternative):

`ssh ubuntu@<ip-address>`


In some cases if the host terminal is using a different XTERM environment such as `xterm-kitty`(echo $TERM), that environment is reflected
in the remote EC2 instance. If that is the case, it best to use this command:

`TERM='xterm-256color' ssh -i <path-to-pem-file> ubuntu@<ip-address>`

Also a possibility would be to add the TERM env to bashrc file.

```
echo 'export TERM=xterm-256color' >> ~/.bashrc
source ~/.bashrc
```

Why the need to do to set the TERM env? Because, remote host will have the basic env set
and the keystrokes such as previously run command(up arrow) would return scrambled output
on the screen.

First, do basic ubuntu configuration, such as updating packages, and turning on auto-updates:

### Step 1: Ubuntu env setup:
```
sudo apt update && sudo apt -y install git
git clone https://github.com/dr563105/fastsetup.git
cd fastsetup
sudo ./ubuntu-initial.sh
```

The setup script will create a new user inside the cloud pc. This user is not to be
confused with IAM user created by AWS root user.

Reboot when prompted. Wait a couple of minutes for reboot, then ssh back in

Then reconnect using ssh, but with an additional -L flag which will allow you to connect to Jupyter Notebook once it's installed:

### Step 2: Opening ports for jupyter notebook:

`ssh -i <path-to-pem-file> -L localhost:8888:localhost:8888 ubuntu@<ip-address>`

#### (Optional): Change default shell to ZSH with [Oh My ZSH](https://github.com/ohmyzsh/ohmyzsh)
Bash shell users skip to next step.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```
Change default SHELL to ZSH using `sudo chsh $USER -s /bin/zsh`

When prompted for password, use the password for the user created during the setup
process.

Logout and login again to activate ZSH shell. It is possible to switch without
disconnecting but I find this step simpler to other solutions.

### Step 3: Set up conda:
Installs miniconda3 which is mini version of anaconda

```
cd fastsetup
./setup-conda.sh
```

#### Note:
Deviates from fastai's fastsetup `setup-conda.sh`script in creating a `.condarc` file. My
experiments have shown this file to be troublesome.

Then,

```
source ~/.zshrc (or source ~/.bashrc)
conda install mamba -n base -c fastchan
```
(`-c fastchan` is needed here as we have removed `.condarc` file)

Also don't mix `conda-forge` with `fastai` channels. Stick to either `fastchan` or
`conda-forge`.

### Step 4: Nvidia drivers
Next, find out which NVIDIA drivers you need: `ubuntu-drivers devices`

…and install them – choose the “recommended” option, plus the -server suffix:

"460" might be a different number, based on `ubuntu-drivers` output above

```
sudo apt-fast install -y nvidia-driver-470-server
sudo modprobe nvidia
nvidia-smi
```

#### Note:

The command installs `cuda 11.4`. This is not to be confused with `cudatoolkit=11.1` which
is needed for `pytorch=1.9`. Also each pytorch conda install comes with its own `cuDNN`
runtime. So installing `cuDNN` separately is not needed. `cuda 11.4` comes to play if
pytorch is built from source.

### Step 5: Create conda environment
It is good practice to install the necessary packages for this course in a new conda
environment. Installing everything in the conda `base` environment is not advisable.
```
conda create -n <envname> -y
conda create -n fastbookenv -y
conda activate fastbookenv
```

### Step 6: Install fastbook with all its dependencies including CUDA enabled pytorch libraries

Now you’re ready to install all needed packages for the fast.ai course:
Make there is enough space to install(`df -h`):

```
mamba install fastbook python=3.8 -c fastai -c fastchan -y
conda install pytorch torchaudio torchvision python=3.8 cudatoolkit=11.1 -c fastchan -y
```
Fastbook is a fastai's python package. To see what it install remove `-y` from the command.
If there is segmentation fault error, it is probably due to space issue.

#### Tip:
For dry run, use '-d' argument in the mamba install command.

### Step 7: Sanity checks:
These checks are to verifying if indeed CUDA enabled pytorch is installed correctly. Enter
these commands inside a python shell.
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
If the commands return the same results, then we're ready to use fastai.

### Step 8: Run jupyter notebook
To download the notebooks, run:
```
cd
git clone https://github.com/fastai/fastbook
cd fastbook
jupyter notebook
```
Click on the localhost url that is displayed. It will open iPython notebook in your
default browser. Alternatively, that link can be copied and opened in any browser of
choice.

#### (Optional):
To set up email:

    sudo ./opensmtpd-install.sh

To test email, create a text file `msg` containing a message to send, then send it with:

    cat msg |  mail -r "x@$(hostname -d)" -s 'subject' EMAIL_ADDR

Replace `EMAIL_ADDR` with an address to send to. You can get a useful testing address from [mail-tester](https://www.mail-tester.com/).

### Useful tip:
To prevent AWS(server) PC from timeout issues, it is recommended to login from a **tmux**
session.

