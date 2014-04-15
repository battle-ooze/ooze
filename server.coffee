app = require './app'
app.listen CONST.get('port')
console.log 'listen ' + CONST.get('port')