cd
ln -s dotfiles/.Xresources .
ln -s dotfiles/.xinitrc .
ln -s dotfiles/.zshrc .
ln -s dotfiles/.profile .
ln -s dotfiles/.gitconfig .
ln -s dotfiles/.bashrc .

mkdir -p ~/.config
cd ~/.config
ln -s ../dotfiles/.config/i3/ .
ln -s ../dotfiles/.config/i3status/ .

mkdir -p ~/.stack
cd ~/.stack
ln -s ../dotfiles/.stack/config.yaml .

cd
mkdir -p ~/.emacs.d/personal
cd ~/.emacs.d/personal
ln -s ../../dotfiles/.emacs.d/personal/init.el .
