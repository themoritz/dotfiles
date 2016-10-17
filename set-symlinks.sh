cd
ln -s dotfiles/.Xresources .
ln -s dotfiles/.zshrc .
ln -s dotfiles/.profile .
ln -s dotfiles/.gitconfig .
ln -s dotfiles/.bashrc .

cd .config
ln -s ../dotfiles/.config/i3/ .
ln -s ../dotfiles/.config/i3status/ .

cd
mkdir -p .emacs.d/personal
cd .emacs.d/personal
ln -s ../../dotfiles/.emacs.d/personal/init.el .
