return {
  "RRethy/base16-nvim",
  config = function()
    local transparent_groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "FloatBorder",
      "SignColumn",
      "EndOfBuffer",
      "FoldColumn",
      "LineNr",
      "CursorLineNr",
      "StatusLine",
      "StatusLineNC",
      "WinSeparator",
    }

    local function apply_transparency()
      for _, group in ipairs(transparent_groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok then
          hl.bg = nil
          hl.ctermbg = nil
          vim.api.nvim_set_hl(0, group, hl)
        end
      end
    end

    local base16 = require("base16-colorscheme")
    if not base16._transparent_background then
      local setup = base16.setup
      base16.setup = function(...)
        local result = setup(...)
        apply_transparency()
        return result
      end
      base16._transparent_background = true
    end

    require("matugen").setup()
    apply_transparency()
  end,
}
