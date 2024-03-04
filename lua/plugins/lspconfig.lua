return {
  -- add tsserver and setup with typescript.nvim instead of lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
        -- yamlls will be automatically installed with mason and loaded with lspconfig
        yamlls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        yamlls = function(_, _)
          require("lspconfig").yamlls.setup({
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
          })
          return true
        end,
        clangd = function(_, _)
          -- print("clangd setup")
          require("lspconfig").clangd.setup({
            root_dir = function(fname)
              local util = require("lspconfig.util")
              local root_dir =
                util.root_pattern(
                  "Makefile",
                  "configure.ac",
                  "configure.in",
                  "config.h.in",
                  "meson.build",
                  "meson_options.txt",
                  "build.ninja",
                  ".github")(fname)
                or util.root_pattern("compile_commands.json", "compile_flags.txt")(fname)
                or util.find_git_ancestor(fname)
              -- print("fname is: "..fname)
              -- print("clangd root_dir is: "..root_dir)
              return root_dir
            end,
            capabilities = {
              offsetEncoding = { 'utf-16' } -- for github copilot
            }
          })
          return true
      end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
}
