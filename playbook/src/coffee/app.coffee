puts = (message...) ->
  ($ 'body').append "<p>#{message.join ' '}</p>"
  console.log message...

window.App =

  init: (server) ->

    puts "init"

    device =
      class: 'tablet'
      ua: navigator.userAgent
      platform: navigator.platform

    if blackberry?
      device.id = blackberry.identity.PIN
      device.model = blackberry.system.model

    bridge = new Bridge
      source: 'browser'
      device: device

    puts "connecting to bridge..."

    bridge.connect server

    bridge.respond 'command:viewURL', ({source, device}, url) ->
      puts 'received viewURL command: ', url
      console.log 'sender: ', {source, device}

      if blackberry?.invoke?
        try
          invoke = blackberry.invoke
          invoke.invoke invoke.APP_BROWSER, new invoke.BrowserArguments url
        catch e
          console.log e
