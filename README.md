# asyncomplete-omni.vim

Omni completion source for [asyncomplete.vim](https://github.com/prabirshrestha/asyncomplete.vim)

## Install

```vim
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
```

## Register asyncomplete-omni.vim

```vim
call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni',
\ 'whitelist': ['*'],
\ 'blacklist': ['html'],
\ 'completor': function('asyncomplete#sources#omni#completor')
\  }))
```

> Note: HTML is blacklisted above because Vim's default `omnifunc` repositions the cursor leading to quirky behaviour. You can reenable if you are using a more appropriate `omnifunc`.
