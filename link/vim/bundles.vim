


" Misc settings

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'


"Misc
"" General Utility Functions
Plugin 'genutils'

"" required by powerline
Plugin 'gundo'
"Revision control
"" git integration
Plugin 'tpope/vim-fugitive'
"" perforce integration
"Plugin 'perforce'

"" static analysis
Plugin 'scrooloose/syntastic'
source ~/.vim/vim.d/syntastic
"" file browsing
Plugin 'scrooloose/nerdtree'
" Generates callgraphs
Plugin 'cctree'
source ~/.vim/vim.d/cctree

"
Plugin 'vim-scripts/taglist.vim'
"" fuzzy file finder
Plugin 'kien/ctrlp.vim'
"" opens header file of current file
Plugin 'vim-scripts/a.vim'
"
"" adds c snippets and commenting support
Plugin 'c.vim'
"" Calendar plugin
Plugin 'itchyny/calendar.vim'

" Outliner
Plugin 'VOoM'

"gcov file highlighting
Plugin 'gcov.vim'

" rally support
" Need to compile vim with ruby support to use it
"Plugin 'davidpthomas/vim4rally'

" fast jumping around
" Plugin 'Lokaltog/vim-easymotion'
"
"" tmux integration
Plugin 'christoomey/vim-tmux-navigator'

"" lots of colorschemes
"Plugin 'flazz/vim-colorschemes'

"" solarized
Plugin 'altercation/vim-colors-solarized'



call vundle#end()
filetype plugin on
filetype indent on
syntax on

" if it breaks
" export GIT_SSL_NO_VERIFY=true
"
" to install to :PluginInstall
