# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set vim as default editor
export EDITOR=vim

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# nix (added by Nix installer)
if [ -e /home/moritz/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/moritz/.nix-profile/etc/profile.d/nix.sh
fi 

# NVM
export NVM_DIR="/home/moritz/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Node prefix
export PATH="$PATH:$HOME/.npm/bin"
