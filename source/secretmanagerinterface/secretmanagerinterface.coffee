secretmanagerinterface = {}


############################################################
#region checkResponse
checkOKResponse = (response, route) ->
    if response.ok then return
    if response.error then throw new Error(response.error)
    msg = route+" - Unexpected Response: "+JSON.stringify(response) 
    throw new Error(msg)
    return

checkReturnedSecret = (response, route) ->
    if response.referencePoint? and response.encryptedContent? then return
    if response.error then throw new Error(response.error)
    msg = route+" - Unexpected Response: "+JSON.stringify(response) 
    throw new Error(msg)
    return

#endregion

############################################################
secretmanagerinterface.addNodeId = (serverURL, publicKey, timestamp, signature) ->
    route = "/addNodeId"
    payload = {publicKey, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

############################################################
secretmanagerinterface.getSecretSpace = (serverURL, publicKey, timestamp, signature) ->
    route = "/getSecretSpace"
    payload = {publicKey, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkReturnedSecret(response, route)
    return response

secretmanagerinterface.getSecret = (serverURL, publicKey, secretId, timestamp, signature) ->
    route = "/getSecret"
    payload = {publicKey, secretId, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkReturnedSecret(response, route)
    return response

############################################################
secretmanagerinterface.setSecret = (serverURL, publicKey, secretId, secret, timestamp, signature) ->
    route = "/setSecret"
    payload = {publicKey, secretId, secret, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

secretmanagerinterface.deleteSecret = (serverURL, publicKey, secretId, timestamp, signature) ->
    route = "/deleteSecret"
    payload = {publicKey, secretId, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

############################################################
secretmanagerinterface.startAcceptingSecretsFrom = (serverURL, publicKey, fromId, timestamp, signature) ->
    route = "/startAcceptingSecretsFrom"
    payload = {publicKey, fromId, timestamp, signature}
    url = serverURL+route
    response =  await @postData(url, payload)
    checkOKResponse(response, route)
    return

secretmanagerinterface.stopAcceptingSecretsFrom = (serverURL, publicKey, fromId, timestamp, signature) ->
    route = "/stopAcceptingSecretsFrom"
    payload = {publicKey, fromId, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

############################################################
secretmanagerinterface.shareSecretTo = (serverURL, publicKey, shareToId, secretId, secret, timestamp, signature) ->
    route = "/shareSecretTo"
    payload = {publicKey, shareToId, secretId, secret, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

secretmanagerinterface.deleteSharedSecret = (serverURL, publicKey, sharedToId, secretId, timestamp, signature) ->
    route = "/deleteSharedSecret"
    payload = {publicKey, sharedToId, secretId, timestamp, signature}
    url = serverURL+route
    response = await @postData(url, payload)
    checkOKResponse(response, route)
    return

#endregion

    
module.exports = secretmanagerinterface