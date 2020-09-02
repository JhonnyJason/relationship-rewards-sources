debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

debugmodule.modulesToDebug = 
    unbreaker: true
    configmodule: true
    darlingspagemodule: true
    settingspagemodule: true

export default debugmodule
