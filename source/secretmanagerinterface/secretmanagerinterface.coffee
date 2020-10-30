secretmanagerinterface = {}

############################################################
secretmanagerinterface.addNodeId = (serverURL, publicKey, timestamp, signature) ->
    payload = {publicKey, timestamp, signature}
    url = serverURL+"/addNodeId"
    return @postData(url, payload)
    
############################################################
secretmanagerinterface.getSecretSpace = (serverURL, publicKey, timestamp, signature) ->
    payload = {publicKey, timestamp, signature}
    url = serverURL+"/getSecretSpace"
    return @postData(url, payload)

secretmanagerinterface.getSecret = (serverURL, publicKey, secretId, timestamp, signature) ->
    payload = {publicKey, secretId, timestamp, signature}
    url = serverURL+"/getSecret"
    return @postData(url, payload)

############################################################
secretmanagerinterface.setSecret = (serverURL, publicKey, secretId, secret, timestamp, signature) ->
    payload = {publicKey, secretId, secret, timestamp, signature}
    url = serverURL+"/setSecret"
    return @postData(url, payload)

secretmanagerinterface.deleteSecret = (serverURL, publicKey, secretId, timestamp, signature) ->
    payload = {publicKey, secretId, timestamp, signature}
    url = serverURL+"/deleteSecret"
    return @postData(url, payload)

############################################################
secretmanagerinterface.startAcceptingSecretsFrom = (serverURL, publicKey, fromId, timestamp, signature) ->
    payload = {publicKey, fromId, timestamp, signature}
    url = serverURL+"/startAcceptingSecretsFrom"
    return @postData(url, payload)

secretmanagerinterface.stopAcceptingSecretsFrom = (serverURL, publicKey, fromId, timestamp, signature) ->
    payload = {publicKey, fromId, timestamp, signature}
    url = serverURL+"/stopAcceptingSecretsFrom"
    return @postData(url, payload)

############################################################
secretmanagerinterface.shareSecretTo = (serverURL, publicKey, shareToId, secretId, secret, timestamp, signature) ->
    payload = {publicKey, shareToId, secretId, secret, timestamp, signature}
    url = serverURL+"/shareSecretTo"
    return @postData(url, payload)

secretmanagerinterface.deleteSharedSecret = (serverURL, publicKey, sharedToId, secretId, timestamp, signature) ->
    payload = {publicKey, sharedToId, secretId, timestamp, signature}
    url = serverURL+"/deleteSharedSecret"
    return @postData(url, payload)

#endregion

    
module.exports = secretmanagerinterface