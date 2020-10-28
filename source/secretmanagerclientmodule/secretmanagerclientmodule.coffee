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
#region localModules
state = null
network = null
encryption = null

#endregion

############################################################
secretmanagerclientmodule.initialize = ->
    log "secretmanagerclientmodule.initialize"
    state = allModules.statemodule
    network = allModules.networkmodule
    encryption = allModules.encryptionmodule
    return

############################################################
decrypt = (content) ->
    secretKey = state.load("secretKeyHex")
    while content.encryptedContent?
        content = await encryption.asymetricDecrypt(content, secretKey)
        content = encryption.removeSalt(content)
        content = JSON.parse(content)
    return content

############################################################
encrypt = (content) ->
    return content
    if typeof content == "object" then content = JSON.stringify(content)
    salt = encryption.createRandomLengthSalt()
    content = salt + content

    publicKey = state.load("publicKeyHex")
    content = await encryption.asymetricEncrypt(content, publicKey)
    return content

############################################################
#region exposedStuff
secretmanagerclientmodule.getSpace = ->
    try
        answer = await network.getSecretSpace()
        answer = await decrypt(answer)
    catch error then log error.stack
    return

secretmanagerclientmodule.get = (secretId) ->
    try
        answer = await network.getSecret(secretId)
        answer = await decrypt(answer)
    catch error then log error.stack
    return answer

secretmanagerclientmodule.getFrom = (fromId, secretId) ->
    secretId = fromId+"."+secretId
    try
        answer = await network.getSecret(secretId)
        answer = await decrypt(answer)
    catch error then log error.stack
    return answer

############################################################
secretmanagerclientmodule.set = (secretId, secret) ->
    try
        before = performance.now()
        secret = await encrypt(secret)
        after = performance.now()
        log "encryption took "+(after-before)+"ms"
        await network.setSecret(secretId, secret)
    catch error then log error.stack
    return

secretmanagerclientmodule.delete = (secretId) ->
    try await network.deleteSecret(secretId)    
    catch error then log error.stack
    return

#0x9593f63450206a42657a8a3235747d0edba0f1f8707bf2d6127f7e6315203b52
#0x7bdd2e52229fe004b603ab6798fe3384897a02263d6aae3453ccdeb2f15ccb62
############################################################
secretmanagerclientmodule.shareTo = (shareToId, secretId) ->
    try await network.startSharingSecretTo(shareToId, secretId)
    catch error then log error.stack
    return

secretmanagerclientmodule.stopShareTo = (sharedToId, secretId) ->
    try await network.stopSharingSecretTo(sharedToId, secretId)
    catch error then log error.stack
    return

############################################################
secretmanagerclientmodule.acceptFrom = (fromId) ->
    try await network.startAcceptingSecretsFrom(fromId)
    catch error then log error.stack
    return

secretmanagerclientmodule.stopAcceptFrom = (fromId) ->
    try await network.stopAcceptingSecretsFrom(fromId)
    catch error then log error.stack
    return

#endregion

module.exports = secretmanagerclientmodule