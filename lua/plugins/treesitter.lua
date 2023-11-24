return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = false },
    indent = { enable = false, disable = { "yaml" } }
  },
}
