sio = require('socket.io')

module.exports = (app) ->

  io = sio.listen(app)
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

