-- Set leader key
vim.g.mapleader = " "

-- Load general settings
require("settings")

-- Load plugins
require("plugins")

-- Load plugin settings
local plugin_settings = {
  "autoindent",
  "autopairs",
  "colorizer",
  "colors",
  "conform",
  "copilot-cmp",
  "copilot",
  "debugger",
  "fzf-lua",
  "gitsigns",
  "harpoon",
  "jupyter",
  "lsp",
  "lualine",
  "noice",
  "nvim-lint",
  "oil",
  "regex",
  "sql",
  "treesitter",
  "whichkey",
}

for _, module in ipairs(plugin_settings) do
  local ok, err = pcall(require, "plugin-settings." .. module)
  if not ok then
    vim.notify("Error loading plugin-settings/" .. module .. ": " .. err, vim.log.levels.ERROR)
  end
end
