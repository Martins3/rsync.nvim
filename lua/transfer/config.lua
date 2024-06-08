local M = {}

M.defaults = {
  -- deployment config template: can be a string, a function or a table of lines
  config_template = [[
return {
	-- port = 1234,
	ip = "10.0.1.1",
	user = "martins3",
	location = "/home/martins3",
}
]],
}

M.options = {}

M.setup = function(opts)
  opts = opts or {}
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
