require("onedark").setup({
	-- Main options --
	style = "warmer", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
	transparent = true, -- Show/hide background
	term_colors = true, -- Change terminal color as per the selected theme style
	cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

	-- toggle theme style ---
	toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between

	-- Lualine options --
	lualine = {
		transparent = true, -- lualine center bar transparency
	},
})
-- Enable theme
require("onedark").load()

-- -- This is for Rose-pine theme
-- vim.cmd("colorscheme rose-pine")
--
-- -- This is for Nightfox theme
-- require("nightfox").setup({ palettes = palettes, specs = specs, groups = groups })
--
-- -- setup must be called before loading
-- vim.cmd("colorscheme carbonfox")
-- vim.o.background = "dark"
