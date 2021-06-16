# arch-config
My personnalized arch configuration. 

## How to setup

### Install Archlinux

Follow the arch installation guide:
[text](https://wiki.archlinux.org/title/Installation_guide)

#### The basics


First, we need that software:
sudo pacman -S sway swaylock nnn 

#### 

sudo pacman -S mpsyt mplayer sl cowsay zsh 

#### The fun bit
sudo pacman -S 


Then, we need the configuration files.
Go into your home directory and then:
git clone git@github.com:creeperdeking/arch-config.git
cd arch-config
git config core.worktree "../../"
git reset --hard origin/master
