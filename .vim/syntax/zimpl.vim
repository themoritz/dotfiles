" Vim syntax file
" Language:    ZIMPL
" Maintainer:  Moritz Drexl (mdrexl@fastmail.fm)
" Last Change: 2012 Jul 26

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn keyword zimplTodo    contained TODO FIXME XXX
syn match   zimplComment "^#.*" contains=zimplTodo
syn match   zimplComment "\s#.*"ms=s+1 contains=zimplTodo
syn region  zimplString  start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region  zimplString  start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline
syn keyword zimplKeyword sum read forall
syn keyword zimplStatement as match comment param set and or subto
syn keyword zimplStatement var maximize minimize binary in do
" syn match   zimplSpecial " | "

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link zimplComment   Comment
hi def link zimplTodo      Todo
hi def link zimplString    String
hi def link zimplStatement Statement
hi def link zimplKeyword   Keyword
hi def link zimplSpecial   Special

let b:current_syntax = "zimpl"
