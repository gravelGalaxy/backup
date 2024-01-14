# 配置剪贴板
sudo apt install xclip
# 下载最新版的neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
# 编辑环境变量~/.zshrc，将vim转为nvim
alias vim='nvim'

# 将仓库中的nvim配置克隆到~/.config目录下

# 安装Packer.nvim插件管理器
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# 安装或更新插件
在nvim中执行`:PackerSync`命令。

# 安装目录
Neovim标准数据目录：`:h base-directories`
`~/.local/share/nvim`
Packer安装插件的目录：`标准数据目录/site/pack/packer/start`
`~/.local/share/nvim/site/pack/packer/start`

