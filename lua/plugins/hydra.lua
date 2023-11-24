return {
  -- add path to hydra.nvim
  'anuvyklack/hydra.nvim',
  dependencies = {
    -- for telescope
    'nvim-telescope/telescope.nvim',
    'mbbill/undotree',
    'chentoast/marks.nvim',
    -- for window managemeent
    'romgrk/barbar.nvim',
    'sindrets/winshift.nvim',
    'mrjones2014/smart-splits.nvim',
    'anuvyklack/windows.nvim',
  },
  config = function()
    local Hydra = require('hydra')
    local cmd = require('hydra.keymap-util').cmd

    local telescope_hydra = function()
      -- Hydra for telescope
      local telescope_hint = [[
                       _f_: files       _m_: marks
         🭇🬭🬭🬭🬭🬭🬭🬭🬭🬼    _o_: old files   _g_: git files _<C-g>_: live grep
        🭉🭁🭠🭘    🭣🭕🭌🬾   _p_: projects    _/_: search in file
        🭅█ ▁     █🭐
        ██🬿      🭊██   _r_: resume      _u_: undotree
       🭋█🬝🮄🮄🮄🮄🮄🮄🮄🮄🬆█🭀  _h_: vim help    _c_: execute command
       🭤🭒🬺🬹🬱🬭🬭🬭🬭🬵🬹🬹🭝🭙  _k_: keymaps     _;_: commands history
                       _O_: options     _?_: search history
       ^
                       _<Enter>_: Telescope           _<Esc>_
      ]]

      Hydra({
         name = 'Telescope',
         hint = telescope_hint,
         config = {
            color = 'teal',
            invoke_on_body = true,
            hint = {
               position = 'middle',
               border = 'rounded',
            },
         },
         mode = 'n',
         body = '<Leader>f',
         heads = {
            { 'f', cmd 'Telescope find_files' },
            { 'g', cmd 'Telescope git_files' },
            { '<C-g>',  cmd 'Telescope live_grep'},
            { 'o', cmd 'Telescope oldfiles', { desc = 'recently opened files' } },
            { 'h', cmd 'Telescope help_tags', { desc = 'vim help' } },
            { 'm', cmd 'MarksListBuf', { desc = 'marks' } },
            { 'k', cmd 'Telescope keymaps' },
            { 'O', cmd 'Telescope vim_options' },
            { 'r', cmd 'Telescope resume' },
            { 'p', cmd 'Telescope projects', { desc = 'projects' } },
            { '/', cmd 'Telescope current_buffer_fuzzy_find', { desc = 'search in file' } },
            { '?', cmd 'Telescope search_history',  { desc = 'search history' } },
            { ';', cmd 'Telescope command_history', { desc = 'command-line history' } },
            { 'c', cmd 'Telescope commands', { desc = 'execute command' } },
            { 'u', cmd 'silent! %foldopen! | UndotreeToggle', { desc = 'undotree' }},
            { '<Enter>', cmd 'Telescope', { exit = true, desc = 'list all pickers' } },
            { '<Esc>', nil, { exit = true, nowait = true } },
         }
      })
    end
    telescope_hydra()


    local vim_options_hydra = function()
      local vim_options_hint = [[
        ^ ^        Options
        ^
        _v_ %{ve} virtual edit
        _i_ %{list} invisible characters  
        _s_ %{spell} spell
        _w_ %{wrap} wrap
        _c_ %{cul} cursor line
        _n_ %{nu} number
        _r_ %{rnu} relative number
        ^
            ^^^^                _<Esc>_
      ]]


      Hydra({
      name = 'Options',
      hint = vim_options_hint,
      config = {
          color = 'amaranth',
          invoke_on_body = true,
          hint = {
            border = 'rounded',
            position = 'middle'
          }
      },
      mode = {'n','x'},
      body = '<leader>o',
      heads = {
          { 'n', function() vim.o.number = not vim.o.number
          end, { desc = 'number' } },
          { 'r', function()
            if vim.o.relativenumber == true then
                vim.o.relativenumber = false
            else
                vim.o.number = true
                vim.o.relativenumber = true
            end
          end, { desc = 'relativenumber' } },
          { 'v', function()
            if vim.o.virtualedit == 'all' then
                vim.o.virtualedit = 'block'
            else
                vim.o.virtualedit = 'all'
            end
          end, { desc = 'virtualedit' } },
          { 'i', function() vim.o.list = not vim.o.list
          end, { desc = 'show invisible' } },
          { 's', function() vim.o.spell = not vim.o.spell
          end, { exit = true, desc = 'spell' } },
          { 'w', function()
            if vim.o.wrap ~= true then
                vim.o.wrap = true
                -- Dealing with word wrap:
                -- If cursor is inside very long line in the file than wraps
                -- around several rows on the screen, then 'j' key moves you to
                -- the next line in the file, but not to the next row on the
                -- screen under your previous position as in other editors. These
                -- bindings fixes this.
                vim.keymap.set('n', 'k', function() return vim.v.count > 0 and 'k' or 'gk' end,
                                        { expr = true, desc = 'k or gk' })
                vim.keymap.set('n', 'j', function() return vim.v.count > 0 and 'j' or 'gj' end,
                                        { expr = true, desc = 'j or gj' })
            else
                vim.o.wrap = false
                vim.keymap.del('n', 'k')
                vim.keymap.del('n', 'j')
            end
          end, { desc = 'wrap' } },
          { 'c', function() vim.o.cursorline = not vim.o.cursorline end, { desc = 'cursor line' } },
          { '<Esc>', nil, { exit = true } }
      }
      })
    end
    vim_options_hydra()

    local window_management = function()
      local splits = require('smart-splits')
      local pcmd = require('hydra.keymap-util').pcmd

      local buffer_hint = [[
        ^ ^        BarBar Buffer
        ^
        _h_/_l_ Previous/Next
        _H_/_L_ Move Left/Right 
        _p_     Pin
        _d_/_c_/_q_ Close
        _od_/_ol_ Order by directory/language
        ^
            ^^^^                _<Esc>_
      ]]

      Buffer_hydra = Hydra({
        name = 'Barbar',
        hint = buffer_hint,
        mode = "n",
        body = '<leader>bh',
        config = {
            invoke_on_body = true,
            hint = {
              border = 'rounded',
              offset = -1
            },
        },
        heads = {
            { 'h', function() vim.cmd('BufferPrevious') end, { on_key = false } },
            { 'l', function() vim.cmd('BufferNext') end, { desc = 'choose', on_key = false } },

            { 'H', function() vim.cmd('BufferMovePrevious') end },
            { 'L', function() vim.cmd('BufferMoveNext') end, { desc = 'move' } },

            { 'p', function() vim.cmd('BufferPin') end, { desc = 'pin' } },

            { 'd', function() vim.cmd('BufferClose') end, { desc = 'close' } },
            { 'c', function() vim.cmd('BufferClose') end, { desc = false } },
            { 'q', function() vim.cmd('BufferClose') end, { desc = false } },

            { 'od', function() vim.cmd('BufferOrderByDirectory') end, { desc = 'by directory' } },
            { 'ol', function() vim.cmd('BufferOrderByLanguage') end,  { desc = 'by language' } },
            { '<Esc>', nil, { exit = true } }
        }
      })

      local function choose_buffer()
        if #vim.fn.getbufinfo({ buflisted = true }) > 1 then
            Buffer_hydra:activate()
        end
      end

      vim.keymap.set('n', 'gb', choose_buffer)

      local window_hint = [[
      ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
      ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
      ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally 
      _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
      ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_, _c_: close
      focus^^^^^^  window^^^^^^  ^_=_: equalize^   _z_/_<C-z>_: maximize/minimize
      ^ ^ ^ ^ ^ ^  ^ ^ ^ ^ ^ ^   ^^ ^          ^   _o_: remain only
      _b_: choose buffer
      ]]

      Hydra({
        name = 'Windows',
        hint = window_hint,
        config = {
            invoke_on_body = true,
            hint = {
              border = 'rounded',
              offset = -1
            }
        },
        mode = 'n',
        body = '<C-w>',
        heads = {
            { 'h', '<C-w>h' },
            { 'j', '<C-w>j' },
            { 'k', pcmd('wincmd k', 'E11', 'close') },
            { 'l', '<C-w>l' },

            { 'H', cmd 'WinShift left' },
            { 'J', cmd 'WinShift down' },
            { 'K', cmd 'WinShift up' },
            { 'L', cmd 'WinShift right' },

            { '<C-h>', function() splits.resize_left(2)  end },
            { '<C-j>', function() splits.resize_down(2)  end },
            { '<C-k>', function() splits.resize_up(2)    end },
            { '<C-l>', function() splits.resize_right(2) end },
            { '=', '<C-w>=', { desc = 'equalize'} },

            { 's',     pcmd('split', 'E36') },
            { '<C-s>', pcmd('split', 'E36'), { desc = false } },
            { 'v',     pcmd('vsplit', 'E36') },
            { '<C-v>', pcmd('vsplit', 'E36'), { desc = false } },

            { 'w',     '<C-w>w', { exit = true, desc = false } },
            { '<C-w>', '<C-w>w', { exit = true, desc = false } },

            { 'z',     cmd 'WindowsMaximize', { exit = true, desc = 'maximize' } },
            { '<C-z>', cmd 'WindowsMaximize', { exit = true, desc = false } },

            { 'o',     '<C-w>o', { exit = true, desc = 'remain only' } },
            { '<C-o>', '<C-w>o', { exit = true, desc = false } },

            { 'b', choose_buffer, { exit = true, desc = 'choose buffer' } },

            { 'c',     pcmd('close', 'E444') },
            { 'q',     pcmd('close', 'E444'), { desc = 'close window' } },
            { '<C-c>', pcmd('close', 'E444'), { desc = false } },
            { '<C-q>', pcmd('close', 'E444'), { desc = false } },

            { '<Esc>', nil,  { exit = true, desc = false }}
        }
      })
    end
    window_management()
  end
}
