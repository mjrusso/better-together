socket = io.connect()

socket.on 'connect', ->
  console.log 'connected'

socket.on 'announcement', (msg) ->
  console.log 'announcement: ', msg

socket.on 'viewURL', (url) ->
  console.log 'viewURL: ', url

socket.on 'nicknames', (nicknames) ->
  console.log 'nicknames: ', nicknames

socket.on 'user message', (from, msg) ->
  console.log 'user message: ', from, msg

socket.on 'reconnect', ->
  console.log 'reconnected'

socket.on 'reconnecting', ->
  console.log 'reconnecting...'

socket.on 'error', (e) ->
  console.log 'error: ', e

$(document).ready ->

  socket.emit 'nickname', 'MJR', (alreadySet) ->
    if not alreadySet
      console.log 'nickname set'
    else
      console.log 'nickname already in use!'

  ($ '#send-message').click ->
    socket.emit 'user message', 'my message!'#$('#message').val()
