sio = require('socket.io')

module.exports = (app) ->

  io = sio.listen(app)

  app.get '/', (request, response) ->
    response.render 'index'

  app.post '/message/:name', (request, response) ->

    name = request.params.name
    params = request.body.params
    source = request.body.source
    device = JSON.parse request.body.device

    # forward mesage to all clients via socket.io
    io.sockets.emit name, {source, device}, params

    response.send "#{name}: #{params}"

  io.sockets.on 'connection', (socket) ->

    socket.on 'bridge:configure', (source, device) ->
      console.log "configuring client: source (#{source}) device", device
      socket.set 'details', {source, device}, ->
        socket.emit 'bridge:ready'
        socket.broadcast.emit 'bridge:joined', {source, device}

    socket.on 'bridge:send', (name, params...) ->
      console.log "received '#{name}' event with params: ", params
      socket.get 'details', (err, {source, device}) ->
        socket.broadcast.emit name, {source, device}, params...

    socket.on 'disconnect', ->
      console.log "socket #{socket.id} disconnected"
