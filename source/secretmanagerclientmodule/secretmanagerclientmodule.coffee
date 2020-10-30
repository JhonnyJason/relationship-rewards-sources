secretmanagerclientmodule = {name: "secretmanagerclientmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["secretmanagerclientmodule"]?  then console.log "[secretmanagerclientmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region modulesFromEnvironment
noble = require("noble-ed25519")

############################################################
#region localModules
utl = null
state = null
network = null
encryption = null

#endregion

#endregion

############################################################
secretmanagerclientmodule.initialize = ->
    log "secretmanagerclientmodule.initialize"
    utl = 
    state = allModules.statemodule
    network = allModules.networkmodule
    encryption = allModules.encryptionmodule
    return

############################################################
class Client
    constructor: (@secretKeyHex, @publicKeyHex, @serverURL) ->
        @ready = addNodeId(this)

    getSecretSpace:  ->
        await @ready
        secret = await getSecretSpace(this)
        return await decrypt(secret, @secretKeyHex)

    getSecret: (secretId) ->
        await @ready
        secret = await getSecret(secretId, this)
        return await decrypt(secret, @secretKeyHex)

    getSecretFrom: (secretId, fromId) ->
        await @ready
        secretId = fromId+"."+secretId
        secret = await getSecret(secretId, fromId, this)
        return await decrypt(secret, @secretKeyHex)

    setSecret: (secretId, secret) ->
        await @ready
        secret = await encrypt(secret, @publicKeyHex)
        return await setSecret(secretId, secret, this)

    deleteSecret: (secretId) ->
        await @ready
        return await deleteSecret(secretId, this)


    acceptSecretsFrom: (fromId) ->
        await @ready
        return await acceptSecretsFrom(fromId, this)

    stopAcceptSecretsFrom: (fromId) ->
        await @ready
        return await stopAcceptSecretsFrom(fromId, this)


    shareSecretTo: (shareToId, secretId, secret) ->
        await @ready
        secret = await encrypt(secret, shareToId)
        return await shareSecretTo(shareToId, secretId, secret, this)

    deleteSharedSecret: (sharedToId, secretId) ->
        await @ready
        return await deleteSharedSecret(sharedToId, secretId, this)

############################################################
#region internalFunctions

############################################################
#region cryptoHelpers
newSecretBytes = noble.utils.randomPrivateKey

############################################################
decrypt = (content, secretKey) ->
    while content.encryptedContent?
        content = await encryption.asymetricDecrypt(content, secretKey)
        content = encryption.removeSalt(content)
        content = JSON.parse(content)
    return content

############################################################
encrypt = (content, publicKey) ->
    return content

    if typeof content == "object" then content = JSON.stringify(content)
    salt = encryption.createRandomLengthSalt()
    content = salt + content

    content = await encryption.asymetricEncrypt(content, publicKey)
    return content

############################################################
createSignature = (payload, route, secretKey) ->
    hashHex = await utl.sha256Hex(JSON.stringify(payload))
    signature = await noble.sign(hashHex, secretKeyHex)
    return signature

#endregion

############################################################
#region effectiveNetworkCommunication
addNodeId = (client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, timestamp}
    route = "/addNodeId"
    signature = await createSignature(payload, route, secretKey)
    return await network.addNodeId(server, publicKey, timestamp, signature)

############################################################
getSecretSpace = (client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, timestamp}
    route = "/getSecretSpace"
    signature = await createSignature(payload, route, secretKey)
    return await network.getSecretSpace(server, publicKey, timestamp, signature)

getSecret = (secretId, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, secretId, timestamp}
    route = "/getSecret"
    signature = await createSignature(payload, route, secretKey)
    return await network.getSecret(server, publicKey, secretId, timestamp, signature)

############################################################
setSecret = (secretId, secret, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, secretId, secret, timestamp}
    route = "/setSecret"
    signature = await createSignature(payload, route, secretKey)
    return await network.setSecret(server, publicKey, secretId, secret, timestamp, signature)

deleteSecret = (secretId, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, secretId, timestamp}
    route = "/deleteSecret"
    signature = await createSignature(payload, route, secretKey)
    return await network.deleteSecret(server, publicKey, secretId, timestamp, signature)

############################################################
acceptSecretsFrom = (fromId, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, fromId, timestamp}
    route = "/startAcceptingSecretsFrom"
    signature = await createSignature(payload, route, secretKey)
    return await network.startAcceptingSecretsFrom(server, publicKey, fromId, timestamp, signature)

stopAcceptSecretsFrom = (fromId, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, fromId, timestamp}
    route = "/stopAcceptingSecretsFrom"
    signature = await createSignature(payload, route, secretKey)
    return await network.stopAcceptingSecretsFrom(server, publicKey, fromId, timestamp, signature)

############################################################
shareSecretTo = (shareToId, secretId, secret, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, shareToId, secretId, secret, timestamp}
    route = "/shareSecretTo"
    signature = await createSignature(payload, route, secretKey)
    return await network.shareSecretTo(server, publicKey, shareToId, secretId, secret, timestamp, signature)

deleteSharedSecret = (sharedToId, secretId, client) ->
    server = client.serverURL
    publicKey = client.publicKeyHex
    secretKey = client.secretKeyHex
    timestamp = ""
    payload = {publicKey, shareToId, secretId, secret, timestamp}
    route = "/deleteSharedSecret"
    signature = await createSignature(payload, route, secretKey)
    return await network.deleteSharedSecret(server, publicKey, sharedToId, secretId, timestamp, signature)


#endregion

#endregion

############################################################
secretmanagerclientmodule.createClient = (secretKeyHex, publicKeyHex, serverURL) ->
    if !secretKeyHex
        secretKeyHex = utl.bytesToHex(newSecretBytes())
        publicKeyHex = await noble.getPublicKey(secretKeyHex)
    if !publicKeyHex
        publicKeyHex = await noble.getPublicKey(secretKeyHex)
    return new Client(secretKeyHex, publicKeyHex, serverURL)

module.exports = secretmanagerclientmodule