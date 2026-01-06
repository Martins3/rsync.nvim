local M = {}

function M.sync_dir(config, remote_location)
	local root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" }, vim.fn.expand("%:p"))
	root = root:sub(1, -2)

	local cmd = "rsync -avzh  --filter='dir-merge,- .gitignore' "
	if config.port ~= nil then
		cmd = cmd .. "--rsh='ssh -p" .. config.port .. "' "
	end

	-- Add --exclude=.git/ if ignore_git is true
	if config.ignore_git == true then
		cmd = cmd .. "--exclude=.git/ "
	end

	cmd = cmd .. " " .. root .. " " .. remote_location
	-- vim.print(cmd)

	local stderr = {}
	vim.fn.jobstart(cmd, {
		on_stderr = function(_, data, _)
			if data == nil or #data == 0 then
				return
			end
			vim.list_extend(stderr, data)
		end,
		on_exit = function(_, code, _)
			if code ~= 0 then
				vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR)
				return
			end
			-- Show notification when rsync completes successfully
			vim.notify("rsync done 😸", vim.log.levels.INFO, {
				title = "Transfer.nvim",
				timeout = 2000,
			})

		end,
	})
end

return M
