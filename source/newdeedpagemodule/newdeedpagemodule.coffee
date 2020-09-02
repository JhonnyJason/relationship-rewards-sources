newdeedpagemodule = {name: "newdeedpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["newdeedpagemodule"]?  then console.log "[newdeedpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
slideinModule = null

############################################################
newdeedpagemodule.initialize = () ->
    log "newdeedpagemodule.initialize"
    slideinModule = allModules.slideinframemodule
    # newdeedpageContent.
    slideinModule.wireUp(newdeedpageContent, clearContent, applyContent)
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
newdeedpagemodule.turnDown = ->
    log "newdeedpagemodule.turnDown"
    slideinModule.slideoutForContentElement(newdeedpageContent)
    return

newdeedpagemodule.turnUp = ->
    log "newdeedpagemodule.turnUp"
    slideinModule.slideinForContentElement(newdeedpageContent)
    return
#endregion
    
module.exports = newdeedpagemodule