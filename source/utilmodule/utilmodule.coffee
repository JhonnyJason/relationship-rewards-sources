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
tbu = require("thingy-byte-utils")
Object.assign(utilmodule, tbu)

msgBox = require("./messageboxmodule")

############################################################
utilmodule.initialize = () ->
    log "utilmodule.initialize"
    return

############################################################
#region exposedFunctions
utilmodule.copyToClipboard = (text) ->
    try 
        await navigator.clipboard.writeText(text)
        log "Clipboard API succeeded"
        if msgBox? then msgBox.info("Copied: "+text)
        return
    catch err then log err

    ## Oldschool Method
    ## create element to select from
    copyElement = document.createElement("textarea")
    copyElement.value = text
    copyElement.setAttribute("readonly", "")

    #have element available but not visible
    copyElement.style.position = "absolute"
    copyElement.style.left = "-99999px"
    document.body.appendChild(copyElement)
    
    #select text to copy
    document.getSelection().removeAllRanges()
    copyElement.select()
    copyElement.setSelectionRange(0, 99999)
    document.execCommand("copy")

    #remove element again
    document.body.removeChild(copyElement)
    if msgBox? then msgBox.info("Copied: "+text)
    return
        
#endregion

module.exports = utilmodule