###
redis缓存
###

redis = require("redis")
config = CONST.get('redis')
client = redis.createClient(config.port, config.host, config.options)

module.exports = client

