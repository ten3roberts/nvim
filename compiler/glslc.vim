" Vim compiler file
" Compiler:         Cargo Compiler
" Maintainer:       Damien Radtke <damienradtke@gmail.com>
" Latest Revision:  2014 Sep 24
" For bugs, patches and license go to https://github.com/rust-lang/rust.vim

if exists('current_compiler')
	finish
endif

let current_compiler = "glslc"

let s:save_cpo = &cpo
set cpo&vim

if exists(':CompilerSet') != 2
	command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=glslc
CompilerSet errorformat=%f:%l:\ %t%*[^:]:%m

let &cpo = s:save_cpo
unlet s:save_cpo
