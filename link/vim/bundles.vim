


" Misc settings

set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'


"Misc
"" General Utility Functions
Bundle 'genutils'

"" power line
Bundle 'Lokaltog/vim-powerline'
"Revision control
"" git integration
Bundle 'tpope/vim-fugitive'
"" perforce integration
"Bundle 'perforce'

"" static analysis
Bundle 'scrooloose/syntastic'
"" file browsing
Bundle 'scrooloose/nerdtree'
" Generates callgraphs
Bundle 'cctree'
source ~/.vim/vim.d/cctree

"
Bundle 'vim-scripts/taglist.vim'
"" fuzzy file finder
Bundle 'kien/ctrlp.vim'
"" opens header file of current file
Bundle 'vim-scripts/a.vim'
"
"" adds c snippets and commenting support
Bundle 'c.vim'
Bundle 'itchyny/calendar.vim'
"Bundle 'mattn/calendar.vim'

" Outliner
Bundle 'VOoM'

"gcov file highlighting
Bundle 'gcov.vim'

" rally support
" Need to compile vim with ruby support to use it
"Bundle 'davidpthomas/vim4rally'

" fast jumping around
" Bundle 'Lokaltog/vim-easymotion'

" colorscheme
Bundle 'flazz/vim-colorschemes'

filetype plugin on
filetype indent on
syntax on

" if it breaks
" export GIT_SSL_NO_VERIFY=true
"
" to install to :BundleInstall
