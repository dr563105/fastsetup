# fastsetup
This fork is similar to fastai's but adds support to make default shell as zsh and some
additional instructions.

### Setup all the things

Login using `ssh -i <path-to-pem-file> ubuntu@<ip-address>`
#### (Alternative): `ssh -i <path-to-pem-file> ubuntu@<ip-address>`


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

### Step 1:
```
sudo apt update && sudo apt -y install git
git clone https://github.com/dr563105/fastsetup.git
cd fastsetup
sudo ./ubuntu-initial.sh
```

The setup script will create a new user inside the cloud pc. This user is not to be
confused with IAM user created by AWS root user. The EC2 has a general username *ubuntu*
for all instances. 

Wait a couple of minutes for reboot, then ssh back in

Reboot when prompted. 
Then reconnect using ssh, but with an additional -L flag which will allow you to connect to Jupyter Notebook once it's installed:

### Step 2:

`ssh -i <path-to-pem-file> -L localhost:8888:localhost:8888 ubuntu@<ip-address>`

#### (Optional): Change default shell to ZSH with [Oh My ZSH](https://github.com/ohmyzsh/ohmyzsh)
Bash shell users skip to next step.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```
Change default SHELL to ZSH using 
```
sudo chsh $USER -s /bin/zsh

```

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
Then 

```
source ~/.zshrc (or source ~/.bashrc)
conda install mamba -n base 
```

### Step 4: Nvidia drivers
Next, find out which NVIDIA drivers you need: `ubuntu-drivers devices`

…and install them – choose the “recommended” option, plus the -server suffix:

"460" might be a different number, based on `ubuntu-drivers` output above

```
sudo apt-fast install -y nvidia-driver-460-server
sudo modprobe nvidia
nvidia-smi
```
### Step 5: Create conda environment
It is good practice to install the necessary packages for this course in a new conda
environment. Installing everything in the conda `base` environment is not advisable.
```
conda create -n <envname> python=<version>
conda create -n fastbookenv python=3.8
```
### Step 6: 

Now you’re ready to install all needed packages for the fast.ai course:
Make there is enough space to install(`df -h`):

```
mamba install -y fastbook
```
Fastbook is a fastai's python package. To see what it install remove `-y` from the command. 
If there is segmentation fault error, it is probably due to space issue.

#### Note: 
For dry run, use '-d' argument in the mamba install command. 

### Step 7: 
To download the notebooks, run:
```
cd
git clone https://github.com/fastai/fastbook
cd fastbook
jupyter notebook
```

#### (Optional): 
To set up email:

    sudo ./opensmtpd-install.sh

To test email, create a text file `msg` containing a message to send, then send it with:

    cat msg |  mail -r "x@$(hostname -d)" -s 'subject' EMAIL_ADDR

Replace `EMAIL_ADDR` with an address to send to. You can get a useful testing address from [mail-tester](https://www.mail-tester.com/).

### Useful tips:
To prevent AWS(server) PC from timeout issues, it is recommended to login from **tmux**.
