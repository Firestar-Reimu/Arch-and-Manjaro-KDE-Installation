## **一些有用的命令总结**

### **获取设备信息**

#### **简要信息**

可以使用能显示系统图标的 `neofetch`，在终端中输入：（需要下载 `neofetch` 软件包）

```bash
neofetch
```

或者使用功能更强大的 `inxi`：（需要在 AUR 中下载 `inxi` 软件包）

```bash
sudo inxi -b
```

#### **详细信息**

在终端中输入：

```bash
sudo inxi -Fa
```

#### **操作系统版本**

在终端中输入：

```bash
lsb_release -sirc
```

#### **网络设备**

在终端中输入：

```bash
ip a
```

输出网络设备名称的前两个字母表示设备种类：

`lo` 为回环（loopback），`ww` 为无线广域网（WWAN，负责移动宽带连接），`wl` 为无线局域网（WLAN，负责 Wi-Fi 连接），`en` 为以太网（Ethernet，负责网线连接）

#### **命令行进程查看器**

在终端中输入：

```bash
htop
```

#### **命令行音量调节器**

在终端中输入：

```bash
alsamixer
```

#### **内存大小**

在终端中输入：（默认单位是 KiB，即 1024 字节）

```bash
free
```

**Linux 的内存策略可以参考这个网站：[Linux ate my RAM](https://www.linuxatemyram.com/)**

#### **上一次关机的系统日志**

```bash
journalctl -rb -1
```

### **查看并转换编码**

查看编码的命令为：

```bash
file -i (file_name)
```

其中 `charset` 一栏的输出即为文件编码

转换编码可以使用系统预装的 `iconv`，方法为：

```bash
iconv -f (from_encoding) -t (to_encoding) (from_file_name) -o (to_file_name)
```

该方法适合对文本文件转换编码，对 ZIP 压缩包和 PDF 文件等二进制文件则无法使用

`iconv` 支持的编码格式可以用 `iconv -l` 查看

### **转换图片格式**

这需要 `imagemagick` 软件包，它提供了 `convert` 等命令

例如批量将图片从 PNG 格式转换为 JPG 格式：

```bash
ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'
```

### **查找命令**

`grep` 命令的用法为在文件或命令输出中查找字符串，例如：

```bash
grep (pattern) (file_pattern)
```

即为在当前目录文件名符合 `file_pattern` 的文件中查找字符串 `pattern`

又例如：

```bash
pamac list | grep (pattern)
```

可以查询已安装的软件包中名字含有 `pattern` 的软件包

### **获取命令执行的时间**

使用 `time` 命令在任何命令前面可以获取命令执行的时间：

```bash
time (command)
```

输出有三行：`real` 一行是命令执行的总时间，`user`一行是指令执行时在用户态（user mode）所花费的时间，`sys`一行是指令执行时在内核态（kernel mode）所花费的时间

### **命令行比较两个文件**

可以用 Linux 自带的 `diff` 命令，它可以逐行比较两个文件（如果是二进制文件则直接输出是否存在差异）：

```bash
diff (file_name_1) (file_name_2)
```

这里的文件也可以换成路径，详细用法可以用 `diff --help` 查询

### **批量更改文件名**

可以用 Linux 自带的 `rename` 命令：

```bash
rename -- "(old_name)" "(new_name)" (files)
```

这里的参数 `--` 是为了防止在 `"old_name"` 中出现连字符导致识别错误（将其识别为参数）而添加的

例如将本文件夹下所有文件的文件名中空格改为下划线，即执行：

```bash
rename -- " " "_" ./*
```

详细用法可以用 `rename --help` 查询

### **批量更改文件**

推荐使用 `sed` 命令处理：

```bash
sed -ie 's/(old_string)/(new_string)/g' (files)
```

例如将本地文件下所有 Tab 替换成4个空格：

```bash
sed -ie "s/\t/    /g" ./*
```

替换 Tab 也可以使用更加智能的 Vim 中的 `retab` 功能，它可以自动将不同长度的 Tab 替换成不同长度的空格，保证最终文字依然是对齐的

首先用下列命令在一个 Vim 窗口中打开多个文件

```
vim `find . -type f -name "(files)"`
```

然后执行：

```
:argdo %:retab! | update
```

单个文件则直接执行 `%:retab!` 即可

### **命令行解压 ZIP 压缩包**

建议使用 `unar`（由 `unarchiver` 软件包提供），因为它可以自动检测文件编码（Dolphin 右键菜单默认的 Ark 不具备这个功能，可能导致乱码）：

```bash
unar (file_name).zip
```

### **设置命令别名**

在 `~/.bashrc` 中添加一句 `alias (new_command)=(old-command)`，这样直接输入 `new_command` 即等效于输入 `old_command`

## **美化**

### **自定义壁纸**

桌面壁纸可以在 [pling.com](https://www.pling.com/) 下载

KDE Plasma 每个版本的壁纸可以在这里找到：

[Plasma Workspace Wallpapers -- KDE](https://github.com/KDE/plasma-workspace-wallpapers)

默认的壁纸保存位置为 `/usr/share/wallpapers/`

还可以使用包管理器（pacman/yay/pamac）下载壁纸，用“添加/删除软件”或 `pamac search wallpaper` 查找

右键点击桌面得到桌面菜单，点击“配置桌面和壁纸”即可选择想要的壁纸，位置建议选择“缩放并裁剪”

### **添加用户图标**

系统设置 >> 用户账户 >> 图像

### **开机美化**

系统设置 >> 开机与关机 >> 登录屏幕（SDDM） >> 获取新 SDDM 主题 >> 应用 Plasma 设置

系统设置 >> 外观 >> 欢迎屏幕 >> 获取新欢迎屏幕

#### **SDDM 时间显示调整为 24 小时制**

更改 `/usr/share/sddm/themes/(theme_name)/components/Clock.qml` 或 `/usr/share/sddm/themes/(theme_name)/Clock.qml` 中的 `Qt.formatTime` 一行：

```
text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
```

将其改为：

```
text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "H:mm:ss")
```

保存重启即可

### **主题 Mac 风格美化（可选）**

参考以下网址：

[KDE 桌面的 Mac 化](https://www.cnblogs.com/luoshuitianyi/p/10587788.html)

[KDE 桌面美化指南](https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/)

其中 Plasma 主题、GTK 主题和图标主题推荐选择：

```
Plasma Theme: Mojave-CT
GTK Theme: Mojave-light-alt [GTK2/3]
Icon Theme: La Capitaine
```

Latte-Dock 的推荐设置：

行为：位置 >> 底部，可见性 >> 自动隐藏，延迟 >> 显示 >> none

外观：绝对大小 >> 96，背景大小 >> 10%

**不想使用 Mac 风格主题但又想使用浅色主题时，可以使用 KDE 官方主题 Breeze Light，并将终端（Konsole 和 Yakuake）主题改为“白底黑字”，背景透明度选择 20%**

### **光标主题设置**

已安装的光标主题可以通过以下命令查看：

```bash
find /usr/share/icons ~/.local/share/icons ~/.icons -type d -name "cursors"
```

备用的光标主题可以在 `/usr/share/icons/default/index.theme` 设置：

```
[Icon Theme]
Inherits=(cursor_theme_name)
```

默认的备选是 `Adwaita`，这可能导致光标主题的不统一，可以改为 `breeze_cursors`

### **终端字体效果配置**

打开终端 Konsole：

设置 >> 编辑当前方案 >> 外观 >> Complex Text Layout >> 双向文字渲染

默认关闭连字，勾选“Word mode”和“ASCII 字符”（不勾选“Use the same attributes for whole word”）可以开启连字

### **bash 配置提示符变量**

bash 的配置文件在 `~/.bashrc`，默认提示符变量 PS1 可以设置为如下内容，可以显示用户名、主机名、时间、是否为超级用户，并显示颜色高亮：

```bash
PS1="[\[$(tput sgr0)\]\[\033[38;5;196m\]\u\[$(tput sgr0)\] @ \[$(tput sgr0)\]\[\033[38;5;40m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;208m\]\W\[$(tput sgr0)\]] (\t)\n\[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;196m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
```

说明文档参见以下网站：

[Controlling the Prompt -- Bash Manual](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Controlling-the-Prompt)

更多的 PS1 内容和颜色设置可以在这个网站进行自定义：

[bashrc PS1 generator](https://bashrcgenerator.com/)

### **bash 配置 ble.sh**

[ble.sh](https://github.com/akinomyoga/ble.sh) 是一个使用纯 bash 编写的软件，可以提供代码高亮、自动补全等功能，可以在 AUR 中下载稳定版本：

```bash
yay -S blesh
```

或者开发者版本：

```bash
yay -S blesh-git
```

下载后，需要在 `.bashrc` 文件开头添加：

```bash
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
```

并在末尾添加：

```bash
[[ ${BLE_VERSION-} ]] && ble-attach
```

更多设置和用法参考以下网址：

https://github.com/akinomyoga/ble.sh

### **zsh 与 Oh-My-Zsh 配置**

安装 zsh：

```bash
sudo pacman -S zsh
```

修改 Konsole 默认的 shell 需要如下设置：

Konsole >> 设置 >> 编辑当前方案 >> 常规 >> 命令 >> `usr/bin/zsh`

手动安装 Oh-My-Zsh，执行：（不推荐用包管理器安装）

```bash
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

安装插件，执行：

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

编辑设置文件：

```bash
vim ~/.zshrc
```

选择 Oh-My-Zsh 主题，推荐使用 geoffgarside：

```
ZSH_THEME="geoffgarside"
```

选择 Oh-My-Zsh 插件：

```
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

更新 Oh-My-Zsh，执行：

```
omz update
```

卸载 Oh-My-Zsh，执行:

```
uninstall_oh_my_zsh
```

### **GRUB 美化**

选择主题 grub2-themes，下载地址如下：

https://github.com/vinceliuice/grub2-themes

可选的主题有：Tela/Vimix/Stylish/Slaze/Whitesur

以 Tela grub theme（2K，黑白图标）为例，解压后在文件夹内执行：

```bash
sudo ./install.sh -b -t tela -i white -s 2k
```

删除多余启动条目，需要修改 `/boot/grub/grub.cfg`

删除整一段 `submenu 'Advanced options for Arch Linux'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

恢复默认的 `/boot/grub/grub.cfg` 需要输入：

```bash
echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### **Vim 美化**

Vim 的颜色主题推荐使用 [PaperColor](https://github.com/NLKNguyen/papercolor-theme)，需要将其中的 `PaperColor.vim` 文件复制到 `/usr/share/vim/vim90/colors/`，并在 `/etc/vimrc` 中添加：

```
colorscheme PaperColor
```

默认使用暗色主题，如果要使用亮色主题需要在 `/etc/vimrc` 中添加：

```
set background=light
```

### **pacman 添加吃豆人彩蛋**

编辑 `/etc/pacman.conf`

```bash
sudo vim /etc/pacman.conf
```

去掉 `Color` 前面的注释，并在下一行加入：

```
ILoveCandy
```

即可添加吃豆人彩蛋

### **配置桌面小部件（可选）**

右键点击桌面 >> 添加部件 >> 获取新部件 >> 下载新 Plasma 部件

在这里可以下载桌面小部件，并在“添加部件”处添加

## **软件的下载与配置**

### **PGP 密钥无法导入**

如果导入 PGP 密钥发生 `gpg: keyserver receive failed: General error` 的问题，将 PGP 密钥复制下来并运行：

```bash
gpg --keyserver keyserver.ubuntu.com --recv-keys (pgp_key)
```

再重新安装软件即可

### **安装软件后在开始菜单中找不到图标**

执行命令：

```bash
sudo update-desktop-database
```

### **Kate 语言包下载**

如果在打开 Kate 的时候出现：

```
kf.sonnet.core: No language dictionaries for the language: "en_US"
```

下载 Kate 语言包：

```bash
sudo pacman -S aspell aspell-en
```

### **运行 AppImage 文件或二进制文件**

AppImage 的扩展名为 `.AppImage`，二进制文件没有扩展名，这两者一般可以直接双击或在终端输入文件名运行：

```bash
(file_name)
```

如果无法启动，则需要添加运行权限：

```bash
chmod +x (file_name)
```

然后双击或在终端输入文件名运行即可

### **V2Ray 安装与配置**

可以直接使用包管理器安装（AUR 软件库提供 `v2raya`、`v2raya-bin` 和 `v2raya-git`）

```bash
yay -S v2ray v2raya-bin
```

启动 v2rayA 需要使用 `systemctl`：

```bash
sudo systemctl enable --now v2raya
```

之后 v2rayA 可以开机自启动

注意现在 `v2ray` 升级到 5.x 版本，需要 v2RayA 升级到 2.x 版本，旧的 Qv2ray 已经无法使用，以后可能会迁移到 [sing-box](https://sing-box.sagernet.org/)

之后在 [http://localhost:2017/](http://localhost:2017/) 打开 v2rayA 界面，导入订阅链接或服务器链接（ID 填用户的 UUID，AlterID 填 0，Security 选择 Auto，其余选项均为默认）

右上角“设置”中，按照[推荐方法](https://v2raya.org/en/docs/prologue/quick-start/#transparent-proxy)进行设置，即将“透明代理/系统代理”改为“启用：大陆白名单模式”，“防止DNS污染”改为“仅防止DNS劫持（快速）”，“特殊模式”改为“supervisor”，保存并应用

选择一个节点，点击左上角柚红色的“就绪”按钮即可启动，按钮变为蓝色的“正在运行”

选择左侧的勾选框可以测试节点的网络连接延时

此时系统测试网络连接的功能被屏蔽，可以通过在 `/etc/NetworkManager/conf.d/20-connectivity.conf` 中写入以下内容关闭此功能：

```
[connectivity] 
enabled=false
```

任务栏图标可以在 [v2rayATray](https://github.com/YidaozhanYa/v2rayATray) 下载，即下载 [PKGBUILD](https://github.com/YidaozhanYa/v2rayATray/blob/main/PKGBUILD)，在其所在的文件夹下执行 `makepkg -si` 即可安装

v2rayATray 的命令是 `v2raya_tray`，设置它为开机自启动可以在 KDE Plasma 的“系统设置 >> 开机与关机 >> 自动启动”中设置

**浏览器和 KDE Plasma 的网络连接设置都不需要更改**

### **TeX 安装**

**推荐从 ISO 安装 TeX Live 发行版，速度最快**

首先在[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载 TeX Live ISO，文件名为 `texlive.iso`（和 `texlive(year).iso`、`texlive(year)-(date).iso` 是一致的）

在 Dolphin 中右键点击 ISO 镜像文件挂载（需要 `dolphin-plugins` 软件包），或在终端中运行：

```bash
sudo mount -t iso9660 -o ro,loop,noauto (texlive_path)/texlive.iso /mnt
```

#### **使用命令行界面安装（推荐）**

**安装过程不建议用 sudo**

进入镜像文件夹，运行：

```bash
perl install-tl -gui text
```

用大写字母命令控制安装：

```
C >> 输入字母选择要安装/不安装的软件包集合
D >> 输入数字，选择要安装 TeX Live 的各种位置 >> R
O >> L >> 都选择默认位置（按 Enter） >> R
I
```

`TEXDIR` 建议选择 `/home/(user_name)/` 下的文件夹以方便查看和修改（建议使用绝对路径）

`TEXMFLOCAL` 会随 `TEXDIR` 自动更改

CTAN 镜像源可以使用 TeX Live 包管理器 `tlmgr` 更改

更改到清华大学镜像需要在命令行中执行：

```bash
tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
```

更改到上海交大镜像需要在命令行中执行：

```bash
tlmgr option repository https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/tlnet/
```

#### **使用图形界面安装**

首先要检查是否安装 tcl 和 tk：

```bash
sudo pacman -S tcl tk
```

进入镜像文件夹，运行：

```bash
perl install-tl -gui
```

即可在图形界面下载 TeX Live，高级设置需要点击左下角的 Advanced 按钮

#### **设置 PATH 环境变量**

输入命令 `texconfig conf` 可以查看 TeX Live 的文件夹设置，如 `TEXMFMAIN=(TEXDIR)/texmf-dist`

编辑 `~/.bashrc`，添加一行：

```bash
PATH=(TEXDIR)/bin/x86_64-linux:$PATH
```

可以运行 `tex --version` 检查是否安装成功，若成功应显示 TeX 的版本号、TeX Live 的版本号和版权信息

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc tex`）检查是否安装成功

#### **从安装程序安装**

可以

```bash
perl install-tl -select-repository -gui text
```

#### **biber 报错**

biber 是 biblatex 的默认后端，用来替换过时的 biblatex，如果在运行 biber 的过程中出现以下报错：

```
error while loading shared libraries: libcrypt.so.1: cannot open shared object file: No such file or directory
```

需要安装 `libxcrypt-compat`：

```bash
sudo pacman -S libxcrypt-compat
```

#### **texdoc 报错**

使用 `texdoc (package_name)` 命令获取 LaTeX 宏包的说明文档，如果在运行 `biber` 的过程中出现以下报错：

```
kf.service.services: KApplicationTrader: mimeType "x-scheme-handler/file" not found
```

需要修改 `~/.config/mimeapps.list` 文件，加入：

```
x-scheme-handler/file=okularApplication_pdf.desktop;
```

#### **安装 MathTime Professional 2 字体**

[MathTime Professional 2](https://www.pctex.com/mtpro2.html) 字体是 Type 1 字体，下载后为 `mtp2fonts.zip.tpm` 文件

可以使用以下脚本安装在 Linux 上：

[Mathtime Installer -- GitHub](https://github.com/jamespfennell/mathtime-installer)

下载[脚本](https://github.com/jamespfennell/mathtime-installer/blob/master/mtpro2-texlive.sh)，并安装 `unzip` 软件包，之后执行：

```bash
./mtpro2-texlive.sh -i mtp2fonts.zip.tpm
```

之后可以用 `\usepackage{mtpro2}` 使用 MathTime Professional 2 字体，用 `texdoc mtpro2` 查看文档

### **TeXstudio 安装与配置（可选）**

安装 TeXstudio：

```bash
sudo pacman -S texstudio
```

帮助 >> 检查 LaTeX 安装信息

如果能检测到 LaTeX，说明 TeX Live 安装成功，开始设置

选项 >> 设置 TeXstudio

首先在左下角勾选“显示高级选项”

常规 >> 会话 >> 取消勾选“启动时恢复上一次会话”（可选）

菜单 >> 数学 >> `\frac{}{}` >> `\frac{%|}{}`

菜单 >> 数学 >> `\dfrac{}{}` >> `\dfrac{%|}{}`

快捷键 >> 数学 >> 数学字体格式 >> 罗马字体 >> 当前快捷键 >> `Alt+Shift+R`

编辑器 >> 缩进模式 >> 自动增加或减少缩进

编辑器 >> 缩进模式 >> 勾选“将缩进替换为空格”和“将文本中的制表符（Tab）替换为空格”

编辑器 >> 显示行号 >> 所有行号

编辑器 >> 取消勾选“行内检查”

高级编辑器 >> 自动保存所有文件 >> 1 分钟

高级编辑器 >> 破解/变通 >> 取消勾选“自动选择最佳显示选项”，并勾选“禁用字符宽度缓存”和“关闭固定位置模式”

补全 >> 取消勾选“输入参数”

### **Thunderbird 配置**

#### **Thunderbird 首选项配置**

进入首选项界面调整显示：

首选项 >> 常规 >> Thunderbird 起始页 >> 清空并取消勾选

首选项 >> 常规 >> 默认搜索引擎 >> 改为 Bing

首选项 >> 隐私与安全 >> 邮件内容 >> 勾选“允许消息中的远程内容”

右键点击上方邮件工具栏，选择“自定义”，自行配置即可

#### **Thunderbird 帐号配置**

点击邮箱帐号，配置“账户设置”如下：

服务器 >> 服务器设置 >> 每隔 1 分钟检查一次新消息

服务器 >> 服务器设置 >> 在删除消息时 >> 立即删除

### **GitHub Desktop 安装**

推荐选择二进制包 `github-desktop-bin`：

```bash
yay -S github-desktop-bin gnome-keyring
```

登录时要创建一个密钥环，密钥设为 GitHub 密码即可

### **使用 SSH 连接到 GitHub**

推荐使用 SSH 连接到 GitHub，其安全性更高，访问速度较快且更加稳定

配置参考以下网址：

[GitHub Docs -- 使用 SSH 连接到 GitHub](https://docs.github.com/cn/github/authenticating-to-github/connecting-to-github-with-ssh)

步骤如下：（Linux 上直接用系统终端，Windows 上需要用 Git Bash 而不能用 Windows Terminal，因为缺少 `eval` 等命令）

#### **生成新 SSH 密钥并添加到 ssh-agent**

```bash
ssh-keygen -t ed25519 -C "(user_email)"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

第一步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

#### **新增 SSH 密钥到 GitHub 帐户**

通过 `cat ~/.ssh/id_ed25519.pub` 查看公钥并复制到 Github 账户下的“设置 >> SSH and GPG keys”中

#### **测试 SSH 连接**

在终端中输入：

```
ssh -T git@github.com
```

这一步要输入 `yes` 确定

**注意 Linux 上和 Windows 上用的是不同的密钥，Windows 上操作步骤相同，但需要在 Git Bash（而不是 Windows Powershell）上执行**

### **Python 安装与配置**

Arch Linux 预装了 Python，但没有安装包管理器，可以使用 `pip` 或 `conda`（即安装 Miniconda）

#### **pip 安装**

在终端中输入：

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
```

即可安装 pip，此时不建议安装 conda，pip 下载包的命令是：

```bash
pip install (package_name)
```

这里不建议安装 Spyder，安装最基本的包即可：

```bash
pip install numpy matplotlib astropy black ipython
```

使用 Matplotlib 绘图需要下载 tk 库：

```bash
sudo pacman -S tk
```

#### **Miniconda 安装**

Miniconda 是 Anaconda 的精简版，推荐使用 Miniconda

下载地址如下：

[Miniconda -- Conda documentation](https://docs.conda.io/en/latest/miniconda.html)

或者在[清华大学镜像站](https://mirrors.tuna.tsinghua.edu.cn/#)点击右侧的“获取下载链接”按钮，在“应用软件” >> Conda 里面选择

安装过程参考以下网址：（Miniconda 和 Anaconda 的安装步骤相同）

[Anaconda Documentation -- Installing on Linux](https://docs.anaconda.com/anaconda/install/linux/)

如果使用 `zsh`，需要用 `zsh` 执行安装文件：

```bash
zsh ./Miniconda3-latest-Linux-x86_64.sh
```

并手动在 `~/.zshrc` 中添加 PATH（`miniconda_path` 为 Miniconda 的安装位置）：

```bash
export PATH=(miniconda_path)/bin:$PATH
```

最后用 `source ~/.zshrc` 刷新设置

#### **Miniconda 配置软件源**

输入以下命令：（Windows 用户无法直接创建名为 `.condarc` 的文件，可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改）

```bash
vim ~/.condarc
```

修改 `~/.condarc` 以使用清华大学镜像：

```
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

或上海交大镜像：

```
channels:
  - defaults
default_channels:
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/main
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/r
  - https://mirror.sjtu.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirror.sjtu.edu.cn/anaconda/cloud/
  pytorch: https://mirror.sjtu.edu.cn/anaconda/cloud/
```

若不用特定的镜像，改为默认值：

```
channels:
  - defaults
ssl_verify: true
```

下载所需要的包：

```bash
conda install numpy matplotlib astropy black ipython
```

各个操作系统平台上可下载的包可以在以下网站查询：

[Anaconda Documentation -- Anaconda Package Lists](https://docs.anaconda.com/anaconda/packages/pkg-docs/)

#### **Conda 常用命令**

列出所有下载的包：

```bash
conda list
```

添加软件源：

```bash
conda config --add channels (channel_URL)
```

下载包：

```bash
conda install (package_name)
```

下载特定版本的包：

```bash
conda install (package_name)=(version_number)
```

下载 [conda-forge](https://conda-forge.org/) 中的软件：

```bash
conda install -c conda-forge (package_name)
```

更新包：（`pip` 没有 `update` 选项，相应命令为 `pip install --upgrade (package_name)`）

```bash
conda update (package_name)
```

更新所有包：（`pip` 不支持更新所有包，但可以用 `pip list --outdated` 列出所有过期包再一个个更新）

```bash
conda update --all
```

删除所有旧版本的包：

```bash
conda clean -p
```

列出并恢复之前的版本：

```bash
conda list --revisions
conda install --revision (revision_number)
```

如果回滚到早期版本（`revision_number` 较小）之后又想回到某个高版本（`revision_number` 较大），必须要把两个版本中的版本都装一遍

列出所有的环境：

```bash
conda env list
```

创建新环境：

```bash
conda create -n (environment_name)
```

Conda 默认会在 Miniconda/Anaconda 的安装位置创建一个 `base` 环境

激活环境：

```bash
source activate (environment_name)
```

取消激活环境：

```bash
source deactivate (environment_name)
```

删除环境：

```bash
conda env remove -n (environment_name)
```

#### **加入 AstroConda 软件源**

在终端中输入：

```bash
conda config --add channels http://ssb.stsci.edu/astroconda
```

这相当于在 `~/.condarc` 中 `channels` 一栏改为：

```
channels:
  - defaults
  - http://ssb.stsci.edu/astroconda
```

这样就可以下载 `wcstools` 等软件

#### **下载 JupyterLab**

可以通过 `pip` 下载：

```bash
pip install jupyterlab
```

或者在 conda-forge 中下载：

```bash
conda install -c conda-forge jupyterlab
```

下载后用 `jupyter-lab` 命令在浏览器中打开（注意中间的连字符）

#### **下载 photutils**

需要在 conda-forge 中下载：

```bash
conda install -c conda-forge photutils
```

#### **Spyder 下载与配置**

推荐使用 `conda` 下载，在 conda-forge 中有最新的版本：

```bash
conda install -c conda-forge spyder
```

Spyder 配置如下：

通用 >> 显示器分辨率 >> 自定义高分辨率缩放 >> 1.0

编辑选定的方案：

文本：

```
普通文本 #000000
注释：#999999, B
字符串：#00aa00
数值：#aa0000
关键字：#ff5500, B
内置：#990099
定义：#0000ff
实例：#ff55ff, B
```

高亮：

```
当前 Cell：#ffaaff
当前行：#aaffff
事件：#ffff00
匹配圆括号：#99ff99
不匹配圆括号：#ff9999
链接：#55ff00
```

编辑器 >> 勾选“显示标签栏”、“显示缩进指导”、“显示行号”、“高亮显示当前行”、“高亮显示当前 Cell”，并把“高亮延迟时间”设定为 100 毫秒

用 Spyder 打开某个文件需要在终端中输入：

```bash
spyder (file_path)/(file_name)
```

Spyder 会在 `~/.config/spyder-py3` 中创建初始文件 `temp.py`

如果使用 Anaconda/Miniconda 安装 Spyder，需要用 conda 安装 `fcitx-qt5` 才能支持 Fcitx/Fcitx5 输入中文字符：

```
conda install -c conda-forge fcitx-qt5
```

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用 `code` 命令打开（缺点是图标被重新设计过，且更新略微落后于微软官方版）：

```bash
sudo pacman -S code
```

微软官方的二进制包（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯 Code - OSS 的图标，个人推荐首选此项）：

```bash
yay -S visual-studio-code-bin
```

内测版本：

```bash
yay -S visual-studio-code-insiders-bin
```

第三方发布的从开源代码构建的二进制包：

```bash
yay -S vscodium-bin
```

从最新的开源代码构建：

```bash
yay -S vscodium-git
```

下载扩展：Python（会自动下载 Pylance、Jupyter 等扩展），LaTeX Workshop，C/C++，Markdown all in One，Prettier - Code formatter

扩展保存在 `~/.vscode/extensions/` 文件夹内

#### **Visual Studio Code 设置**

若要更改全局设置，设置文件在 `~/.config/Code/User/settings.json`，可以在 Visual Studio Code 中按 `Ctrl+,` 开启设置

若要更改全局快捷键，设置文件在 `~/.config/Code/User/keybindings.json`，可以在 Visual Studio Code 中按 `Ctrl+K Ctrl+S` 开启设置

#### **Visual Studio Code 连字设置**

在 `setting.json` 中关闭连字：

```json
"editor.fontLigatures": false,
```

Fira Code 的连字可以设置为：

```json
"editor.fontFamily": "Fira Code",
"editor.fontLigatures": "'calt' off, 'cv16', 'ss01', 'ss03', 'ss05', 'zero'",
```

#### **Visual Studio Code 无法识别 Git 存储库**

如果 Visual Studio Code 无法识别文件夹内的 Git 存储库（显示“当前打开的文件夹中没有 Git 存储库”），是因为 Git 认为该文件夹不安全，需要对该文件夹执行：

```bash
git config --global --add safe.directory (directory_path)
```

`(directory_path)` 不能用 `./` 或 `../`，最好用绝对路径

文件夹安全性状态可以通过 `git status` 查看

如果要完全跳过检查，执行：

```bash
git config --global --add safe.directory "*"
```

#### **Visual Studio Code 图标更改（可选）**

如果图标美化后 Visual Studio Code 图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 >> 编辑应用程序 >> Visual Studio Code >> 点击图标更改 >> 其他图标

其图标位置在 `/usr/share/icons/visual-studio-code.png`

#### **Visual Studio Code 缩放比例（可选）**

放大比例：`Ctrl+=`

缩小比例：`Ctrl+-`

### **Visual Studio Code 插件配置**

#### **Latex Workshop 插件设置**

若想在 [LaTeX Workshop](https://github.com/James-Yu/LaTeX-Workshop) 里面添加 `\frac{}{}` 命令的快捷键为 `Ctrl+M Ctrl+F`，则添加一段：

```json
{
    "key": "ctrl+m ctrl+f",
    "command": "editor.action.insertSnippet",
    "args": { "snippet": "\\frac{$1}{$2}$0" },
    "when": "editorTextFocus && !editorReadonly && editorLangId =~ /latex|rsweave|jlweave/",
}
```

若要更改行间公式 `\[\]` 的自动补全（公式独占一行），在 `~/.vscode/extensions/james-yu.latex-workshop-(version_number)/data/commands.json` 中找到 `"command": "["` 一段（即“display math”），将 `"snippet"` 的值改为：

```json
"[\n\t${1}\n\\]"
```

重启 Visual Studio Code 即可生效

#### **Markdown All in One 插件设置**

Visual Studio Code 自带 Markdown 预览功能，但是不支持快捷键（如粗体、斜体）、数学命令的补全（只支持预览），也不支持复选框：

```
- [x] item 1
- [ ] item 2
```

[Markdown All in One](https://github.com/yzhang-gh/vscode-markdown) 提供了粗体、斜体等的快捷键，对数学公式补全支持较好，也支持复选框，缺点是不支持自动补全配对括号（在设置中将所有语言的括号自动配对打开即可），即在 `setting.json` 中设置为：

```json
"editor.autoClosingBrackets": "always",
"markdown.extension.math.enabled": false,
```

而 Markdown 预览支持最好的插件是 [Markdown Preview Enhanced](https://github.com/shd101wyy/markdown-preview-enhanced)，使用时可以选择插件预览或默认预览

### **JetBrains Fleet 安装**

JetBrains Fleet 已经在 AUR 上打包：

```bash
yay -S jetbrains-fleet
```

### **Typora 美化**

#### **源代码模式**

更改 `/usr/share/typora/resources/style/base-control.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base-control.css`）

找到 `.CodeMirror.cm-s-typora-default div.CodeMirror-cursor` 一行，将光标宽度改为 `1px`，颜色从 `#e4629a` 改为 `#000000`

更改 `/usr/share/typora/resources/style/base.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base.css`）

找到 `:root` 一行，将 `--monospace` 改成自己想要的等宽字体

#### **主题渲染模式**

在 `/home/(user_name)/.config/Typora/themes/` 中自己写一个 CSS 文件（可以复制其中一个默认主题，重命名后更改）

找到 `body` 一行，将 `font-family` 改成自己想要的字体

找到 `tt` 一行，将 `font-family` 改成自己想要的等宽字体（`monospace`）

### **SAOImageDS9 安装**

AUR 中有 `ds9` 和 `ds9-bin` 两个版本，推荐选择二进制包 `ds9-bin`：

```bash
yay -S ds9-bin
```

如果出现这样的错误导致 SAOImageDS9 无法打开或闪退：

```
application-specific initialization failed: unknown color name "BACKGROUND"
Unable to initialize window system.
```

在终端中输入：

```bash
xrdb -load /dev/null
xrdb -query
```

即可解决

### **IRAF/PyRAF 安装**

#### **从源代码安装（推荐）**

从源代码安装 IRAF/PyRAF 较为复杂，但软件版本较新，且支持 Python 3

首先从 GitHub 上下载软件源代码，网址如下：

[IRAF -- GitHub](https://github.com/iraf-community/iraf)

新建一个文件夹，例如 `~/.iraf-source` 用于存放解压后得到的源代码

进入 `~/.iraf-source`，首先运行安装脚本：

```bash
./install
```

这里的选项全部选择默认即可，此时会新建一个 `~/.iraf` 文件夹

下一步是将 IRAF 添加到 PATH：

```bash
export PATH=/home/(user-name)/.iraf/bin/:$PATH
```

此时便可以在 `~/.iraf-source` 中编译安装 IRAF（这一步需要的时间较长）：

```bash
make linux64
make sysgen 2>&1 | tee build.log
```

接下来安装 PyRAF：

```bash
pip install pyraf
```

**在使用 IRAF/PyRAF 之前，需要在该文件夹运行 `mkiraf` 命令，才能使用**

#### **从 AstroConda 安装**

从 AstroConda 安装 IRAF/PyRAF 较为简便，缺点是软件版本较旧（仍是 PyRAF 2.1.15），且依赖 Python 2.7

首先需要用 `conda config --add channels http://ssb.stsci.edu/astroconda` 加入 AstroConda 软件源，并推荐单独建立一个 IRAF 环境 `(iraf_environment)` 安装 IRAF/PyRAF：

```bash
conda create -n (iraf_environment) python=2.7 iraf-all pyraf-all stsci
source activate (iraf_environment)
```

#### **IRAF/PyRAF 常用命令**

启动 IRAF：

```bash
cl
```

启动 PyRAF：

```bash
pyraf
```

退出 IRAF：

```
logout
```

退出 PyRAF：

```
exit()
```

启动参数编辑器（the EPAR Parameter Editor）的命令为：

```
epar (task_name)
```

### **Geant4 安装**

#### **从源代码安装 Geant4**

从官网上下载源代码压缩包：

[Geant4 -- Download](https://geant4.web.cern.ch/support/download)

进入解压后的文件夹

若要将 Geant4 安装在 `(Geant4_directory)`，例如 `~/Geant4`，执行：

```bash
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=(Geant4_directory) -DGEANT4_USE_OPENGL_X11=ON -DGEANT4_USE_QT=ON -DGEANT4_INSTALL_DATA=ON -DGEANT4_BUILD_MULTITHREADED=ON ..
make -j8
make install
```

在 `~/.bashrc` 中添加一行：

```bash
source (Geant4_directory)/bin/geant4.sh
```

#### **检验是否安装成功**

打开 `(Geant4_directory)/share/Geant4-(version_number)/examples/basic/B1`，执行：

```bash
mkdir build
cd build
cmake ..
make -j8
./exampleB1
```

如果出现图形交互界面，说明安装成功

### **微信安装（可选）**

微信官方原生桌面版（原生适配高分辨率屏幕，不需要 wine/deepin-wine 即可运行；但是功能较少，不支持截屏和“订阅号消息”，显示 emoji 需要下载 `noto-fonts-emoji`）：

```bash
yay -S com.tencent.weixin
```

功能较多，和最新的 Windows 电脑版同步更新，但依赖 deepin-wine，且暂不支持“截屏时隐藏当前窗口”的版本：

```bash
yay -S deepin-wine-wechat
```

#### **deepin-wine-wechat 高分辨率适配调整**

用命令 `/opt/apps/com.qq.weixin.deepin/files/run.sh winecfg` 调出 Wine Configuration，对于 200% 的放大率：

Graphics >> Screen Resolution >> 192 dpi

其余基于 Deepin Wine 的软件（如腾讯会议 `com.tencent.deepin.meeting`）也是类似的处理方法，将 `com.qq.weixin.deepin` 换成对应的文件夹名称即可（都在 `/opt/apps/` 目录下）

### **会议软件安装（可选）**

#### **腾讯会议**

推荐安装官方原生的腾讯会议 Linux 版：

```bash
yay -S wemeet-bin
```

也有基于 Deepin Wine 的版本可供选择：

```bash
yay -S com.tencent.deepin.meeting
```

#### **钉钉**

```bash
yay -S dingtalk-bin
```

高分辨率可以点击头像 >> 设置 >> 全局缩放，选择 150%

#### **Zoom**

```bash
yay -S zoom
```

#### **Microsoft Teams**

```bash
yay -S teams
```

#### **Slack**

```bash
yay -S slack-desktop
```

### **音乐软件安装（可选）**

#### **网易云音乐**

```bash
yay -S netease-cloud-music
```

#### **QQ 音乐**

```bash
yay -S qqmusic-bin
```

默认是暗色主题，右上角皮肤键（衣服图案）可以更改为亮色主题

### **办公软件安装（可选）**

WPS 安装：

```bash
yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
```

LibreOffice 安装：

```bash
yay -S libreoffice-fresh
```

### **百度网盘安装（可选）**

```bash
yay -S baidunetdisk-bin
```

### **BitTorrent 客户端安装（可选）**

推荐使用 KDE 官方客户端 KTorrent：

```bash
yay -S ktorrent
```

或者同样功能强大且跨平台的 qBittorrent：

```
yay -S qbittorrent
```

### **应用程序的快捷键配置（可选）**

应用程序的快捷键配置在：

系统设置 >> 快捷键

若没有想要的应用程序，可以点击下方的“添加应用程序”，例如设置 `Meta+Return`（即“Windows 徽标键 + Enter 键”）为启动 Konsole 的快捷键：

系统设置 >> 快捷键 >> 添加应用程序 >> Konsole >> Konsole 的快捷键设为 `Meta+Return`

### **用 debtap 安装 `.deb` 包（不推荐）**

首先要下载并更新 debtap 包：

```bash
yay -S debtap
sudo debtap -u
```

**运行 `sudo debtap -u` 时建议连接北京大学校园网**

进入含有 `.deb` 安装包的文件夹，输入：

```bash
sudo debtap (package_name).deb
```

系统会询问三个问题：文件名随便写，协议写软件包所用的协议，编辑文件可以直接按 `Enter` 跳过

此处会生成一个 `tar.zst` 包，双击打开（右键用“软件安装程序”打开）即可安装