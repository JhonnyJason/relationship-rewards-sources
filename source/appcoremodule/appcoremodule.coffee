appcoremodule = {name: "appcoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["appcoremodule"]?  then console.log "[appcoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region Modules
state = null
accountSettings = null
#endregion

############################################################
#region internalProperties
client = null

darlingAddress = ""
darlingScore = ""

#endregion

############################################################
appcoremodule.initialize = ->
    log "appcoremodule.initialize"
    state = allModules.statemodule
    accountSettings = allModules.accountsettingsmodule

    state.addOnChangeListener("darlingAddress", onDarlingAddressChanged)
    state.addOnChangeListener("darlingScore", onDarlingScoreChanged)
    state.addOnChangeListener("accountId", onAccountChanged)
    return
    
############################################################
#region internalFunctions
onAccountChanged = ->
    log "onAccountChanged"
    client = accountSettings.getClient()
    return

onDarlingAddressChanged = ->
    log "onDarlingAddressChanged"
    newDarlingAddress = state.load("darlingAddress")
    
    olog {newDarlingAddress}
    olog {darlingAddress}

    if !newDarlingAddress
        log "we did not have a newDarlingAddress"
        try await disconnectFromDarling()
        catch err then log err.stack
        darlingAddress = ""
        return
    
    if darlingAddress and darlingAddress != newDarlingAddress
        try await disconnectFromDarling()
        catch err then log err.stack

    darlingAddress = newDarlingAddress

    try await connectToDarling()
    catch err then log err.stack
    return

onDarlingScoreChanged = ->
    log "onDarlingScoreChanged"
    darlingScore = state.load("darlingScore")
    currentDarlingAddress = state.load("darlingAddress")
    return unless currentDarlingAddress
    syncScoreToSecretManager()
    return

############################################################
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    try
        await client.setSecret("darlingScore", darlingScore)
        await client.shareSecretTo(darlingAddress, "darlingScore", darlingScore)
    catch err then log err.stack
    return

############################################################
disconnectFromDarling = ->
    log "disconnectFromDarling"
    olog {darlingAddress}
    await unsetState()
    olog {darlingAddress}
    await client.deleteSecret("darlingAddress")
    await client.deleteSecret("darlingScore")
    await client.stopAcceptSecretsFrom(darlingAddress)
    return

unsetState = ->
    promises = []

    promises.push state.set("darlingAddress", "")
    promises.push state.set("darlingScore", "")
    promises.push state.set("darlingIsConnected", false)
    promises.push state.set("myScore", "")
    await Promise.all(promises)
    
    state.saveAll()
    return

############################################################
connectToDarling = ->
    log "connectToDarling"

    await client.setSecret("darlingAddress", darlingAddress)
    await client.acceptSecretsFrom(darlingAddress)

    darlingScore = "" + 0
    state.save("darlingScore", darlingScore)
    return

#endregion

############################################################
#region exposedFunctions
appcoremodule.downSync = ->
    log "appcoremodule.downSync"
    if darlingAddress
        try myScore = await client.getSecretFrom("darlingScore", darlingAddress)
        catch err then log err.stack
            
    if myScore?
        state.set("myScore", myScore)
        state.set("darlingIsConnected", true)
        log "set myScore to: "+myScore
    else
        state.set("myScore", "")
        state.set("darlingIsConnected", false)
        log "we did not have a score"

    state.saveAll()
    return

appcoremodule.startUp = ->
    log "appcoremodule.startUp"
    allModules.settingspagemodule.slideIn()
    return
    client = accountSettings.getClient()
    darlingAddress = state.load("darlingAddress")
    darlingScore = state.load("darlingScore")
    return

#endregion

module.exports = appcoremodule

# 0x2d44a025be09b5c82ad0440b50e87a8a6f5ff3021c8820fe226bf72b25f96bad
# 0x9593f63450206a42657a8a3235747d0edba0f1f8707bf2d6127f7e6315203b52