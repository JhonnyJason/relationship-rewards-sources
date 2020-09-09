scoremodule = {name: "scoremodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["scoremodule"]?  then console.log "[scoremodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
#region localModules
state = null
network = null
darlingsPage = null

#endregion

############################################################
#region internalProperties
darlingAddress = ""
darlingScore = ""
darlingIsConnected = false
myScore = ""

#endregion

############################################################
scoremodule.initialize = () ->
    log "scoremodule.initialize"
    state = allModules.statemodule
    network = allModules.networkmodule
    darlingsPage = allModules.darlingspagemodule 
    
    loadDataFromState()

    ## For debugging
    log "darlingAddress: " + darlingAddress
    log "darlingScore: " + darlingScore
    log "darlingIsConnected: " + darlingIsConnected
    log "myScore: " + myScore
    return

############################################################
loadDataFromState = ->
    darlingAddress = state.load("darlingAddress")
    darlingScore = state.load("darlingScore")
    darlingIsConnected = state.load("darlingIsConnected")
    myScore = state.load("myScore")
    return

############################################################
#region exposedFunctions
scoremodule.updateData = ->
    log "scoremodule.updateData"
    loadDataFromState()
    return


#endregion

module.exports = scoremodule