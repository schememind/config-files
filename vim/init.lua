vim.o.mouse = 'a'             -- Enable mouse support in all modes
vim.bo.swapfile = false       -- Disable backup file creation

-- TODO encodin=utf-8
-- TODO nocompatible
vim.bo.syntax = true
vim.wo.number = true          -- Current line number
vim.wo.relativenumber = true  -- Display relative numbers
vim.o.showcmd = true          -- Always show commands
vim.o.wildmenu = true         -- Autocomplete wild menu
vim.o.showmatch = true        -- Highlight matching parenthesis
vim.o.splitright = true       -- Vertical split to the right
vim.o.splitbelow = true       -- Horizontal split to the bottom
vim.wo.linebreak = true       -- Wrap on word boundary

-- Tabs
vim.bo.expandtab = true       -- Use spaces instead of tabs
vim.bo.tabstop = 4            -- Displayed visual length of tab character
vim.bo.softtabstop = 4        -- Visual indentation length whan TAB is pressed
vim.bo.shiftwidth = 4         -- Automatic indentation after e.g. { symbol
vim.bo.smartindent = true     -- Automatic indentation of new lines
-- TODO filetype indent on

-- Search tweaks
vim.o.incsearch = false       -- Disable incremental search
vim.o.hlsearch = true         -- Highlight previous search patterns
vim.o.ignorecase = true       -- Case insensitive search
vim.o.smartcase = true        -- Switch to case sensitive search when upper case letter is typed

-- Default file browser (netrw) tweaks (from a YouTube talk).
-- Run :Vexplore to open vertical window, simply :Explore for a full-window explorer.
-- Use minus (-) to go up one level, use Enter to expand folder or open a file.
vim.g['netrw_banner'] = 0        -- Remove banner
-- vim.g['netrw_browse_split'] = 4  -- Open in prior view
-- vim.g['netrw_altv'] = 1          -- Open splits to the right
vim.g['netrw_liststyle'] = 3     -- Tree view
vim.g['netrw_winsize'] = 25      -- Set window width to 25 characters

-- Global key mapping
vim.g.mapleader = ' '         -- Use SPACE as leader key
vim.keymap.set('n', '<Leader>e', ':Explore<CR>')

-- Vimscript commands
vim.cmd [[
  colorscheme habamax
  packadd packer.nvim
]]

-- Plugins
return require('packer').startup(function(use)

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Multicursor mode
  -- C-n - next occurrence, C-up/down - multicursor
  use { 'mg979/vim-visual-multi', branch = 'master' }

  -- Advanced bottom panel
  use { 'vim-airline/vim-airline' }

  -- Go to char (<Leader><Leader>s by default. TODO: remap)
  use { 'easymotion/vim-easymotion' }

  -- Search files and inside files
  use { 'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { {'nvim-lua/plenary.nvim'} } }
  local builtin = require('telescope.builtin')
  vim.keymap.set('n', '<Leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<Leader>fg', builtin.live_grep, {})
  vim.keymap.set('n', '<Leader>fb', builtin.buffers, {})
  vim.keymap.set('n', '<Leader>fh', builtin.help_tags, {})
end)
