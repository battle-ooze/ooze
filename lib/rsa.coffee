
ursa = require "ursa"

privateKey = ursa.createPrivateKey CONST.get('ssl:private'), 'binary'

publicKey =  ursa.createPublicKey CONST.get('ssl:public'), 'binary'

exports.decrypt = (content) ->
	content = new Buffer content, 'base64'
	privateKey.decrypt(
		content
		'base64'
		'utf8'
		ursa.RSA_PKCS1_PADDING
	)

exports.public = () -> 
	e:publicKey.getExponent().toString('hex')
	n:publicKey.getModulus().toString('hex')