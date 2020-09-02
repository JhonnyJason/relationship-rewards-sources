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
headermodule.initialize = () ->
    log "headermodule.initialize"
    headerLeft.addEventListener("click", allModules.darlingspagemodule.turnUp)
    headerCenter.addEventListener("click", allModules.manualaddframemodule.turnUp)
    headerRight.addEventListener("click", allModules.settingspagemodule.turnUp)
    return
    
module.exports = headermodule