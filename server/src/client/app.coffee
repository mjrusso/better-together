newActivity = (description) ->
  ($ '#activity-stream > ul').prepend "<li>#{description}</li>"

deviceClass = ->
  ua = navigator.userAgent
  if (ua.match /PlayBook/ or
      ua.match /iPad/ or
      ua.match /TouchPad/)
    'tablet'
  else if (ua.match /BlackBerry/ or
           ua.match /iPhone/ or
           ua.match /Android/ or
           ua.match /webOS/)
    'smartphone'
  else
    'desktop'

$ ->

  bridge = new Bridge
    source: 'browser'
    device:
      id: '21B11682'
      class: deviceClass()
      ua: navigator.userAgent
      platform: navigator.platform

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

  bridge.respond 'context:viewContent', ({source, device}, title, href, body) ->
    $.ajax
      url: '/context/keywords'
      type: 'POST'
      data:
        title: title
        text: body

      success: (response) ->
        console.log response

        ($ '#main-content').append("<h3>Context</h3>")

        for i in [0...4]
          term = response[i]?.word
          if term
            console.log "term: #{term}"
            div = "qwiki-#{i}"
            ($ '#main-content').append "<div id='#{div}'></div>"

            QwikiContainer.build
              query: term
              container: '#' + div
              layout: 'grid'
              width: 356
              count: 4

      error: ->
        console.log '/context/keywords request failed'

  ($ '#send-message').click ->
    bridge.send 'command:myCommand', 'a', 'b', 'c'
