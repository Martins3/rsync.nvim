local M = {}

M.enable = false

local port
local location

M.config_loaded = false

local function load_config()
	if M.config_loaded == true then
		return
	end
	M.config_loaded = true

	local cwd = vim.loop.cwd()
	local config_file = cwd .. "/.nvim/deployment.lua"
	if vim.fn.filereadable(config_file) ~= 1 then
		vim.notify(
			"No deployment config found in \n" .. config_file .. "\n\nRun `:TransferInit` to create it",
			vim.log.levels.WARN,
			{
				title = "Transfer.nvim",
				icon = " ",
				timeout = 4000,
			}
		)
		return nil
	end
	local deployment_conf = dofile(config_file)
	if deployment_conf == nil then
		return
	end
	port = deployment_conf.port
	location = deployment_conf.user .. "@" .. deployment_conf.ip .. ":" .. deployment_conf.location
	vim.print(location)
end

local function create_autocmd()
	local augroup = vim.api.nvim_create_augroup("TransferNvim", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			if M.enable == true then
				require("transfer.transfer").sync_dir(port, location)
			end
		end,
		group = augroup,
	})
end

M.setup = function()
	create_autocmd()

	vim.api.nvim_create_user_command("TransferInit", function()
		local config = require("transfer.config")
		local template = config.options.config_template
		-- if template is a function, call it
		if type(template) == "function" then
			template = template()
		end
		-- if template is a string, split it into lines
		if type(template) == "string" then
			template = vim.fn.split(template, "\n")
		end
		local path = vim.loop.cwd() .. "/.nvim"
		if vim.fn.isdirectory(path) == 0 then
			vim.fn.mkdir(path)
		end
		path = path .. "/deployment.lua"
		if vim.fn.filereadable(path) == 0 then
			vim.fn.writefile(template, path)
		end
		vim.cmd("edit " .. path)
	end, { nargs = 0 })

	vim.api.nvim_create_user_command("TransferToggle", function()
		load_config()
		if M.enable == false then
			M.enable = true
			vim.notify("Transfer Enabled", vim.log.levels.WARN, {
				title = "Transfer.nvim",
				icon = "",
			})
		else
			vim.notify("Transfer Disabled", vim.log.levels.WARN, {
				title = "Transfer.nvim",
				icon = "👌",
			})
			M.enable = false
		end
	end, { nargs = 0 })
end

return M
