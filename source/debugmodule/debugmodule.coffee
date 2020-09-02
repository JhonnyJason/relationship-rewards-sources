debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

debugmodule.modulesToDebug = 
    unbreaker: true
    authmodule: true
    configmodule: true
    darlingspagemodule: true
    settingspagemodule: true
    utilmodule: true

export default debugmodule
