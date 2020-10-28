debugmodule = {name: "debugmodule", uimodule: false}

#####################################################
debugmodule.initialize = () ->
    # console.log "debugmodule.initialize - nothing to do"
    return

#####################################################
debugmodule.modulesToDebug =
    unbreaker: true
    # authmodule: true
    # configmodule: true
    # darlingspagemodule: true
    darlingmodule: true
    # deedsmodule: true
    # editdeedpagemodule: true
    # encryptionmodule: true
    # networkmodule: true
    # scoremodule: true
    secretmanagerclientmodule: true
    # slideinframemodule: true
    # settingspagemodule: true
    # statemodule: true
    # utilmodule: true

export default debugmodule
