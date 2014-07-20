scriptencoding utf-8
set encoding=utf-8
set nocompatible
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set hls
set incsearch
set number
set autoread
set showcmd
set tabpagemax=25
set listchars=eol:$,tab:\|\ ,trail:~,nbsp:+
syntax on

set background=dark
colorscheme wombat

set sessionoptions=buffers,sesdir,folds,tabpages
set cursorline

" Turn on Pathogen
execute pathogen#infect()
filetype plugin indent on

" Esc is too far away
map § <ESC>
map! § <ESC>

""" Tab bindings

" Previous tab
map <C-K>h <ESC>:tabprevious<CR>
map! <C-K>h <ESC>:tabprevious<CR>
" First tab
map <C-K>H <ESC>:tabfirst<CR>
map! <C-K>H <ESC>:tabfirst<CR>
" Next tab
map <C-K>l <ESC>:tabnext<CR>
map! <C-K>l <ESC>:tabnext<CR>
" Last tab
map <C-K>L <ESC>:tablast<CR>
map! <C-K>L <ESC>:tablast<CR>
" New tab after current
map <C-K>n <ESC>:tabnew<CR>
map! <C-K>n <ESC>:tabnew<CR>
" New tab after last
map <C-K>N <ESC>:tablast<CR>:tabnew<CR>
map! <C-K>N <ESC>:tablast<CR>:tabnew<CR>
" Close tab
map <C-K>c <ESC>:tabclose<CR>
map! <C-K>c <ESC>:tabclose<CR>
" Move current tab one to left
map <C-K>k <ESC>:tabmove -1<CR>
" Move current tab one to right
map <C-K>j <ESC>:tabmove +1<CR>
" Move current tab all the way to left
map <C-K>K <ESC>:tabmove 0<CR>
" Move current tab all the way to right
map <C-K>J <ESC>:tabmove<CR>

""" Other

" Word wrap for current line
map <C-K>w <ESC>gqgq<CR>
" Word wrap for whole paragraph
map <C-K>W <ESC>gq}<CR>
" Save current session
map <C-K>S <ESC>:mksession!<CR>
" Save all open files, current session and quit
map <C-K>Q <ESC>:wa<CR>:mksession!<CR>:qa<CR>
" Add inclusion guard to current buffer
map <C-K>i <ESC>:call WriteIncludeGuard()<CR>
" Add C compilation directive
map <C-K>e <ESC>:call WriteExternCDef()<CR>
" Toggle list (show whitespace)
map <C-K>s <ESC>:set list!<CR>

""" Functions

" Writes multiple inclusion guard defines to current buffer
function! WriteIncludeGuard()
	let name = expand("%:t")
	
	if empty(name)
		echom "No file name!"
	else
		let name = substitute(toupper(name), '\W', '_', 'g') . '_GUARD'
		call append(0, ['#ifndef ' . name, '#define ' . name])
		call append(line('$'), '#endif /* ' . name . ' */')
	endif
endfunction

" C compilation defines for C++
function! WriteExternCDef()
	call append(0, '#ifdef __cplusplus')
	call append(1, 'extern "C" {')
	call append(2, '#endif')
	call append(line('$'), '#ifdef __cplusplus')
	call append(line('$'), '}')
	call append(line('$'), '#endif')
endfunction
