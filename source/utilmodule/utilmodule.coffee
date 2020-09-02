utilmodule = {name: "utilmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["utilmodule"]?  then console.log "[utilmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
utilmodule.initialize = () ->
    log "utilmodule.initialize"
    # hexString = "deadbeef"
    # result = utilmodule.toBytes(hexString)
    # log result
    # hexString = utilmodule.toHex(result)
    # log hexString
    return

############################################################
#region exposedFunctions
utilmodule.toHex = (byteArray) -> Array.prototype.map.call(byteArray, (byte) -> ('0' + (byte & 0xFF).toString(16)).slice(-2)).join('')


utilmodule.toBytes = (hexString) ->
    result = []
    for i in [0...hexString.length] by 2
        result.push(parseInt(hexString.substr(i, 2), 16))
    return result

#endregion

module.exports = utilmodule