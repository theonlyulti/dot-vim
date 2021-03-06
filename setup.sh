#!/usr/bin/env sh

function abs_path() {
	pushd $(dirname $1) > /dev/null
	echo $(PWD)
	popd > /dev/null
}

if ! which -s vim; then
	echo "error: vim not found"
	echo "install vim and try again"
	exit 1
fi

if ! which -s git; then
	echo "error: git not found"
	echo "install git and try again"
	exit 1
fi

if ! which -s cmake; then
	echo "error: cmake not found (needed to compile YouCompleteMe plugin)"
	echo "install cmake and try again"
	exit 1
fi

DOT_VIM_PATH=$(abs_path $0)
if [ $DOT_VIM_PATH != $HOME/.vim ]; then
	ln -s $DOT_VIM_PATH $HOME/.vim
fi

if [ ! -f $HOME/.vimrc ]; then
	echo
	echo "symlinking vimrc to $HOME/.vimrc"
	ln -s $HOME/.vim/vimrc $HOME/.vimrc
fi

pushd $HOME/.vim > /dev/null

echo
echo "fetching vundle..."
git submodule init
git submodule update

echo
echo "installing vundle bundles"
vim +BundleInstall +qall

echo
echo "compiling YouCompleteMe..."
pushd ./bundle/YouCompleteMe > /dev/null
./install.sh --clang-completer
popd > /dev/null

if [ $(uname -s) = "Darwin" ]; then
	echo
	if ! which -s mvim; then
		echo "consider installing MacVim (old vim versions don't support all the plugins):"
		echo "brew install macvim"
		echo
	fi
	echo "consider symlinking vim to mvim (given that $HOME/bin is in your \$PATH):"
	echo "ln -s $(which mvim) $HOME/bin/vim"
fi

popd > /dev/null

