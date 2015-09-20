class HighlightJSON
  constructor: (el)->
    @el = $ el 
    for code in $("code", @el)
      hljs.highlightBlock(code)


window.addComponent HighlightJSON, className: 'hightlight-json'