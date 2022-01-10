" Defaults by Archlinux
runtime! archlinux.vim

" Colorscheme
set background=light
colorscheme PaperColor

" Save automatically
set autoread
set autowrite

" Turn code-folding off
set nofoldenable

" Restore cursor to file position in previous editing session
augroup resCur
  autocmd!
  autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

" Set EOL=<LF> (Unix style)
set fileformat=unix

" Case sensitive
set infercase

" Clipboard settings
set clipboard=unnamed
noremap <C-c> "+y
noremap <C-v> "+p
noremap y "+y
noremap p "+p

" Highlight current line
set cursorline

" Always show status line
set laststatus=2

" Do not use vi keybindings
set nocompatible

" Open syntax highlighting
set syntax=on

" Confirm when not saving or editing a read-only file
set confirm

" Intent settings
set autoindent
set smartindent
set cindent

" Tab settings
set tabstop=4
set smarttab
set expandtab
:retab
set list lcs=tab:>-
set softtabstop=4
set shiftwidth=4

" Show linenumbers
set number

" History counts
set history=1000

" Encoding settings
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,gb18030,gbk,gb2312,cp936

" Mouse settings
set mouse=a
set selection=exclusive
set selectmode=mouse,key

" No introduction
set shortmess=I

" Set keybinding of Visual Block mode as Ctrl+Shift+V, different from paste (Ctrl+V)
:command! VisualBlock execute "normal! \<C-S-v>"

" Hightlight search
set hlsearch
set incsearch

" Detect filetype
filetype on
filetype plugin on
filetype indent on

" Allow backspacing over autoindent, line breaks, start, nostop
set backspace=3

" Allows wrap only when cursor keys are used
set whichwrap=<,>,[,]

" Always report number of lines changed
set report=0

" Show matching brackets
set showmatch
set matchtime=0

" Autocomplete brackets
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=5

" Status line settings
set statusline=%F%m%r\ %y%=\ UTF-8:%b\ [row:%l,\ col:%c]\ [%p%%\ of\ %L\ lines]
set noruler
