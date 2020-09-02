persistentstatemodule = {name: "persistentstatemodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["persistentstatemodule"]?  then console.log "[persistentstatemodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
state = localStorage.getItem("state")
if state then state = JSON.parse(state)
else state = {}

############################################################
persistentstatemodule.initialize = () ->
    log "persistentstatemodule.initialize"
    return

############################################################
saveState = ->
    log "saveState"
    stateString = JSON.stringify(state)
    localStorage.setItem("state", stateString)
    return

############################################################
#region exposedFunctions
persistentstatemodule.getState = -> state

############################################################
persistentstatemodule.save = (key, content) ->
    state[key] = content
    saveState()
    return

persistentstatemodule.load = (key) -> state[key]

#endregion

module.exports = persistentstatemodule



