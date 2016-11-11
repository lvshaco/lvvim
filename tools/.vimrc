"----------------------------------------------------------------------------------
"author: lv
"-----------------------------------------------------------------------------------
set path+=**
filetype plugin indent on "文件类型检测
syntax on "使用vim缺省的语法高亮
set nocompatible "不要支持vi模式
set number "显示行号
set relativenumber
"set nowrap "显示不下的长行不会回绕
set wrap
set showmatch "插入括号时，短暂地跳转到匹配的对应括号
set incsearch "输入搜索时显示目前输入的模式的匹配位置。匹配的字符串被高亮
set hlsearch "输入搜索时高亮所有匹配
set nobackup "不自动备份
set backspace=indent,eol,start
set termencoding=utf8
set encoding=utf8
set fileencoding=utf8
set fileencodings=utf-8,gbk,gb2312,big5

set cindent
set autoindent
set smartindent
set shiftwidth=4 "缩进的空格数

set tabstop=4 "制表符的宽度
set softtabstop=4 "软制表符的宽度（制表符和空格结合）
set expandtab "用空格代替制表符（用其它编辑器查看就可以统一）

"set clipboard+=unnamed
"set t_Co=256
set bg=dark
"colorscheme termcolor

autocmd FileType javascript,html,css,xml,yml set ai
autocmd FileType javascript,html,css,xml,yml set sw=2 
autocmd FileType javascript,html,css,xml,yml set ts=2
autocmd FileType javascript,html,css,xml,yml set sts=2

"if has("autocmd")
"    inoremap {  {}<LEFT>
"    inoremap [  []<LEFT>
"    inoremap "  ""<LEFT>
"    inoremap '  ''<LEFT>
"endif

if !exists(':W')
  command! W w
endif
if !exists(':Q')
  command! Q q
endif

"nnoremap <C-A> ^
"vnoremap <C-A> ^
"inoremap <C-A> <ESC>^i
"nnoremap <C-E> $
"vnoremap <C-E> $
"inoremap <C-E> <ESC>$a
"inoremap <C-B> <ESC><C-B>i
"inoremap <C-F> <ESC><C-F>i
"nnoremap <C-K> d$
"inoremap <C-K> <ESC>ld$a

let g:mapleader=","

"vimrc
nmap <leader>vs :source $HOME/.vimrc<CR>
nmap <leader>ve :e $HOME/.vimrc<CR>

"replace
function! CompleteReplace()
    let w = "\\<" . expand("<cword>") . "\\>"
    echo "replaced word:" . w

    let rword = input("replace to word: ")
    if strlen(rword) == 0
        return
    endif
    echo "replace to word:" . rword

    execute "args " "*/*.cpp */*.h */*.c */*.cexport"
    "use silent will not give normal message
    "use silent! error message also
    execute "silent argdo %s/". w . "/" . rword . "/eg |update"
    echo "replace done!"
endfunction
noremap <F8> :call CompleteReplace()<CR>

function! CompleteReplace2()
    let w = input("word: ")
    if strlen(w) == 0
        return
    endif
    echo "word:" . w

    let rword = input("replace to word: ")
    if strlen(rword) == 0
        return
    endif
    echo "replace to word:" . rword

    execute "args " "*/*.cpp */*.h */*.c */*.cexport"
    "use silent will not give normal message
    "use silent! error message also
    execute "silent argdo %s/". w . "/" . rword . "/eg |update"
    echo "replace done!"
endfunction
noremap <F7> :call CompleteReplace2()<CR>

"grep
function! CompleteGrep()
    let w = "\\<" . expand("<cword>") . "\\>"
    execute "vimgrep /" . w . "/gj **/*.py **/*.c **/*.h **/*.lua **/*.proto **/*.js"
    execute "cw"
endfunction
nmap <silent><F3> :call CompleteGrep()<CR><CR><CR>
imap <silent><F3> <ESC><F3>

