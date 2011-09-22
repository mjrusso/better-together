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

    # TODO params should be:
    # name: "" (name of message)
    # data: [] (list of parameters)
    # type: "command" (or 'context')
    # source: "" (the app that is sending the message)

    # forward mesage to all clients via socket.io
    # TODO where to put `type` and `source` params?
    io.sockets.emit(name, data)

    # TODO server should forward mesage to all clients via socket.io


    console.log "name: ", name
    console.log "data: ", data
    console.log "type: ", type
    console.log "source: ", source

    response.send 'foobar'

  nicknames = {}

  io.sockets.on 'connection', (socket) ->

    io.sockets.socket(socket.id).emit('announcement', 'welcome ' + socket.id)

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

