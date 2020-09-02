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
slideinModule = null

############################################################
darlingspagemodule.initialize = () ->
    log "darlingspagemodule.initialize"
    slideinModule = allModules.slideinframemodule
    # darlingspageContent.
    slideinModule.wireUp(darlingspageContent, clearContent, applyContent)
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
darlingspagemodule.turnDown = ->
    log "darlingspage.turnDown"
    slideinModule.slideoutForContentElement(darlingspageContent)
    return

darlingspagemodule.turnUp = ->
    log "darlingspagemodule.turnUp"
    slideinModule.slideinForContentElement(darlingspageContent)
    return
#endregion

module.exports = darlingspagemodule