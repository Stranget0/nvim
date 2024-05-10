local module = {}

function module.CountWindows(ignore)
	local tabpage = vim.api.nvim_get_current_tabpage()
	local win_list = vim.api.nvim_tabpage_list_wins(tabpage)
	local named_window = 0
	local visited_window = {}
	local isValidBuf = function(bufnr, buf_name, win_config)
		-- ignore empty buffers
		if buf_name == "" then
			return false
		end

		if win_config.relative ~= nil and win_config.relative ~= "" then
			return false
		end

		if not ignore then return true end

		local ignore_filetype = { 'NvimTree' }
		local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
		for _, v in pairs(ignore_filetype) do
			if v == filetype then
				return false
			end
		end

		return true
	end

	for _, win in ipairs(win_list) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(bufnr)
		local win_config = vim.api.nvim_win_get_config(win)
		if isValidBuf(bufnr, buf_name, win_config) then
			if not visited_window[buf_name] then
				visited_window[buf_name] = true
				named_window = named_window + 1
			end
		end
	end

	return named_window
end

function module.isLspAttached()
	return #vim.lsp.get_clients({ bufnr = 0 }) ~= 0
end

function module.truncateString(str, maxLength)
	if #str > maxLength then
		return string.sub(str, 1, maxLength - 3) .. "..."
	else
		return str
	end
end

return module
