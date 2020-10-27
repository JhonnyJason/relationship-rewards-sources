secretmanagerinterface = {}

############################################################
secretmanagerinterface.addNodeId = ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
    url = allModules.statemodule.load("secretManagerURL") + "/addNodeId"
    return @postData(url, payload)
    
secretmanagerinterface.getSecretSpace = ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, timestamp}
    payload = await allModules.authmodule.signPayload(payload)

    url = allModules.statemodule.load("secretManagerURL") + "/getSecretSpace"
    return @postData(url, payload)

############################################################
secretmanagerinterface.getSecret = (secretId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, secretId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
    url = allModules.statemodule.load("secretManagerURL") + "/getSecret"
    return @postData(url, payload)

secretmanagerinterface.setSecret = (secretId, secret) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, secretId, secret, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
    
    url = allModules.statemodule.load("secretManagerURL") + "/setSecret"
    return @postData(url, payload)


secretmanagerinterface.deleteSecret = (secretId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, secretId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)

    url = allModules.statemodule.load("secretManagerURL") + "/deleteSecret"
    return @postData(url, payload)

############################################################
secretmanagerinterface.startAcceptingSecretsFrom = (fromId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, fromId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
    url = allModules.statemodule.load("secretManagerURL") + "/startAcceptingSecretsFrom"
    return @postData(url, payload)

secretmanagerinterface.stopAcceptingSecretsFrom = (fromId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, fromId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
    
    url = allModules.statemodule.load("secretManagerURL") + "/stopAcceptingSecretsFrom"
    return @postData(url, payload)

############################################################
secretmanagerinterface.startSharingSecretTo = (shareToId, secretId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, shareToId, secretId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)

    url = allModules.statemodule.load("secretManagerURL") + "/startSharingSecretTo"
    return @postData(url, payload)

secretmanagerinterface.stopSharingSecretTo = (sharedToId, secretId) ->
    publicKey = allModules.statemodule.load("publicKeyHex")
    timestamp = ""
    payload = {publicKey, sharedToId, secretId, timestamp}
    payload = await allModules.authmodule.signPayload(payload)
     
    url = allModules.statemodule.load("secretManagerURL") + "/stopSharingSecretTo"
    return @postData(url, payload)

#endregion

    
module.exports = secretmanagerinterface