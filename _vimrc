" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Remap a few keys for Windows behavior
source $VIMRUNTIME/mswin.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" 配色方案
colorscheme desert
" 自动保存
set autoread
set autowrite
" 禁用代码折叠
set nofoldenable
let g:tex_conceal=""
" 鼠标样式设置为竖线
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[5 q" "SR = REPLACE mode
let &t_EI.="\e[5 q" "EI = NORMAL mode (ELSE)
" 设置行尾为Unix模式
set fileformat=unix
" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
" 代码补全
set completeopt=preview,menu
" 允许插件
filetype plugin on
" 共享剪贴板
set clipboard=unnamed
" 从不备份
set nobackup
" make 运行
:set makeprg=g++\ -Wall\ \ %
" 打开状态栏标尺
set ruler
" 突出显示当前行
set cursorline
hi CursorLine term=NONE cterm=NONE guibg=NONE guifg=NONE
" 设置魔术
set magic
" 隐藏工具栏
set guioptions-=T
" 隐藏菜单栏
set guioptions-=m
" 设置在状态行显示的信息
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ [%c:%l/%L]%)\
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 语法高亮
set syntax=on
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自动缩进
set autoindent
set cindent
" tab键的宽度设置为4
set tabstop=4
" 将tab 键显示为>---
set list lcs=tab:>-
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 用空格代替制表符
set expandtab
:retab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
" 禁止生成临时文件
set nobackup
set noswapfile
" 搜索忽略大小写
set ignorecase
" 搜索逐字符高亮
set hlsearch
set incsearch
" 行内替换
set gdefault
" 编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
" 语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 总是显示状态行
set laststatus=2
" 命令行高度
set cmdheight=2
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap=<,>,[,]
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是0.1s）
set matchtime=0
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 为C程序提供自动缩进
set smartindent
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile * setfiletype txt
" 自动补全
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
" 打开文件类型检测
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
filetype plugin indent on
set completeopt=longest,menu
" 启用鼠标
set mouse=a
set selection=exclusive
set selectmode=mouse,key
" 不要 intro 文档
set shm=I
" 设置Visual Block模式的快捷键为Ctrl+Shift+V，以防与粘贴（Ctrl+V）冲突
:command! VisualBlock execute "normal! \<C-S-v>"
