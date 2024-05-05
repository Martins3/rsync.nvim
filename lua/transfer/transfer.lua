local M = {}

function M.sync_dir(port, remote_location)
	local root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" }, vim.fn.expand("%:p"))
	root = root:sub(1, -2)

	local cmd = "rsync -avzh  --filter='dir-merge,- .gitignore' "
	if port ~= nil then
		cmd = cmd .. "--rsh='ssh -p" .. port .. "'"
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

		end,
	})
end

return M
