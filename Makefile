all:
	cp -r tools/. ~/ && \
	vim +PlugInstall +qall #&& \
	#cd ~/.vim/plugged/YouCompleteMe/ && git submodule update --init --recursive && ./install.py
