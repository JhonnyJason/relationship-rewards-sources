specificinterface = {}

secretmanagerinterface = require("./secretmanagerinterface")
Object.assign(specificinterface, secretmanagerinterface)

module.exports = specificinterface