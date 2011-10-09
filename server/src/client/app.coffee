newActivity = (description) ->
  ($ '#activity-stream > ul').prepend "<li>#{description}</li>"

$ ->

  bridge = new Bridge
    source: 'browser'
    device:
      id: '21B11682'
      class: 'tablet'
      model: '...'

  bridge.connect()

  bridge.respond 'command:viewURL', ({source, device}, url) ->
    console.log 'got command:viewURL with url:', url
    console.log '\tsender:', {source, device}

  bridge.respond 'command:myCommand', ({source, device}, params...) ->
    console.log 'got command:myCommand and params:', params
    console.log '\tsender:', {source, device}

  bridge.respond 'bridge:joined', ({source, device}) ->
    newActivity "joined: #{device.class} (#{source})"
    console.log "new device joined bridge (#{source})", device

  bridge.respond 'context:viewContent', ({source, device}, title, href, body) ->
    newActivity "viewContent: #{title}"
    ($ '#main-content').empty()
    ($ '#main-content').append "<h2>#{title}</h2>"
    ($ '#main-content').append body

  ($ '#send-message').click ->
    bridge.send 'command:myCommand', 'a', 'b', 'c'
