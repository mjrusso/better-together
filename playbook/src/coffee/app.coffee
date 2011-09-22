puts = (message) ->
  ($ 'body').append "<p>#{message}</p>"

window.App =

  init: (server) ->

    puts 'welcome'
    console.log "done init"

    socket = io.connect server

    socket.on 'connect', ->
      console.log 'connected'

    socket.on 'reconnect', ->
      console.log 'reconnected'

    socket.on 'reconnecting', ->
      console.log 'reconnecting...'

    socket.on 'error', (e) ->
      console.log 'error: ', e

    socket.on 'viewURL', (url) ->
      console.log 'viewURL: ', url
      if blackberry?.invoke?
        try
          invoke = blackberry.invoke
          invoke.invoke invoke.APP_BROWSER, new invoke.BrowserArguments url
        catch e
          console.log e
