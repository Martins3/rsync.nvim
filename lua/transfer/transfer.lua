local M = {}

-- Sync status: "idle", "syncing", "success", "error"
M.sync_status = "idle"

function M.get_status()
  return M.sync_status
end

function M.build_rsync_cmd(config, remote_location)
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
	return cmd
end

function M.sync_dir(config, remote_location)
	local cmd = M.build_rsync_cmd(config, remote_location)

	M.sync_status = "syncing"
	local stderr = {}
	local job_id = vim.fn.jobstart(cmd, {
		on_stderr = function(_, data, _)
			if data == nil or #data == 0 then
				return
			end
			vim.list_extend(stderr, data)
		end,
		on_exit = function(_, code, _)
			if code ~= 0 then
				M.sync_status = "error"
				vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR)
				return
			end
			-- Show notification when rsync completes successfully
			M.sync_status = "success"
			vim.notify("rsync done 😸", vim.log.levels.INFO, {
				title = "Transfer.nvim",
				timeout = 2000,
			})
		end,
	})

	if job_id <= 0 then
		M.sync_status = "error"
	end
end

return M
