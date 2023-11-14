问题：在linux中安装fcitx5输入法
1. 安装fcitx5
2. 安装fcitx5中文addon,以及一系列需要的环境。
3. 打开linux上的语言设置，检查是否安装好中文。
4. 打开fcitx5设置，取消选中“只显示当前系统的语言”，找到pinyin
5. 添加到候选语言中，发现此时可以在终端输入中文，而不能在浏览器上输入中文。
6. 添加~/.pam\_environment文件，加入下面的环境变量：
7. 下载gnome-tweaks,将fcitx5添加到开机启动项。
```
GTK_IM_MODULE DEFAULT=fcitx
QT_IM_MODULE  DEFAULT=fcitx
XMODIFIERS    DEFAULT=\@im=fcitx
```


