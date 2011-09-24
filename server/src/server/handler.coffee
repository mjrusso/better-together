sio = require('socket.io')

module.exports = (app) ->

  io = sio.listen(app)

  app.get '/', (request, response) ->
    response.render 'index'

  app.post '/message/:name', (request, response) ->

    name = request.params.name
    data = request.body.data
    type = request.body.type
    source = request.body.source

    # params should be:
    # name: "" (name of message)
    # data: [] (list of parameters)
    # type: "command" (or 'context')
    # source: "" (the app that is sending the message)

    # forward mesage to all clients via socket.io
    # TODO where to put `type` and `source` params?
    io.sockets.emit(name, data)

    response.send "#{name}: #{data}"

  nicknames = {}

  io.sockets.on 'connection', (socket) ->

    io.sockets.socket(socket.id).emit('announcement', 'welcome ' + socket.id)

    socket.on 'bridge:configure', (source, device) -> #({source, device}) ->
      console.log "configuring client: source (#{source}) device", device
      socket.set 'details', {source, device}

    socket.on 'bridge:send', (name, params...) ->
      console.log "received '#{name}' event with params: ", params

      socket.get 'details', (err, {source, device}) ->
        socket.broadcast.emit name, {source, device}, params...

    socket.on 'user message', (msg) ->
      socket.broadcast.emit 'user message', socket.nickname, msg
      socket.emit 'announcement', 'this is a personal message to myself!'

    socket.on 'nickname', (nick, fn) ->
      if nicknames[nick]
        fn(true)
      else
        fn(false)
        nicknames[nick] = socket.nickname = nick
        socket.broadcast.emit('announcement', nick + ' connected')
        io.sockets.emit('nicknames', nicknames)

    socket.on 'disconnect', ->
      if (!socket.nickname) then return

      delete nicknames[socket.nickname]
      socket.broadcast.emit 'announcement', socket.nickname + ' disconnected'
      socket.broadcast.emit 'nicknames', nicknames

