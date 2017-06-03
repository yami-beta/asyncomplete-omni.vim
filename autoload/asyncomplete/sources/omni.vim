if get(g:, 'loaded_autoload_asyncomplete_sources_omni')
  finish
endif
let g:loaded_autoload_asyncomplete_sources_omni = 1
let s:save_cpo = &cpo
set cpo&vim

function! asyncomplete#sources#omni#get_source_options(opts)
  return extend(extend({}, a:opts), {
  \ 'refresh_pattern': '\v(\k+|\.)$',
  \ })
endfunction

function! asyncomplete#sources#omni#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let Omnifunc_ref = function(&omnifunc)
  let l:startcol = Omnifunc_ref(1, '')
  if l:startcol < 0
    return
  endif
  if l:startcol > l:col
    let l:startcol = l:col
  endif

  let omnifunc_matches = Omnifunc_ref(0, l:typed[l:startcol:l:col])
  let l:matches = map(copy(omnifunc_matches), function('s:convert_omnifunc_result'))

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol + 1, l:matches)
endfunction

function! s:convert_omnifunc_result(_, match) abort
  let width = &columns
  let word = ''
  if type(a:match) == type({})
    let word = s:trim(a:match["word"], width)
  else
    let word = s:trim(a:match, width)
  endif
  return {"word": word, "dup": 0, "icase": 1, "menu": "[omni]"}
endfunction

function! s:trim(word, length) abort
  let ellipsis = '...'
  let ellipsis_length = strwidth(ellipsis)
  if strwidth(a:word) + ellipsis_length > a:length
    return a:word[0:(a:length - ellipsis_length)].ellipsis
  else
    return a:word
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
