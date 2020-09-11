import Modules from "./allmodules"
import domconnect from "./indexdomconnect"

############################################################
global.allModules = Modules

############################################################
window.onload = ->
    domconnect.initialize()
    promises = (m.initialize() for n,m of Modules)
    await Promise.all(promises)
    await appStartup()
    return

############################################################
appStartup = ->
    try
        await Modules.authmodule.startupCheck()
        await Modules.secretsmodule.updateSecrets()
    catch err
        errorMessage = """
            Exception in App Startup!
            So it might not work appropriately.
            
            #{err}
            """
        alert errorMessage
    return
