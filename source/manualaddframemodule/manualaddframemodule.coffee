manualaddframemodule = {name: "manualaddframemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["manualaddframemodule"]?  then console.log "[manualaddframemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
slideinModule = null

############################################################
manualaddframemodule.initialize = () ->
    log "manualaddframemodule.initialize"
    slideinModule = allModules.slideinframemodule
    # manualaddframeContent.
    slideinModule.wireUp(manualaddframeContent, clearContent, applyContent)
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

############################################################
#region exposedFunctions
manualaddframemodule.turnDown = ->
    log "manualaddframemodule.turnDown"
    slideinModule.slideoutForContentElement(manualaddframeContent)
    return

manualaddframemodule.turnUp = ->
    log "manualaddframemodule.turnUp"
    slideinModule.slideinForContentElement(manualaddframeContent)
    return
#endregion
    
module.exports = manualaddframemodule