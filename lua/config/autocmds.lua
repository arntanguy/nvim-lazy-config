-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- XXX shouldn't this be a FileType instead?
vim.api.nvim_create_autocmd(
  "FileType",
  {
    group = vim.api.nvim_create_augroup("YAML", { clear = true }),
    pattern = { "yaml" },
    callback = function()
      vim.opt_local.foldmethod = "indent" -- use indent as folding method
      vim.opt_local.foldlevel = 20 -- start unfolded by default
    end,
  }
)

-- ROS
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.launch'}, command = [[ setf xml ]] })
-- GLSL
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.frag','*.vert','*.geom','*gp','*.fp','*.vp','*.glsl'}, command = [[ setf glsl ]] })
-- Opencl
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.cl'}, command = [[ set filetype=opencl ]] })
-- Json
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.conf', '*.conf.json'}, command = [[ set filetype=json ]] })
-- XML
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.rsdf'}, command = [[ set filetype=xml ]] })
-- Markdown
vim.api.nvim_create_autocmd( 
"FileType", {pattern = {'*.md'}, command = [[ set filetype=markdown ]] })
