authmodule = {name: "authmodule"}
############################################################
#region printLogFunctions
log = (arg) ->
    if allModules.debugmodule.modulesToDebug["authmodule"]?  then console.log "[authmodule]: " + arg
    return
ostr = (obj) -> JSON.stringify(obj, null, 4)
olog = (obj) -> log "\n" + ostr(obj)
print = (arg) -> console.log(arg)
#endregion

############################################################
noble = require("noble-ed25519")

############################################################
state = null
utl = null

############################################################
secretKey = null
publicKey = null

############################################################
authmodule.initialize = () ->
    log "authmodule.initialize"
    state = allModules.persistentstatemodule
    utl = allModules.utilmodule

    secretKey = state.load("secretKey")
    if !secretKey  
        secretKey = utl.toHex(noble.utils.randomPrivateKey())
        state.save("secretKey", secretKey)
    
    publicKey = await noble.getPublicKey(secretKey)
    return


module.exports = authmodule