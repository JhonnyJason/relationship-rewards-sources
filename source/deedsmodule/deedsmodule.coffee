deedsmodule = {name: "deedsmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["deedsmodule"]?  then console.log "[deedsmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
deedsmodule.initialize = () ->
    log "deedsmodule.initialize"
    return
    
module.exports = deedsmodule