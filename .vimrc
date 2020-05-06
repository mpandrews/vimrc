" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Highlight anything past column 80.

if exists ('&colorcolumn')
  set colorcolumn=81
endif

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.

"Disabled because I'd rather let the terminal have the mouse, and I just don't
"use the mouse in vim anyway.

"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" Enable true color
set termguicolors

" Folding setup
set foldmethod=syntax
set foldlevel=99
set foldnestmax=10

set linebreak
set showbreak=…

set cursorline

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
"Plugin 'Valloric/YouCompleteMe'

Plugin 'dense-analysis/ale'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'morhetz/gruvbox'
Plugin 'tpope/vim-fugitive'

"Deoplete needs msgpack1.0.
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'

"Fuzzy Finder
Plugin 'junegunn/fzf.vim'

"Haskell-Vim: redundant with polyglot
"Plugin 'neovimhaskell/haskell-vim'

"Gutentags: automated tag generation.

Plugin 'ludovicchabant/vim-gutentags'

"polyglot: syntax files.

Plugin 'sheerun/vim-polyglot'

"quick-scope highlights the first instance of a given character on the current
"line.
Plugin 'unblevable/quick-scope'

Plugin 'airblade/vim-gitgutter'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"


"ALE Settings

let g:ale_c_parse_makefile = 1
let g:ale_c_gcc_options = '-Wall'
let g:ale_c_clang_options = '-Wall'
"let g:ale_linters = { 'c' : ['gcc'] }
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace' ],
\		     'haskell': ['brittany'],
\		   }
let g:ale_sign_priority = 11 "git-gutter's priority is 10.

"Airline Settings

set noshowmode " Hides the mode in the status line; ditch if not using airline.
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

"Deoplete Settings

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('sources', { '_' : ['ale',], })
"call deoplete#enable_logging('DEBUG', 'deoplete.log')

"quick-scope settings

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"Set the colors to gruvbox blue and aqua, and underline.

augroup qs_colors
	autocmd!
	autocmd ColorScheme * highlight QuickScopePrimary guifg='#458588' gui=underline cterm=underline
	autocmd ColorScheme * highlight QuickScopeSecondary guifg='#689d6a' gui=underline cterm=underline
augroup END

"Git-gutter settings
let g:gitgutter_signs = 0
let g:gitgutter_sign_allow_clobber = 0

"Gruvbox settings

let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'hard'
"let g:gruvbox_invert_signs = 1
"let g:gruvbox_invert_tabline = 1
colorscheme gruvbox
set bg=dark

"KEYBINDS
let mapleader=" "

nmap <leader>f :GFiles<CR>
nmap <leader>F :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>t :BTags<CR>
nmap <leader>T :Tags<CR>
nmap <leader>l :BLines<CR>
nmap <leader>L :Lines<CR>
nmap <leader>a :Ag<CR>
nmap <leader>g :GitGutterSignsToggle<CR>
nmap <leader>G :GitGutterLineHighlightsToggle<CR>
