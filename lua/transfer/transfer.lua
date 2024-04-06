local M = {}

function M.sync_dir(port, remote_location)
	local root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" }, vim.fn.expand("%:p"))
	root = root:sub(1, -2)

	local cmd = "rsync --delete -avzh --exclude=.git/ --filter='dir-merge,- .gitignore' "
	if port ~= nil then
		cmd = cmd .. "--rsh='ssh -p" .. port .. "'"
	end

	cmd = cmd .. " " .. root .. " " .. remote_location
	-- vim.print(cmd)

	local output = {}
	local stderr = {}
	vim.fn.jobstart(cmd, {
		on_stderr = function(_, data, _)
			if data == nil or #data == 0 then
				return
			end
			vim.list_extend(stderr, data)
		end,
		on_stdout = function(_, data, _)
			for _, line in pairs(data) do
				if line ~= "" then
					table.insert(output, line)
				end
			end
		end,
		on_exit = function(_, code, _)
			if code ~= 0 then
				vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR)
				return
			end

			if #output == 0 then
				output = { "No differences found" }
			end
			vim.notify(table.concat(output, "\n"), vim.log.levels.INFO)
		end,
	})
end

return M
