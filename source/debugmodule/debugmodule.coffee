debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

#####################################################
debugmodule.modulesToDebug =
    unbreaker: true
    # accountsettingsmodule: true
    appcoremodule: true
    # configmodule: true
    # darlingspagemodule: true
    # deedsmodule: true
    # editdeedpagemodule: true
    # scoremodule: true
    # slideinframemodule: true
    # settingspagemodule: true
    # statemodule: true
    # utilmodule: true

export default debugmodule
