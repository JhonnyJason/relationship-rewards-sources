headermodule = {name: "headermodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["headermodule"]?  then console.log "[headermodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = null

############################################################
headermodule.initialize = ->
    log "headermodule.initialize"
    state = allModules.statemodule

    headerLeft.addEventListener("click", allModules.darlingspagemodule.slideIn)
    # headerLeft.addEventListener("touchstart", allModules.darlingspagemodule.slideIn)
    headerCenter.addEventListener("click", allModules.manualaddframemodule.slideIn)
    # headerCenter.addEventListener("touchstart", allModules.manualaddframemodule.slideIn)
    headerRight.addEventListener("click", allModules.settingspagemodule.slideIn)
    # headerRight.addEventListener("touchstart", allModules.settingspagemodule.slideIn)

    syncScoreFromState()
    state.addOnChangeListener("darlingScore", syncScoreFromState)
    return
    
############################################################
syncScoreFromState = ->
    score = state.get("darlingScore")
    darlingScoreDisplay.textContent = score
    return

module.exports = headermodule