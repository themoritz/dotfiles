cd
ln -s dotfiles/.Xresources .
ln -s dotfiles/.zshrc .
ln -s dotfiles/.profile .
# ln -s dotfiles/.vimrc .
# ln -s dotfiles/.vim .
ln -s dotfiles/.gitconfig .
ln -s dotfiles/.bashrc .
ln -s dotfiles/.i3status .

cd .config
# ln -s ../dotfiles/.config/awesome/ .
ln -s ../dotfiles/.config/i3/ .

cd
mkdir -p .emacs.d/personal
cd .emacs.d/personal
ln -s ../../dotfiles/.emacs.d/personal/init.el .
