express = require('express')

app = express.createServer()

app.register '.coffee', require('coffeekup')
app.set 'view engine', 'coffee'

app.use express.bodyParser()
app.use express.static(__dirname + '/../../public')
app.use express.static(__dirname + '/../../lib/client')

require('./handler')(app)

app.listen process.env.PORT || 8000
