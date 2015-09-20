class DropzoneInput
  constructor: (el)->
    @el = $ el
    Dropzone.autoDiscover = false
    @dropzone = new Dropzone(@el.get(0), {
      acceptedFiles: ".json"
      })
    @dropzone.on "addedfile", @refresh
    @loader = $ ".loader"

  refresh: =>
    setTimeout =>
      $.ajax
        url: @el.attr('action')
        success: @updateTarget
        beforeSend: @loading
    , 1000   

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


window.addComponent DropzoneInput, className: 'dropzone'