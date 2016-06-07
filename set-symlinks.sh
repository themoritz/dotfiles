cd
ln -s dotfiles/.Xresources .
ln -s dotfiles/.zshrc .
ln -s dotfiles/.profile .
ln -s dotfiles/.vimrc .
ln -s dotfiles/.vim .
ln -s dotfiles/.gitconfig .
ln -s dotfiles/.bashrc .

cd .config
ln -s ../dotfiles/.config/awesome/ .

cd
mkdir -p .emacs.d/personal
cd .emacs.d/personal
ln -s ../../dotfiles/.emacs.d/personal/init.el .
