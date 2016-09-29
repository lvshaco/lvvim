if exists("b:current_syntax")
  finish
endif

runtime! syntax/c.vim
syn case match

syn keyword     protoInclude        import
syn keyword     protoStructure      message enum
syn keyword     protoLabel          required optional repeated
syn keyword     protoAssitant       max
syn keyword     protoType           bool
syn keyword     protoType           uint8 uint16 uint32 uint64
syn keyword     protoType           int8 int16 int32 int64
syn keyword     protoType           fixed32 fixed64 sfixed32 sfixed64 
syn keyword     protoType           float double
syn keyword     protoType           string bytes

"diffrent to C
"hi def link     protoInclude        include
"hi def link     protoStructure      structure
hi def link     protoInclude        keyword
hi def link     protoStructure      keyword
hi def link     protoLabel          keyword
hi def link     protoAssitant       keyword
hi def link     protoType           type

let b:current_syntax = "proto"
