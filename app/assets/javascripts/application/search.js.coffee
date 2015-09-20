class Search
  constructor: (el)->
    @el = $ el
    @input = $ "input", @el
    @form = $ "form", @el
    @loader = $ ".loader"
    @input.bind "change", @search
    @form.bind "submit", @search

  search: =>
    $.ajax
      url: @form.attr('action')
      data: @form.serialize()
      success: @updateTarget
      beforeSend: @loading
    false  

  updateTarget: (data) =>
    $(".list").html("")
    $(".list").append(data)
    $(".list").show()
    @loader.hide()
    window.initialize()
  
  loading: => 
    @loader.html("")
    @loader.show()
    $(".list").hide()
    
    opts = 
      lines: 13
      length: 12
      width: 7
      radius: 42
      scale: 1
      corners: 1
      color: '#000'
      opacity: 0.25
      rotate: 0
      direction: 1
      speed: 1
      trail: 60
      fps: 20
      zIndex: 2e9
      className: 'spinner'
      top: '50%'
      left: '50%'
      shadow: false
      hwaccel: false
      position: 'absolute'
    
    spinner = new Spinner(opts).spin(@loader.get(0))

window.addComponent Search, className: 'search'