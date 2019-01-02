cd
ln -s dotfiles/.Xresources .
ln -s dotfiles/.zshrc .
ln -s dotfiles/.profile .
ln -s dotfiles/.npmrc .
ln -s dotfiles/.gitconfig .
ln -s dotfiles/.emacs .

mkdir -p ~/.emacs.d
cd ~/.emacs.d
ln -s ../dotfiles/.emacs.d/init.org .

mkdir -p ~/.config
cd ~/.config
ln -s ../dotfiles/.config/i3/ .
ln -s ../dotfiles/.config/i3status/ .

mkdir -p ~/.stack
cd ~/.stack
ln -s ../dotfiles/.stack/config.yaml .
