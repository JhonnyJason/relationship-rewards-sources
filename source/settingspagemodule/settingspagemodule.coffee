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
slideinModule = null

############################################################
settingspagemodule.initialize = () ->
    log "settingspagemodule.initialize"
    slideinModule = allModules.slideinframemodule
    # settingspageContent.
    slideinModule.wireUp(settingspageContent, clearContent, applyContent)
    return

############################################################
clearContent = ->
    log "clearContent"
    # TODO implement
    return

applyContent = ->
    log "applyContent"
    #TODO implement
    return

####################################
#region exposedFunctions
settingspagemodule.turnDown = ->
    log "darlingspage.turnDown"
    slideinModule.slideoutForContentElement(settingspageContent)
    return

settingspagemodule.turnUp = ->
    log "settingspagemodule.turnUp"
    slideinModule.slideinForContentElement(settingspageContent)
    return

#endregion

module.exports = settingspagemodule