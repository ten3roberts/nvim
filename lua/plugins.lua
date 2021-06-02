local fn = vim.fn
-- Auto install packer.nvim if not exists
if fn.empty(fn.glob('~/.local/share/nvim/site/pack/packer/start/packer.nvim')) > 0 then
  print 'Downloading packer'
  vim.api.nvim_exec('!git clone https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim', false)
end

vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'rakr/vim-one'
  use 'arcticicestudio/nord-vim'
end
)
