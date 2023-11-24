return {
  "jbyuki/venn.nvim",
  -- add hydra dependency
  dependencies = { "anuvyklack/hydra.nvim" },
  -- add a function when starting the plugin
  config = function()
    local Hydra = require('hydra')

    -- (◄,▼,▲,►) in utf16: (0x25C4,0x25BC,0x25B2,0x25BA)
    local venn_hint = [[
     Arrow^^^^^^  Select region with <C-v>^^^^^^
     ^ ^ _K_ ^ ^  _f_: Surround with box ^ ^ ^ ^
     _H_ ^ ^ _L_  _<C-h>_: ◄, _<C-j>_: ▼
     ^ ^ _J_ ^ ^  _<C-k>_: ▲, _<C-l>_: ► _<C-c>_
    ]]
    
    -- :setlocal ve=all
    -- :setlocal ve=none
    Hydra {
      name = 'Draw Diagram',
      hint = venn_hint,
      config = {
        color = 'pink',
        invoke_on_body = true,
        hint = {
          border = 'rounded',
        },
        on_enter = function() vim.wo.virtualedit = 'all' end,
      },
      mode = 'n',
      body = '<leader>ve',
      heads = {
        { '<C-h>', 'xi<C-v>u25c4<Esc>' }, -- mode = 'i' somehow breaks
        { '<C-j>', 'xi<C-v>u25bc<Esc>' },
        { '<C-k>', 'xi<C-v>u25b2<Esc>' },
        { '<C-l>', 'xi<C-v>u25ba<Esc>' },
        { 'H', '<C-v>h:VBox<CR>' },
        { 'J', '<C-v>j:VBox<CR>' },
        { 'K', '<C-v>k:VBox<CR>' },
        { 'L', '<C-v>l:VBox<CR>' },
        { 'f', ':VBox<CR>', { mode = 'v' } },
        { '<C-c>', nil, { exit = true } },
      },
    }

  end
}
