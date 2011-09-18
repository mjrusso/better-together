express = require('express')

app = express.createServer()

app.register '.coffee', require('coffeekup')
app.set 'view engine', 'coffee'

app.use express.static(__dirname + '/../public')

require('./routes')(app)

app.listen process.env.PORT || 8000

require('./socket')(app)
