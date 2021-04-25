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
scoremodule.initialize = () ->
    log "scoremodule.initialize"
    state = allModules.statemodule
    return

############################################################
#region exposedFunctions
scoremodule.addScore = (score) ->
    log "scoremodule.addScore"
    return unless state.get("darlingAddress")

    darlingScore = state.get("darlingScore")

    if !score or isNaN(score) then score = "0"
    if !darlingScore or isNaN(darlingScore) then darlingScore = "0"

    newScoreNumber = parseInt(score) + parseInt(darlingScore)
    newScore = "" + newScoreNumber

    if !newScore or isNaN(newScore) then newScore = "0"

    state.set("darlingScore", newScore)
    return

#endregion

module.exports = scoremodule