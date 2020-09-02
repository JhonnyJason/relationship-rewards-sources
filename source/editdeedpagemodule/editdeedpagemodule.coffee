editdeedpagemodule = {name: "editdeedpagemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["editdeedpagemodule"]?  then console.log "[editdeedpagemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
slideinModule = null

############################################################
editdeedpagemodule.initialize = () ->
    log "editdeedpagemodule.initialize"
    slideinModule = allModules.slideinframemodule
    # editdeedpageContent.
    slideinModule.wireUp(editdeedpageContent, clearContent, applyContent)
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
editdeedpagemodule.turnDown = ->
    log "editdeedpagemodule.turnDown"
    slideinModule.slideoutForContentElement(editdeedpageContent)
    return

editdeedpagemodule.turnUp = ->
    log "editdeedpagemodule.turnUp"
    slideinModule.slideinForContentElement(editdeedpageContent)
    return
#endregion
    
module.exports = editdeedpagemodule