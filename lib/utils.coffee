###
工具库
###
crypto = require 'crypto'

utils =
	# 生成随机字符串
	generateSalt: (length) ->
		SALTCHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
		r = []
		for i in [0...length]
			r.push(SALTCHARS[Math.floor(Math.random() * SALTCHARS.length)])
		r.join('')

	# 用key加密
	encrypt: (algorithm, key, value) ->
		cipher = crypto.createCipher(algorithm, key)
		enc = cipher.update(value, 'utf8', 'hex')
		enc += cipher.final('hex')

	# 用key解密
	decrypt: (algorithm, key, value) ->
		decipher = crypto.createDecipher(algorithm, key)
		dec = decipher.update(value, 'hex', 'utf8')
		dec += decipher.final('utf8')	

module.exports = utils
