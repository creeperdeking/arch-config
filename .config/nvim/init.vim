set shell=/usr/bin/zsh

set encoding=utf-8
scriptencoding utf-8

" Use space to go append 1 character
:nnoremap <Space> i_<Esc>r

set wildmenu "better commandline completion
            f
""" Basic settings
set ic
set hls is

" Show errors for trailing spaces
match ErrorMsg '\s\+$' 
set showbreak=↪\ 
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨

set list lcs=tab:\|\ 
"set listchars=eol:↲,tab:>·,trail:·,extends:→
set listchars=tab:\|\ ,extends:»,precedes:«,nbsp:‡,trail:·

" The number of line that vim tries to have above and below
set scrolloff=20

set expandtab       " Expand TABs to spaces
" Enable intelligent tabbing and spacing for indentation and alignment
set smarttab

" Number of visual spaces per TAB
set tabstop=2
" Number of spaces indented when reindent operations (>> and <<) are used
set shiftwidth=2
" Sets the number of columns for a TAB
set softtabstop=2

let mapleader=","

set clipboard=unnamed

"set mouse=n " Accept mouse inputs

" Use ,, to switch between buffers
nnoremap <leader><leader> :b#<CR>

" Show colorcolumn at 80 character
set colorcolumn=80
:highlight ColorColumn ctermbg=grey guibg=lightgrey

" Relative numbering with current line shown
set number relativenumber

" Toggle line numbering mode
noremap <leader>rn :set rnu!<cr>

" Good copy and paste (desactivate auto indent when pasting)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
   set pastetoggle=<Esc>[201~
   set paste
   return ""
endfunction

" Desactivate arrow keys

noremap  <Up> ""
"noremap! <Up> <Esc>
noremap  <Down> ""
"noremap! <Down> <Esc>
noremap  <Left> ""
"noremap! <Left> <Esc>
noremap  <Right> ""
"noremap! <Right> <Esc>

"auto close {
function! s:CloseBracket()
    let line = getline('.')
    if line =~# '^\s*\(struct\|class\|enum\) '
        return "{\<Enter>};\<Esc>O"
    elseif searchpair('(', '', ')', 'bmn', '', line('.'))
        " Probably inside a function call. Close it off.
        return "{\<Enter>});\<Esc>O"
    else
        return "{\<Enter>}\<Esc>O"
    endif
endfunction
inoremap <expr> {<Enter> <SID>CloseBracket()


" Brace skipping
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"

inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

" Markdown Preview shortcuts

nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

" MarkdownPreview autostart

" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" Plugins shortcuts
nnoremap <leader>nt  :NERDTreeToggle<cr>

let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=darkgrey
hi IndentGuidesEven ctermbg=black
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Vim plug:

call plug#begin()

Plug 'tpope/vim-sensible'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Plug 'arcticicestudio/nord-vim'

Plug 'Yggdroot/indentLine'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }


call plug#end()
