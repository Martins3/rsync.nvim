local M = {}

function M.sync_dir(port, remote_location)
  local root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" }, vim.fn.expand("%:p"))
  root = root:sub(1, -2)

  local cmd = { "rsync", "--delete", "-avzh", "--exclude=.git/", "--filter=dir-merge,- .gitignore" }
  if port ~= nil then
    vim.list_extend(cmd, { "-e", "'ssh -p", port, "'" })
  end

  vim.list_extend(cmd, { root, remote_location })
  -- cmd = {"pwd"}

  local notification = vim.notify("rsync: " .. remote_location, vim.log.levels.INFO, {
    title = "Sync started...",
    icon = " ",
    timeout = 2000,
  })
  local replace
  if notification ~= nil and notification.Record then
    replace = notification.Record
  end
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
        vim.notify(table.concat(stderr, "\n"), vim.log.levels.ERROR, {
          timeout = 10000,
          title = "Error running rsync",
          icon = " ",
          replace = replace,
        })
        return
      end

      if #output == 0 then
        output = { "No differences found" }
      end
      vim.notify(table.concat(output, "\n"), vim.log.levels.INFO, {
        timeout = 3000,
        title = "Sync completed",
        icon = " ",
        replace = replace,
      })
    end,
  })
end

return M