"auto complete
set completeopt=longest,menu
"set omnifunc=syntaxcomplete#Complete

"fold
set foldmethod=indent "syntax很卡
set foldlevel=100  "初始不fold

function! QfMakePost()
    execute "cw"
endfunction
if !exists("autocommands_loaded")
    let autocommands_loaded=1
    au QuickfixCmdPost make call QfMakePost()
endif

if has("cscope")
	set csto=1
	set cscopequickfix=c-,d-,e-,g-,i-,s-,t-
	set cst
	nmap <silent><leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>ss <ESC><leader>ss
	nmap <silent><leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>sg <ESC><leader>sg
	nmap <silent><leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>sc <ESC><leader>sc
	nmap <silent><leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>st <ESC><leader>st
	nmap <silent><leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>se <ESC><leader>se
	nmap <silent><leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
	imap <silent><leader>sf <ESC><leader>sf
	nmap <silent><leader>si :cs find i <C-R>=expand("<cfile>")<CR>$<CR>:copen<CR>
	imap <silent><leader>si <ESC><leader>si
	nmap <silent><leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
	imap <silent><leader>sd <ESC><leader>sd
endif

"tags
function! s:generate_ctags(path, force)
    let path_len = strlen(a:path)
    if path_len == 0
        return
    endif
    if (strpart(a:path, path_len-1) == "/")
        let a:path = strpart(a:path, 0, path_len-1)
    endif
    let cur_dir = getcwd()
    silent! execute "cd " . a:path
    
    let cscope_cmd ="!cscope -bq -i "
    let tags_file = a:path . "/.tags"
    let cscope_file = a:path . "/.cscope.files"
    let cscope_out = a:path . "/.cscope.out"
  
    if (executable("ctags"))
        if !filereadable(tags_file) || a:force==1
            echo "building " . cscope_file . " ... "
            silent! execute "!find " . a:path . " -name '*.h' -o -name '*.hpp' -o -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.lua' > " . cscope_file
            echo "building " . tags_file . " ... "
            silent! execute '!ctags -R -h ".c.cc.cpp.h.hpp.lua" --c++-kinds=+p --fields=+ialS --extra=+q -L ' . cscope_file . ' -o ' . tags_file
        endif
        execute "set tags+=" . tags_file
    endif
    if (executable("cscope") && has("cscope"))
        if !filereadable(cscope_out) || a:force==1
            echo "building " . cscope_out  . " ... "
            silent! execute cscope_cmd . cscope_file . " -f " . cscope_out
        endif
        execute "cs add " . cscope_out
    endif
    execute "cd " . cur_dir
endfunction
function! AddTags()
    let path = input("add the path for tags: ", "", "file")
    let path_len = strlen(path)
    if path_len == -1
        return
    endif
    if (strpart(path, path_len-1) == '/')
        let path = strpart(path, 0, path_len-1)
    endif
    call s:generate_ctags(path, 1)
endfunction
function! OpenTags()
    call s:generate_ctags(".",0)
endfunction
nmap <silent><leader>o :call OpenTags()<CR>
nmap <silent><leader>a :call AddTags()<CR>

" complete.vim
if exists('did_completes_me_loaded') || v:version < 700
  finish
endif
let did_completes_me_loaded = 1

function! s:completes_me(shift_tab)
  let dirs = ["\<c-p>", "\<c-n>"]

  if pumvisible()
    if a:shift_tab
      return dirs[0]
    else
      return dirs[1]
    endif
  endif

  " Figure out whether we should indent.
  let pos = getpos('.')
  let substr = matchstr(strpart(getline(pos[1]), 0, pos[2]-1), "[^ \t]*$")
  if strlen(substr) == 0 | return "\<Tab>" | endif

  if a:shift_tab
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <expr> <plug>completes_me_forward  <sid>completes_me(0)
inoremap <expr> <plug>completes_me_backward <sid>completes_me(1)

imap <Tab>   <plug>completes_me_forward
imap <S-Tab> <plug>completes_me_backward
