local packer = require("packer")
packer.startup(
  function(use)
    --Packer可以自己管理自己本身
    use 'wbthomason/packer.nvim'
    ---------------------colorschemes-----------------
    use("folke/tokyonight.nvim")
    ------------------------plugins-------------------
    use({ "nvim-tree/nvim-tree.lua", requires = "nvim-tree/nvim-web-devicons" })
    --------------------------------------------------
end)
