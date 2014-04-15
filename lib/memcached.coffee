###
memcached缓存
###

Memcached = require("memcached")

memcached  = new Memcached(CONST.get('memcached'))

module.exports = memcached

