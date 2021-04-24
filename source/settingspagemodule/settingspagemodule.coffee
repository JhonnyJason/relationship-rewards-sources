settingspagemodule = {name: "settingspagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["settingspagemodule"]?  then console.log "[settingspagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
state = null
slideinModule = null

#endregion

############################################################
settingspagemodule.initialize = ->
    log "settingspagemodule.initialize"
    state = allModules.statemodule
    slideinModule = allModules.slideinframemodule
    # settingspageContent.
    slideinModule.wireUp(settingspageContent, clearContent, applyContent)


    syncSecretManagerURLFromState()
    syncDataManagerURLFromState()

    state.addOnChangeListener("secretManagerURL", syncSecretManagerURLFromState)
    state.addOnChangeListener("dataManagerURL", syncDataManagerURLFromState)
    return

############################################################
#region internalFunctions
clearContent = ->
    log "clearContent"
    syncSecretManagerURLFromState()
    syncDataManagerURLFromState()
    return

applyContent = ->
    log "applyContent"
    secretManagerURL = secretManagerInput.value
    dataManagerURL = dataManagerInput.value
    state.set("secretManagerURL", secretManagerURL)
    state.set("dataManagerURL", dataManagerURL)
    state.saveAll()
    return

############################################################
syncSecretManagerURLFromState = ->
    log "syncSecretManagerURLFromState"
    secretManagerURL = state.load("secretManagerURL")
    secretManagerInput.value = secretManagerURL
    return

syncDataManagerURLFromState = ->
    log "syncDataManagerURLFromState"
    dataManagerURL = state.load("dataManagerURL")
    dataManagerInput.value = dataManagerURL
    return

#endregion

############################################################
#region exposedFunctions
settingspagemodule.slideOut = ->
    log "darlingspage.slideOut"
    slideinModule.slideoutForContentElement(settingspageContent)
    return

settingspagemodule.slideIn = ->
    log "settingspagemodule.slideIn"
    slideinModule.slideinForContentElement(settingspageContent)
    return

#endregion

module.exports = settingspagemodule