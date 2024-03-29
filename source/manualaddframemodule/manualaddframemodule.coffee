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
state = null
score = null
pointAdd = null
slideinModule = null

manualScoreUpdateInput = null

############################################################
manualaddframemodule.initialize = () ->
    log "manualaddframemodule.initialize"
    state = allModules.statemodule
    score = allModules.scoremodule
    pointAdd = allModules.pointaddmodule
    slideinModule = allModules.slideinframemodule
    # manualaddframeContent.
    slideinModule.wireUp(manualaddframeContent, clearContent, applyContent)

    syncScoreFromState()
    state.addOnChangeListener("darlingScore", syncScoreFromState)

    manualScoreUpdateInput = pointAdd.setup(manualaddframeContent)
    return

############################################################
#region internalFunctions
syncScoreFromState = ->
    newScore = state.get("darlingScore")
    currentScoreDisplay.textContent = newScore
    return

clearContent = ->
    log "clearContent"
    syncScoreFromState()
    manualScoreUpdateInput.value = 0
    return

applyContent = ->
    log "applyContent"
    currentInputValue = manualScoreUpdateInput.value
    manualScoreUpdateInput.value = 0
    currentInputValue = parseInt(currentInputValue)
    score.addScore(currentInputValue)
    return


#endregion

############################################################
#region exposedFunctions
manualaddframemodule.slideOut = ->
    log "manualaddframemodule.slideOut"
    slideinModule.slideoutForContentElement(manualaddframeContent)
    return

manualaddframemodule.slideIn = ->
    log "manualaddframemodule.slideIn"
    return unless state.get("darlingAddress")
    slideinModule.slideinForContentElement(manualaddframeContent)
    return

#endregion
    
module.exports = manualaddframemodule