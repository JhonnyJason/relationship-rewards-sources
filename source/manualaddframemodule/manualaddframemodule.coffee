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
slideinModule = null

############################################################
manualaddframemodule.initialize = () ->
    log "manualaddframemodule.initialize"
    state = allModules.statemodule
    slideinModule = allModules.slideinframemodule
    # manualaddframeContent.
    slideinModule.wireUp(manualaddframeContent, clearContent, applyContent)

    syncScoreFromState()
    state.addOnChangeListener("darlingScore", syncScoreFromState)
    
    buttonPlus1.addEventListener("click", scorePlus1)
    buttonPlus2.addEventListener("click", scorePlus2)
    buttonPlus5.addEventListener("click", scorePlus5)
    buttonPlus10.addEventListener("click", scorePlus10)
    return

############################################################
#region internalFunctions
syncScoreFromState = ->
    newScore = state.load("darlingScore")
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
    score = currentInputValue + parseInt(state.load("darlingScore"))
    scoreString = "" + score
    state.save("darlingScore", scoreString)
    return

############################################################
#region addScoreFunctions
scorePlusX = (x) -> 
    currentInputValue = manualScoreUpdateInput.value
    currentInputValue = parseInt(currentInputValue) + x
    manualScoreUpdateInput.value = currentInputValue
    return

############################################################
scorePlus1 = -> scorePlusX(1)
scorePlus2 = -> scorePlusX(2)
scorePlus5 = -> scorePlusX(5)
scorePlus10 = ->scorePlusX(10)
#endregion

#endregion

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