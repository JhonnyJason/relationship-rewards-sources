darlingmodule = {name: "darlingmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["darlingmodule"]?  then console.log "[darlingmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
state = null
secretManager = null

#endregion

############################################################
darlingmodule.initialize = ->
    log "darlingmodule.initialize"    
    state = allModules.statemodule
    secretManager = allModules.secretmanagerclientmodule
    return
    
############################################################
#region internalFunctions
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    score = state.load("darlingScore")
    
    try await secretManager.set("darlingScore", score)
    catch err then log err.stack
    return

############################################################
# retrieveSecretsSilently = ->
#     log "retrieveSecretsSilently"

#     darlingAddress = await secretManager.get("darlingAddress")
#     if !darlingAddress then state.setSilently("darlingAddress","")
#     else state.setSilently("darlingAddress", darlingAddress)

#     darlingScore = await secretManager.get("darlingScore")
#     if !darlingScore then state.setSilently("darlingScore", "")
#     else state.setSilently("darlingScore", darlingScore)
    
#     if !darlingAddress then return

#     return

applyStateChanges = ->
    log "applyStateChanges"
    if !state.load("darlingAddress")
        state.setSilently("darlingAddress", "")
        state.setSilently("darlingScore", "")
        state.setSilently("darlingIsConnected", false)
        state.setSilently("myScore", "")

    ## apply the potential state changes
    promises = []
    promises.push state.callOutChange("darlingAddress")
    promises.push state.callOutChange("darlingScore")
    promises.push state.callOutChange("darlingIsConnected")
    promises.push state.callOutChange("myScore")    
    await Promise.all(promises)
    state.saveAll()
    return

############################################################
unsetState = ->
    promises = []
    promises.push state.set("darlingAddress", "")
    promises.push state.set("darlingScore", "")
    promises.push state.set("darlingIsConnected", false)
    promises.push state.set("myScore", "")
    await Promise.all(promises)
    
    state.saveAll()
    return

unsetSecrets = ->
    log "unsetSecrets"
    await secretManager.delete("darlingAddress")
    await secretManager.delete("darlingScore")
    oldAddress = await secretManager.get("darlingAddress")
    return unless oldAddress

    await secretManager.stopAcceptFrom(oldAddress)
    return

############################################################
disconnectFromDarling = ->
    log "disconnectFromDarling"
    await unsetSecrets()
    await unsetState()
    return

setNewDarlingSecrets = ->
    log "setNewDarlingSecrets"
    darlingAddress = state.load("darlingAddress")

    await secretManager.set("darlingAddress", darlingAddress)
    await secretManager.acceptFrom(darlingAddress)
    await secretManager.shareTo(darlingAddress, "darlingScore")

    darlingScore = "" + 0
    state.save("darlingScore", darlingScore)

    await secretManager.set("darlingScore", darlingScore)
    return

#endregion

############################################################
#region exposedFunctions
darlingmodule.synchronize = ->
    log "darlingmodule.synchronize"
    darlingAddress = state.load("darlingAddress")
    if darlingAddress
        myScore = await secretManager.getFrom(darlingAddress, "darlingScore")

    if myScore?
        state.set("myScore", myScore)
        state.set("darlingIsConnected", true)
        log "set myScore to: "+myScore
    else
        state.set("myScore", "")
        state.set("darlingIsConnected", false)
        log "we did not have a score"
    state.saveAll()

    if darlingAddress? then  state.addOnChangeListener("darlingScore", syncScoreToSecretManager)
    else state.removeOnChangeListener("darlingScore", syncScoreToSecretManager)
    return

############################################################
darlingmodule.connect = ->
    log "darlingmodule.connect"
    darlingAddress = state.load("darlingAddress")
    
    if !darlingAddress
        await disconnectFromDarling()
        await darlingmodule.synchronize()
        return
    
    try
        oldAddress = await secretManager.get("darlingAddress")
        log oldAddress
        log darlingAddress
        if oldAddress == darlingAddress then return

        await setNewDarlingSecrets()
        await darlingmodule.synchronize()

    catch err then log err
    return

#endregion

module.exports = darlingmodule