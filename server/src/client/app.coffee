$ ->

  bridge = new Bridge
    source: 'browser'
    device:
      id: '21B11682'
      class: 'tablet'
      model: '...'

  bridge.connect()

  bridge.respond 'command:viewURL', ({source, device}, params...) ->
    console.log 'got command:viewURL and params:', params
    console.log '\tsender:', {source, device}

  bridge.respond 'command:myCommand', ({source, device}, params...) ->
    console.log 'got command:myCommand and params:', params
    console.log '\tsender:', {source, device}

  ($ '#send-message').click ->
    bridge.send 'command:myCommand', 'a', 'b', 'c'
