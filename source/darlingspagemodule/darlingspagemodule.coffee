darlingspagemodule = {name: "darlingspagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["darlingspagemodule"]?  then console.log "[darlingspagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
state = null
appcore = null
qrReader = null
slideinModule = null

#endregion

############################################################
darlingspagemodule.initialize = () ->
    log "darlingspagemodule.initialize"
    state = allModules.statemodule
    appcore = allModules.appcoremodule
    qrReader = allModules.qrreadermodule

    slideinModule = allModules.slideinframemodule
    # darlingspageContent.
    slideinModule.wireUp(darlingspageContent, clearContent, applyContent)

    scanQrButton.addEventListener("click", scanQrButtonClicked)

    syncAddressFromState()
    syncIsConnectedFromState()
    syncMyScoreFromState()
    state.addOnChangeListener("myScore", syncMyScoreFromState)
    state.addOnChangeListener("darlingAddress", syncAddressFromState)
    state.addOnChangeListener("darlingIsConnected", syncIsConnectedFromState)
    return

############################################################
#region internalFunctions
syncAddressFromState = ->
    darlingAddress = state.get("darlingAddress")
    darlingspagemodule.displayDarlingAddress(darlingAddress)
    return

syncIsConnectedFromState = ->
    darlingIsConnected = state.get("darlingIsConnected")
    # log "state of darlingIsConnected: " + darlingIsConnected
    darlingspagemodule.displayDarlingIsConnected(darlingIsConnected)
    return

syncMyScoreFromState = ->
    myScore = state.get("myScore")
    darlingspagemodule.displayMyScore(myScore)
    return

############################################################
scanQrButtonClicked = ->
    log "scanQrButtonClicked"
    try chosenDarlingAddress.value = await qrReader.read()
    catch err then log err
    return
    
############################################################
clearContent = ->
    log "clearContent"
    syncAddressFromState()
    syncIsConnectedFromState()
    return

applyContent = ->
    log "applyContent"
    darlingAddress = chosenDarlingAddress.value
    darlingAddress = darlingAddress.replace("0x", "")
    state.set("darlingAddress", darlingAddress)
    return

#endregion

############################################################
#region exposedFunctions
darlingspagemodule.displayDarlingAddress = (address) ->
    log "darlingspagemodule.displayDarlingAddress"
    if address
        if !(address.indexOf("0x") == 0) then address = "0x" + address  
        chosenDarlingAddress.value = address
    else chosenDarlingAddress.value = ""
    return

darlingspagemodule.displayDarlingIsConnected = (isConnected) ->
    log "darlingspagemodule.displayDarlingIsConnected"
    if isConnected then connectedIndicator.classList.add("connected")
    else connectedIndicator.classList.remove("connected")
    return

darlingspagemodule.displayMyScore = (myScore) ->
    log "darlingspagemodule.displayMyScore"
    myScoreDisplay.textContent = "" + myScore
    return

############################################################
darlingspagemodule.slideOut = ->
    log "darlingspage.slideOut"
    slideinModule.slideoutForContentElement(darlingspageContent)
    return

darlingspagemodule.slideIn = ->
    log "darlingspagemodule.slideIn"
    slideinModule.slideinForContentElement(darlingspageContent)
    syncAddressFromState()
    await appcore.downSync()
    return
#endregion

module.exports = darlingspagemodule