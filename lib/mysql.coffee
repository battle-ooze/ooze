###
mysql
###

mysql = require("mysql")
pool = mysql.createPool(CONST.get('mysql'))
	
module.exports = pool

