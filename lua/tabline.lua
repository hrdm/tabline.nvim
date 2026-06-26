local M = {}

function M.tabline()
	local s = ""
	local current = vim.fn.tabpagenr()
	local total = vim.fn.tabpagenr("$")

	for i = 1, total do
		local is_current = (i == current)
		s = s .. (is_current and "%#TabLineSel#" or "%#TabLine#")
		s = s .. "%" .. i .. "T"
		s = s .. " " .. M.tab_label(i)

		s = s .. (is_current and "%#TabLineSelMod#" or "%#TabLineMod#")
		s = s .. "%" .. i .. "T" .. M.tab_modified(i)

		if is_current then
			s = s .. "%#TabLineSep#"
		elseif i + 1 == current then
			s = s .. "%#TabLineSep4#"
		else
			s = s .. "%#TabLine#"
		end
	end

	s = s .. "%#TabLineFill#%T"

	if total > 1 then
		s = s .. "%=%#TabLine#%1000X"
	end

	return s
end

function M.tab_label(n)
	local wins = vim.api.nvim_tabpage_list_wins(vim.api.nvim_list_tabpages()[n])
	local win = wins[1]
	local buf = vim.api.nvim_win_get_buf(win)
	local name = vim.api.nvim_buf_get_name(buf)
	local label = vim.fn.fnamemodify(name, ":t")
	return label == "" and "  " or label
end

function M.tab_modified(n)
	local wins = vim.api.nvim_tabpage_list_wins(vim.api.nvim_list_tabpages()[n])
	local win = wins[1]
	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].modified and " ⏺" or "  "
end

return M
