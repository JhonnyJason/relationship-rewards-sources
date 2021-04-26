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

accountReset = false
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
    if client?
        log "we had a client!"
        accountReset = true
        try
            darlingAddress = await client.getSecret("darlingAddress")
            darlingScore = await client.getSecret("darlingScore")
        catch err
            log err.message
            darlingAddress = ""
            darlingScore = ""
        await state.save("darlingAddress", darlingAddress)
        await state.save("darlingScore", darlingScore)
        accountReset = false
    else setStateNoAccount()
    return

onDarlingAddressChanged = ->
    log "onDarlingAddressChanged"
    return if accountReset
    if !client? then state.setSilently("darlingAddress", "")
    
    newDarlingAddress = state.get("darlingAddress")
    
    olog {newDarlingAddress}
    olog {darlingAddress}

    if !newDarlingAddress
        log "we did not have a newDarlingAddress"
        try await disconnectFromDarling()
        catch err then log err.stack
        darlingAddress = ""
        state.saveRegularState()
        return
    
    if darlingAddress and darlingAddress != newDarlingAddress
        try await disconnectFromDarling()
        catch err then log err.stack

    darlingAddress = newDarlingAddress
    
    try await connectToDarling()
    catch err 
        log err.stack
        outstandingChanges = {}
        outstandingChanges.darlingAddress = darlingAddress
        state.save("outstandingChanges", outstandingChanges)

    state.saveRegularState()
    return

onDarlingScoreChanged = ->
    log "onDarlingScoreChanged"
    return if accountReset
    if !client? 
        await state.set("darlingScore", "")
        return
    
    oldScoreString = darlingScore
    darlingScore = state.get("darlingScore")
    currentDarlingAddress = state.get("darlingAddress")
    return unless currentDarlingAddress

    os = parseInt(oldScoreString)
    if isNaN(os) then os = 0
    ns = parseInt(darlingScore)
    dif = ns - os
    if !isNaN(dif) and dif != 0
        outstandingChanges = state.get("outstandingChanges")|| {darlingScore: 0}
        outstandingChanges.darlingScore += dif
        state.save("outstandingChanges", outstandingChanges)

    syncScoreToSecretManager()
    state.saveRegularState()
    return

############################################################
syncScoreToSecretManager = ->
    log "syncScoreToSecretManager"
    return unless client?

    try 
        await client.setSecret("darlingScore", darlingScore)
        state.remove("outstandingChanges")
    catch err 
        log err.stack
        return

    try await client.shareSecretTo(darlingAddress, "darlingScore", darlingScore)
    catch err 
        log err.stack
        state.set("darlingAddress", "")

    return

############################################################
disconnectFromDarling = ->
    log "disconnectFromDarling"
    return unless client?
    olog {darlingAddress}
    await unsetState()
    olog {darlingAddress}
    await client.deleteSecret("darlingAddress")
    await client.deleteSecret("darlingScore")
    await client.stopAcceptSecretsFrom(darlingAddress)
    return

unsetState = ->
    log "unsetState"
    promises = []

    promises.push state.set("darlingAddress", "")
    promises.push state.set("darlingScore", "")
    promises.push state.set("darlingIsConnected", false)
    promises.push state.set("myScore", "")
    await Promise.all(promises)
    
    state.saveRegularState()
    return

############################################################
connectToDarling = ->
    log "connectToDarling"
    return unless client?
    await client.acceptSecretsFrom(darlingAddress)
    await client.setSecret("darlingAddress", darlingAddress)

    darlingScore = "" + 0
    await state.set("darlingScore", darlingScore)
    return

############################################################
triadeSync = ->
    log "triadeSync"
    try
        clientDarlingAddress = await client.getSecret("darlingAddress")
        clientDarlingScore = await client.getSecret("darlingScore")
        if typeof clientDarlingScore == "number" then clientDarlingScore = ""+clientDarlingScore
    catch err 
        log err.stack
        # probably we are offline -> so no sync
        return

    # olog {clientDarlingAddress}
    # olog {darlingAddress}
    # olog {clientDarlingScore}
    # olog {darlingScore}

    accountReset = true
    # clientData > localData    
    if clientDarlingAddress and clientDarlingAddress != darlingAddress
        darlingAddress = clientDarlingAddress
        # log "should have downsynced darlingAddress!"
        await state.save("darlingAddress", darlingAddress)
    if clientDarlingScore and clientDarlingScore != darlingScore
        darlingScore = clientDarlingScore
        # log "should have downsynced darlingScore!"
        await state.save("darlingScore", darlingScore)
    accountReset = false

    outstandingChanges = state.get("outstandingChanges")
    return unless outstandingChanges?
    state.remove("outstandingChanges")

    changedAddress = outstandingChanges.darlingAddress
    changedScore = outstandingChanges.darlingScore
    score = parseInt(darlingScore)

    if changedAddress? or score == NaN then score = 0
    deltaScore = parseInt(changedScore)
    if deltaScore != NaN then score += deltaScore

    accountReset = true
    if changedAddress?
        darlingAddress = changedAddress
        await state.save("darlingAddress", darlingAddress)
    if score?
        darlingScore = ""+score
        await state.save("darlingScore", darlingScore)
    accountReset = false
    
    syncScoreToSecretManager()

    return

setStateNoAccount = ->
    log "setStateNoAccount"
    accountReset = true
    darlingAddress = ""
    darlingScore = ""
    await unsetState()
    accountReset = false
    return
#endregion

############################################################
#region exposedFunctions
appcoremodule.downSync = ->
    log "appcoremodule.downSync"
    return unless client?
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
    client = accountSettings.getClient()
    darlingAddress = state.load("darlingAddress")
    darlingScore = state.load("darlingScore")
    if client? then await triadeSync()
    else setStateNoAccount()
    return

#endregion

module.exports = appcoremodule

# 0x2d44a025be09b5c82ad0440b50e87a8a6f5ff3021c8820fe226bf72b25f96bad
# 0x9593f63450206a42657a8a3235747d0edba0f1f8707bf2d6127f7e6315203b52