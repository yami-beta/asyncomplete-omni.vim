if get(g:, 'loaded_autoload_asyncomplete_sources_omni')
  finish
endif
let g:loaded_autoload_asyncomplete_sources_omni = 1
let s:save_cpo = &cpo
set cpo&vim

function! asyncomplete#sources#omni#get_source_options(opts)
  return extend(extend({}, a:opts), {
  \ 'refresh_pattern': '\(\k\+$\|\.$\)',
  \ })
endfunction

function! asyncomplete#sources#omni#completor(opt, ctx) abort
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:kw = matchstr(l:typed, '\v\S+$')
  let l:kwlen = len(l:kw)
  if l:kwlen < 1
    return
  endif

  let Omnifunc_ref = function(&omnifunc)
  let l:startcol = Omnifunc_ref(1, '')
  if l:startcol < 0
    return
  endif

  let omnifunc_matches = Omnifunc_ref(0, l:kw)
  let l:matches = map(copy(omnifunc_matches), function('s:convert_omnifunc_result'))

  call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol + 1, l:matches)
endfunction

function! s:convert_omnifunc_result(_, match) abort
  if type(a:match) == type({})
    return {"word": a:match["word"], "dup": 1, "icase": 1, "menu": "[omni]"}
  else
    return {"word": a:match, "dup": 1, "icase": 1, "menu": "[omni]"}
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
