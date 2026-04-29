local M = {}

function M.setup()
  require("base16-colorscheme").setup({
    -- Background tones
    base00 = "#291419", -- Default Background
    base01 = "#452129", -- Lighter Background (status bars)
    base02 = "#3e1e25", -- Selection Background
    base03 = "#756165", -- Comments, Invisibles
    -- Foreground tones
    base04 = "#b6afb0", -- Dark Foreground (status bars)
    base05 = "#f3f2f2", -- Default Foreground
    base06 = "#f3f2f2", -- Light Foreground
    base07 = "#f3f2f2", -- Lightest Foreground
    -- Accent colors
    base08 = "#cd4866", -- Variables, XML Tags, Errors
    base09 = "#669ecc", -- Integers, Constants
    base0A = "#d6a75c", -- Classes, Search Background
    base0B = "#e46783", -- Strings, Diff Inserted
    base0C = "#96c3e9", -- Regex, Escape Chars
    base0D = "#ec93a7", -- Functions, Methods
    base0E = "#e9c996", -- Keywords, Storage
    base0F = "#550e1e", -- Deprecated, Embedded Tags
  })
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
  "sigusr1",
  vim.schedule_wrap(function()
    package.loaded["matugen"] = nil
    require("matugen").setup()
  end)
)

return M
