.PHONY: install

dir=
install:
ifneq ($(dir),)
	cp -a tools $(dir)
	mv $(dir)/gitdiffwrap /usr/local/bin
	mv $(dir)/svndiffwrap /usr/local/bin
else
	@echo "please do 'make dir=your install directory'"
endif

scala:
	mkdir -p ~/.vim/{ftdetect,indent,syntax} && \
	for d in ftdetect indent syntax; \
		do wget --no-check-certificate -O ~/.vim/$$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$$d/scala.vim; \
		done
