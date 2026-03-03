local transfer = require("transfer.transfer")
local config = require("transfer.config")
local commands = require("transfer.commands")

transfer.setup = function(opts)
  config.setup(opts)
  commands.setup()
end

-- Export status function for statusline integration
transfer.get_status = function()
  return commands.get_status()
end

return transfer
