module.exports = (app) ->

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

    # TODO server should forward mesage to all clients via socket.io

    console.log "name: ", name
    console.log "params: ", params

    response.send 'foobar'