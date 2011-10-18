## Better Together Bridge
#
# Connects multiple clients together via an intermediate routing service.
#
# Requires [socket.io](http://socket.io/).
#
#### Usage Examples
#
##### Create a new bridge.
#
#     bridge = new Bridge
#       source: 'browser'
#       device:
#         id: '21B11682'
#         class: 'tablet'
#         model: '...'
#
# Here, `source` is the name of the application that the bridge is being
# created on behalf of. The `device` object contains details about the
# particular device that is being paired. (The device class is arbitrary, but
# recommend values include  'tablet', 'smartphone', 'desktop', etc.) Other valid
# keys in the `device` object include 'platform', 'ua', etc.
#
##### Connect to the intermediate routing service.
#
# Note that this intermediate server routes messages between paired devices.
#
#     bridge.connect 'http://example.com:8000'
#
##### Send a message.
#
# Message names are namespaced with a colon. The choice of namespaces is
# arbitrary and is thus at the discretion of the framework user/ app developer.
#
#     bridge.send 'command:viewURL', 'http://example.com'
#
# Note that the first parameter is the name of the message, and can be followed
# with an arbitrary number of parameters specific to this particular message.
#
##### Respond to a message.
#
#     bridge.respond 'context:keyPressed', (sender, button) ->
#
# The first parameter is the name of the message to respond to. The second
# parameter is a callback function that is executed upon receipt of a message
# with the specified name. The callback function has the following format:
#
#     (sender, param1, param2, ...)
#
# Here, `sender` is an object that contains details about the sender of the
# message (`source` and `device` details). Following `sender` is an arbitrary
# list of parameters (dependent upon the particular message type).
#

class Bridge

  constructor: ({source, device}) ->
    @source = source
    @device = device
    @ready = false
    @log = (params...) -> console.log '[bridge] -', params...

  connect: (server) ->
    @socket = io.connect server
    @socket.on 'reconnecting', => @log 'reconnecting...'
    @socket.on 'reconnect', => @log 'reconnected'
    @socket.on 'error', (e) => @log 'error: ', e

    @socket.emit 'bridge:configure', @source, @device
    @socket.on 'bridge:ready', =>
      @ready = true

  configure: (details) ->
    for key, value of details
      if key in ['source']
        @[key] = value

  send: (name, params...) ->
    @socket.emit 'bridge:send', name, params...

  respond: (name, cb) ->
    @socket.on name, cb

window.Bridge = Bridge
