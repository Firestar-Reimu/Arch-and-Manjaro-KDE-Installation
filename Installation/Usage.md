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

#### **内核版本**

在终端中输入：

```bash
uname -a
```

#### **操作系统版本**

在终端中输入：（需要 `lsb-release` 软件包）

```bash
lsb_release -a
```

### **文件权限与属性**

#### **查看文件权限与属性**

查看当前目录下所有文件（包括目录文件，即文件夹）的权限与属性：

```bash
ls -l
```

输出部分开头由 10 位字母或 `-` 符号组成，如 `drwxr-xr-x`

第一个字母代表文件类型，`d` 表示目录文件，`-` 表示普通文件

后面 9 个字母代表文件的权限：第 1-3 个字母代表所有者对文件的权限，第 4-6 个字母代表用户组对该文件的权限，第 7-9 个字母代表所有其他用户对该文件的权限

其中 `r` 代表读取权限，`w` 代表修改权限，`x` 代表执行权限（非可执行文件，如文本文件，本身就没有执行权限），`-` 代表没有该类型的权限

#### **修改文件权限**

在终端里使用 `chmod` 命令可以修改文件权限：

```bash
chmod (who)=(permissions) (file_name)
```

其中的 `(who)` 是一个或者多个字母，可以是 `u`（所有者）、`g`（用户组）、`o`（所有其他用户）、`a`（以上所有，等价于 `ugo`）

权限 `(permissions)` 用 `r`、`w`、`x` 表示

中间的 `=` 符号是覆盖性的，`chmod` 命令允许使用 `+` 或 `-` 从现有集合中添加和减去权限，例如：

```bash
chmod u+x (file_name)
```

可以给文件添加所有者的可执行权限

`chmod` 也可以用数字来设置权限，此时 `r=4`、`w=2`、`x=1`，如 `rwxr-xr-x` 等于 `755`，这样可以同时编辑所有者、用户组和其他用户的权限：

```bash
chmod 755 (file_name)
```

大多数目录被设置为 `755`，以允许所有者读取、写入和执行，但拒绝被其他所有人写入

非可执行的文件通常是 `644`，以允许所有者读取和写入，但允许其他所有人读取，可执行文件则为 `744`

如果要递归修改，可以加入 `-R` 参数

更多设置和用法参考以下网址：

[File permissions and attributes -- ArchWiki](https://wiki.archlinux.org/title/File_permissions_and_attributes)

#### **修改文件用户组**

在终端里使用 `chgrp` 命令可以修改文件所属的用户组：

```bash
chgrp (group_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

#### **修改文件所有者**

在终端里使用 `chown` 命令可以修改文件所有者：

```bash
chown (user_name) (file_name)
```

如果要递归修改，可以加入 `-R` 参数

也可以同时修改所有者和用户组：

```bash
chown (user_name):(group_name) (file_name)
```

### **命令行进程查看器**

在终端中输入：

```bash
top
```

或者使用功能更强大，有颜色高亮的 `htop`：

```bash
htop
```

### **内存使用情况**

`free` 显示系统中已用和未用的物理内存和交换内存、共享内存和内核使用的缓冲区的总和

在终端中输入：（默认单位是 KiB，即 1024 字节）

```bash
free
```

**Linux 的内存策略和使用指南可以参考这个网站：[Linux ate my RAM](https://www.linuxatemyram.com/)**

### **上一次关机的系统日志**

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

### **PDF 与图片之间的转换**

#### **将 PDF 转换为多个图片**

第一种方法是用 `poppler` 软件包提供的 `pdftoppm` 命令：（推荐）

```bash
pdftoppm -png -r (resolution) (pdf_name) (image_name)
```

分辨率 `(resolution)` 默认为 150 DPI，可以调整为更高的 300、600 等

转化为 JPG 图片的命令为：

```bash
pdftoppm -jpeg -r (resolution) (pdf_name) (image_name)
```

第二种方法是用 `imagemagick` 软件包提供的 `convert` 命令：（图片质量不如第一种方法）

```bash
convert -density (resolution) -quality 100 (pdf_name) (image_name)
```

分辨率 `(resolution)` 至少为 300（单位为 DPI），压缩质量推荐选择 100，`(image_name)` 加入扩展名即可自动按照扩展名输出相应格式的图片

#### **将多个图片转换为 PDF**

使用 `img2pdf` 软件包提供的 `img2pdf` 命令：（强烈推荐，速度快）

```bash
img2pdf -o (pdf_name) (image_name)
```

这个命令还可以指定 PDF 页面大小：

```bash
img2pdf -o (pdf_name) --pagesize (page_size) (image_name)
```

其中 `(page_size)` 可以输入 `A4`、`B5`、`Letter` 等，也可以输入自定义的数字如 `10cmx15cm`

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

输出有三行：`real` 一行是命令执行的总时间，`user` 一行是指令执行时在用户态（user mode）所花费的时间，`sys` 一行是指令执行时在内核态（kernel mode）所花费的时间

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

### **将 Tab 替换为空格**

推荐使用 `expand` 命令，它可以自动将不同长度的 Tab 替换成对应数量的空格，保证最终文字依然是对齐的

```bash
expand -t 4 (file_name)
```

这样可以将文件中所有的 Tab 替换为 4 个空格（这里的 4 也可以改为其它数字），此时会把替换后的文件内容输出到命令行终端，需要复制到源文件内容中

替换 Tab 也可以使用 Vim 中的 `retab` 功能，用 Vim 打开文件后默认进入命令模式，输入：

```text
:set tabstop=4
:set expandtab
:%retab!
```

第一步设定一个 Tab 的长度等于 4 个空格，第二步设定从 Tab 替换为空格（反之则为 `:set noexpandtab`），第三步将文件中所有的 Tab 替换为对应数量的空格

### **归档、压缩与解压缩**

参考以下网址：

[Archiving and compression -- ArchWiki](https://wiki.archlinux.org/title/Archiving_and_compression)

#### **zip 格式**

压缩需要用 `zip` 命令（需要单独安装 `zip` 软件包）：

```bash
zip (archive_name).zip (file_name)
```

这里的 `(file_name)` 可以是单个或多个文件，下同

解压默认使用 `unzip` 命令（需要单独安装 `unzip` 软件包）：

```bash
unzip (archive_name).zip
```

如果压缩文件编码不是 UTF-8，可能会导致文件名乱码，此时可以指定为其它编码例如 GBK 编码：

```bash
unzip -O gbk (archive_name).zip
```

这里建议使用 `unar`（由 `unarchiver` 软件包提供）解压，因为它可以自动检测文件编码：

```bash
unar (archive_name).zip
```

#### **rar 格式**

压缩需要用 `rar` 命令（需要从 AUR 安装 `rar` 软件包）：

```bash
rar a (archive_name).rar (file_name)
```

解压时则将参数 `a` 换成 `x`：

```bash
rar x (archive_name).rar
```

也可以用 `unarchiver` 软件包提供的 `unar` 命令解压：

```bash
unar (archive_name).rar
```

#### **tar 格式**

归档文件（不压缩）时使用 `tar` 命令：

```bash
tar -cvf (archive_name).tar (file_name)
```

解开归档文件时使用：

```bash
tar -xvf (archive_name).tar
```

此处的 `-c` 参数表示创建归档文件（create）；`-v` 参数表示显示详细信息（verbose），即被归档或解压的每一个文件的名字；`-f` 参数表示归档文件的文件名（不是被归档文件的文件名），解开时则为压缩包的文件名；`-x` 参数表示解开归档文件（extract）

#### **tar.gz 格式**

压缩命令：（其中 `-z` 表示通过 gzip 压缩或解压）

```bash
tar -czvf (archive_name).tar.gz (file_name)
```

解压命令：

```bash
tar -xzvf (archive_name).tar.gz
```

实际上 `tar` 可以自动识别压缩格式，所以可以使用如下命令（下同）：

```bash
tar -xvf (archive_name).tar.gz
```

#### **tar.xz 格式**

压缩命令：（其中 `-J` 表示通过 xz 压缩或解压）

```bash
tar -cJvf (archive_name).tar.xz (file_name)
```

解压命令：

```bash
tar -xJvf (archive_name).tar.xz
```

#### **tar.bz2 格式**

压缩命令：（其中 `-j` 表示通过 bzip2 压缩或解压）

```bash
tar -cjvf (archive_name).tar.bz2 (file_name)
```

解压命令：

```bash
tar -xjvf (archive_name).tar.bz2
```

#### **gz 格式**

压缩命令：

```bash
gzip (file_name)
```

解压命令：（`gzip -d` 也可以替换为 `gunzip`）

```bash
gzip -d (file_name).gz
```

例如 gzip 压缩的 FITS 文件，其后缀是 `.fits.gz`，此时可以用 `gzip -d` 解压，得到 `.fits` 格式的文件

### **设置命令别名**

在 `~/.bashrc` 中添加一句 `alias (new_command)=(old-command)`，这样直接输入 `new_command` 即等效于输入 `old_command`

## **美化**

### **自定义壁纸**

桌面壁纸可以在 [pling.com](https://www.pling.com/) 下载

KDE Plasma 每个版本的壁纸可以在这里找到：

[Plasma Workspace Wallpapers -- KDE](https://github.com/KDE/plasma-workspace-wallpapers)

默认的壁纸保存位置为 `/usr/share/wallpapers/`

还可以使用包管理器（pacman/yay/pamac）下载壁纸

右键点击桌面得到桌面菜单，点击“配置桌面和壁纸”即可选择想要的壁纸，位置建议选择“缩放并裁剪”

#### **SDDM 时间显示调整为 24 小时制**

更改 `/usr/share/sddm/themes/(theme_name)/components/Clock.qml` 或 `/usr/share/sddm/themes/(theme_name)/Clock.qml` 中的 `Qt.formatTime` 一行：

```text
text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
```

将其改为：

```text
text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "H:mm:ss")
```

保存重启即可

### **主题 Mac 风格美化（可选）**

参考以下网址：

[KDE 桌面的 Mac 化](https://www.cnblogs.com/luoshuitianyi/p/10587788.html)

[KDE 桌面美化指南](https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/)

其中 Plasma 主题、GTK 主题和图标主题推荐选择：

```text
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

```text
[Icon Theme]
Inherits=(cursor_theme_name)
```

默认的备选是 `Adwaita`，这可能导致光标主题的不统一，可以改为 `breeze_cursors`

### **终端字体效果配置**

打开终端 Konsole：

设置 >> 编辑当前方案 >> 外观 >> 复杂文本布局 >> 双向文字渲染

默认关闭连字，勾选“单词模式”和“ASCII 字符”（不勾选“对整个单词使用相同的属性”）可以开启连字

### **bash 配置提示符变量**

bash 的配置文件在 `~/.bashrc`，默认提示符变量 PS1 可以设置为如下内容：

```bash
PS1="[\e[0;36m\u\e[0m @ \e[0;32m\h\e[0m \W] (\e[0;35m\t\e[0m)\n\e[1;31m\$\e[0m "
```

显示了用户名、主机名、时间、是否为超级用户，并带有颜色高亮

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

之后在用户目录 `/home/(user_name)` 下创建文件 `.blerc`，写入：

```text
bleopt canvas_winch_action=redraw-prev
bleopt exec_elapsed_enabled=1
```

更多设置和用法参考以下网址：

[ble.sh -- GitHub](https://github.com/akinomyoga/ble.sh)

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

```text
ZSH_THEME="geoffgarside"
```

选择 Oh-My-Zsh 插件：

```text
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

更新 Oh-My-Zsh，执行：

```text
omz update
```

卸载 Oh-My-Zsh，执行:

```text
uninstall_oh_my_zsh
```

### **GRUB 美化**

#### **安装 GRUB 主题**

选择主题 grub2-themes，下载地址如下：

[grub2-themes -- GitHub](https://github.com/vinceliuice/grub2-themes)

可选的主题有：Tela/Vimix/Stylish/Slaze/Whitesur

以 Tela grub theme（2K，黑白图标）为例，解压后在文件夹内执行：

```bash
sudo ./install.sh -b -t tela -i white -s 2k
```

#### **修改启动条目**

删除多余启动条目，需要修改 `/boot/grub/grub.cfg`

删除整一段 `submenu 'Advanced options for Arch Linux'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

**注意之后不要再执行 `grub-mkconfig`，否则会覆盖更改**

#### **恢复默认的 GRUB 设置**

恢复默认的 `/boot/grub/grub.cfg` 需要输入：

```bash
echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### **Vim 美化**

Vim 的颜色主题推荐使用 [PaperColor](https://github.com/NLKNguyen/papercolor-theme)，需要将其中的 `PaperColor.vim` 文件复制到 `/usr/share/vim/vim90/colors/`，并在 `/etc/vimrc` 中添加：

```text
colorscheme PaperColor
```

默认使用暗色主题，如果要使用亮色主题需要在 `/etc/vimrc` 中添加：

```text
set background=light
```

### **pacman 添加吃豆人彩蛋**

编辑 `/etc/pacman.conf`

```bash
sudo vim /etc/pacman.conf
```

去掉 `Color` 前面的注释，并在下一行加入：

```text
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

### **生成 SSH 密钥**

首先安装 OpenSSH：

```bash
sudo pacman -S openssh
```

生成一个 SSH 密钥默认使用兼容性最好的 RSA 算法，现在推荐使用更安全的 ED25519 算法：

```bash
ssh-keygen -t ed25519 -C "(user_email)"
```

第一步生成私钥，会询问 `Enter file in which to save the key`，默认是 `~/.ssh/id_ed25519`，可以改为别的位置和名字，如 `(ssh_folder)/(key_name)`

第二步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

这样创建的私钥位置为 `(ssh_folder)/(key_name)`，公钥位置为 `(ssh_folder)/(key_name).pub`

如果 SSH 密钥不在默认的 `~/.ssh`，则需要创建设置文件 `~/.ssh/config`（这个文件必须在 `~/.ssh/` 文件夹内）并写入：

```text
IdentityFile (ssh_folder)/(key_name)
```

注意如果 `(ssh_folder)` 中含有空格，需要用 `\ ` 即反斜杠进行转义

### **向 AUR 提交软件包**

#### **连接 AUR 仓库**

需要使用 SSH 连接 AUR 仓库

复制 `~/(ssh_folder)/.ssh/aur.pub` 的内容（至少包括前缀 `ssh_ed25519` 和公钥的随机字符串），粘贴到 AUR 的“My Account >> SSH 密钥”一节，输入密码以更新账号设置

在 `~/.ssh/config` 中为 AUR 指定 SSH 私钥的位置，即写入：

```text
Host aur.archlinux.org
User (user_name)
IdentityFile (ssh_folder)/(key_name)
```

#### **创建软件包仓库**

如果要创建新的软件包，通过克隆所需的 [pkgbase](https://wiki.archlinux.org/title/PKGBUILD#pkgbase) 的方式建立一个远程 AUR 仓库和本地 Git 仓库：（必须用 SSH 地址，需要登录 AUR 后才能看到）

```bash
git clone ssh://aur@aur.archlinux.org/(package_name).git
```

如果软件包还不存在，则会出现警告：

```text
warning: You appear to have cloned an empty repository.
```

这不影响后续操作

#### **提交和更新软件包**

**要上传或者更新一个软件包，至少要添加 `PKGBUILD` 和 `.SRCINFO`，以及其他所有新增的或者修改过的辅助文件（例如 `.install` 文件或补丁等本地源码文件）**

生成 `.SRCINFO` 的方法如下

```bash
makepkg --printsrcinfo > .SRCINFO
```

添加文件并提交，最后推送这些变动到 AUR 上：

```bash
git add PKGBUILD .SRCINFO
git commit -m (commit_message)
git push
```

### **Kate 语言包下载**

如果在打开 Kate 的时候出现：

```text
kf.sonnet.core: No language dictionaries for the language: "en_US"
```

下载 Kate 语言包：

```bash
sudo pacman -S aspell aspell-en
```

### **Gwenview 查看 EPS 图片**

下载 `kimageformats` 软件包：

```
sudo pacman -S kimageformats
```

`kimageformats` 提供了 Gwenview 对 EPS、PSD 等图片格式的支持，但 Gwenview 依然是以栅格化形式打开 EPS 矢量图，质量较差，建议用 Okular 查看 EPS 图片

### **运行 AppImage 文件**

AppImage 的扩展名为 `.AppImage`，可以直接双击或在终端输入文件名运行：

```bash
(file_name).AppImage
```

运行 AppImage 需要 FUSE2：

```bash
sudo pacman -S fuse2
```

并检查是否有运行权限，若没有则需要添加运行权限：

```bash
chmod u+x (file_name).AppImage
```

然后双击或在终端输入文件名运行即可

### **用 debtap 安装 `.deb` 包**

首先要下载并更新 [debtap](https://github.com/helixarch/debtap) 包：

```bash
yay -S debtap
sudo debtap -u
```

进入含有 `.deb` 安装包的文件夹，输入：

```bash
debtap (package_name).deb
```

系统会询问三个问题：文件名、协议、编辑文件，都可以直接按 `Enter` 跳过

此处会生成一个 `tar.zst` 包，可以用 `pacman` 安装：

```bash
sudo pacman -U (package_name).tar/zst
```

运行：

```bash
debtap -P (package_name).deb
```

会生成一个 `PKGBUILD` 文件，之后用 `makepkg -si` 也可安装

### **v2rayA 安装与配置**

v2rayA 客户端可以直接使用包管理器安装（AUR 软件库提供 `v2raya`、`v2raya-bin` 和 `v2raya-git`）：

```bash
yay -S v2raya-bin
```

默认使用核心为 v2ray，可以在官方软件源下载：

```bash
sudo pacman -S v2ray
```

启动 v2rayA 需要使用 `systemctl`：

```bash
sudo systemctl enable --now v2raya
```

之后 v2rayA 可以开机自启动

在 [http://localhost:2017/](http://localhost:2017/) 打开 v2rayA 界面，导入订阅链接或服务器链接（ID 填用户的 UUID，AlterID 填 0，Security 选择 Auto，其余选项均为默认）

右上角“设置”中，设置如下：

透明代理/系统代理 >> 启用：大陆白名单模式
透明代理/系统代理实现方式 >> tproxy
防止 DNS 污染 >> 转发 DNS 请求
特殊模式 >> 关闭

保存并应用设置

选择一个节点，点击左上角柚红色的“就绪”按钮即可启动，按钮变为蓝色的“正在运行”

选择左侧的勾选框可以测试节点的网络连接延时

此时系统测试网络连接的功能被屏蔽，可以通过在 `/etc/NetworkManager/conf.d/20-connectivity.conf` 中写入以下内容关闭此功能：

```text
[connectivity]
enabled=false
```

#### **v2rayA 更改核心**

如果需要更改为 xray 核心，可以在 AUR 下载（AUR 软件库提供 `xray`、`xray-bin`）：

```bash
yay -S xray-bin
```

创建文件夹 `/etc/systemd/system/v2raya.service.d`，并添加一个 `xray.conf` 文件：

```bash
sudo mkdir /etc/systemd/system/v2raya.service.d
cd /etc/systemd/system/v2raya.service.d
sudo vim xray.conf
```

写入如下内容：

```text
[Service]
Environment="V2RAYA_V2RAY_BIN=/usr/bin/xray"
```

再重启 v2rayA：

```bash
sudo systemctl daemon-reload && sudo systemctl restart v2raya
```

#### **v2rayA 设置任务栏图标**

任务栏图标可以在 [v2rayATray](https://github.com/YidaozhanYa/v2rayATray) 下载，即下载 [PKGBUILD](https://github.com/YidaozhanYa/v2rayATray/blob/main/PKGBUILD)，在其所在的文件夹下执行 `makepkg -si` 即可安装

v2rayATray 的命令是 `v2raya_tray`，设置它为开机自启动可以在 KDE Plasma 的“系统设置 >> 自动启动”中设置

**浏览器和 KDE Plasma 的网络连接设置都不需要更改**

### **DNS 设置**

DNS 会储存在 `/etc/resolv.conf` 文件中，一般由 `NetworkManager` 根据连接的网络自动生成，例如北京大学校园网的 DNS 服务器为：

```text
162.105.109.122
162.105.109.88
```

而 `/etc/resolv.conf` 文件会被其它软件所改写，如 v2rayA 的“防止 DNS 污染”功能若设置为“仅防止 DNS 劫持（快速）”，则会覆盖 `/etc/resolv.conf` 文件

如果要防止程序覆盖 `/etc/resolv.conf` 文件，可以通过设置不可变文件属性来为其建立写入保护：

```bash
sudo chattr +i /etc/resolv.conf
```

### **TeX Live 安装**

#### **使用 ISO 镜像文件安装**

**一定要以 `sudo` 执行，否则无法安装到默认文件夹和设置 PATH 环境变量（无法写入）**

首先在[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载最新的 TeX Live ISO，文件名为 `texlive.iso`

在 Dolphin 中右键点击 ISO 镜像文件挂载（需要 `dolphin-plugins` 软件包），或在终端中运行：

```bash
sudo mount -t iso9660 -o ro,loop,noauto (texlive_path)/texlive.iso /mnt
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl -gui text
```

用大写字母命令控制安装：

```text
S >> 选择安装方案 >> R
C >> 输入字母选择要安装/不安装的软件包集合 >> R
D >> 输入数字，选择要安装 TeX Live 的各种位置 >> R
O >> L >> 选择默认位置 >> R
I
```

`<D> set directories` 中可以选择默认文件夹，若更改 `TEXDIR`，`TEXMFLOCAL` 等会随 `TEXDIR` 自动更改

`<O> options` 中一定要选择 `<L> create symlinks in standard directories`，这会自动设置 PATH 环境变量

如果使用图形界面安装，首先要检查是否安装 `tcl` 和 `tk` 软件包：

```bash
sudo pacman -S tcl tk
```

进入镜像文件夹，运行：

```bash
sudo perl install-tl -gui
```

即可在图形界面下载 TeX Live，高级设置需要点击左下角的 Advanced 按钮

#### **手动设置 PATH 环境变量**

**如果在安装时选择了 `<L> create symlinks in standard directories`，则不需要如下操作**

编辑 `/etc/profile`，添加如下内容：

```bash
PATH=/usr/local/texlive/2024/bin/x86_64-linux:$PATH; export PATH
MANPATH=/usr/local/texlive/2024/texmf-dist/doc/man:$MANPATH; export MANPATH
INFOPATH=/usr/local/texlive/2024/texmf-dist/doc/info:$INFOPATH; export INFOPATH
```

之后重启电脑

这样可以保证 Bash、Visual Studio Code 等都能够找到 TeX Live 的环境变量

可以运行 `tex --version` 检查是否安装成功，若成功应显示 TeX 的版本号、TeX Live 的版本号和版权信息

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc tex`）检查是否安装成功

输入命令 `tlmgr conf` 可以查看 TeX Live 的文件夹设置，如 `TEXMFMAIN=(TEXDIR)/texmf-dist`

#### **使用 pacman 安装**

可以使用 `pacman` 从 Arch Linux 的官方源下载所需要的 TeX Live 软件包：

```bash
sudo pacman texlive-basic
```

其余 TeX Live 软件包按需下载，可以在 [Arch Linux Packages](https://archlinux.org/packages/) 查看

TeX Live 软件包的文档可以在以下网站在线查看：

[CTAN: Comprehensive TeX Archive Network](https://www.ctan.org/)

[TeXdoc online documentation](https://texdoc.org/)

也可以下载 `texlive-doc` 软件包（大小为 2.3 GiB）：

```bash
sudo pacman -S texlive-doc
```

之后也可以通过 Arch Linux 官方源更新

**注意官方软件源的更新周期与 TeX Live 相同，即一年一次，且只能以软件包集合为最小单位下载**

#### **更改 CTAN 镜像源**

CTAN 镜像源可以使用 TeX Live 包管理器 `tlmgr` 更改

更改到清华大学镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
```

更改到上海交大镜像需要在命令行中执行：

```bash
sudo tlmgr option repository https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/tlnet/
```

#### **从安装程序安装**

可以从[官网](https://www.tug.org/texlive/acquire-netinstall.html)下载 [install-tl-unx.tar.gz](https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz)，解压后可以找到一个 `install-tl` 文件，执行：

```bash
sudo perl install-tl -select-repository -gui text
```

第一步输入数字选择镜像站，建议选择清华大学镜像或上海交大镜像

之后步骤与前面一致，大约需要 1h（从 ISO 安装只需要 10min，因为是直接从本地 ISO 镜像中安装，不需要网络）

#### **tlmgr 的常用命令**

显示说明文档：

```bash
tlmgr -help
```

下载软件包：

```bash
sudo tlmgr update (package_name)
```

这会同时下载软件包及其依赖

更新自身：

```bash
sudo tlmgr update -self
```

更新全部软件包：

```bash
sudo tlmgr update -all
```

查找本地软件包：

```bash
tlmgr search (package_name)
```

从软件源（即完整的 TeX Live）查找软件包：

```bash
tlmgr search -global (package_name)
```

从软件源查找软件包文件（如 `.sty` 文件、`.def` 文件等）：

```bash
tlmgr search -global (file_name)
```

#### **命令行编译 LaTeX 源文件**

建议使用 `latexmk`，可以自动编译 `.tex`、`.bib` 文件等，直到最后输出正确的 PDF 文件

以 LuaLaTeX 为例，命令为：

```bash
latexmk -lualatex -bibtex -synctex=1 -interaction=nonstopmode -file-line-error --shell-escape (file_name)
```

如果使用 XeLaTeX，将 `-lualatex` 改为 `-xelatex` 即可

清理编译时产生的多余文件的命令为：

```bash
latexmk -clean (file_name)
```

#### **biber 报错**

biber 是 biblatex 的默认后端，用来替换过时的 biblatex，如果在运行 biber 的过程中出现以下报错：（可以用 `biber --help` 尝试）

```text
error while loading shared libraries: libcrypt.so.1: cannot open shared object file: No such file or directory
```

需要安装 `libxcrypt-compat`：

```bash
sudo pacman -S libxcrypt-compat
```

#### **安装 MathTime Professional 2 字体**

[MathTime Professional 2](https://www.pctex.com/mtpro2.html) 字体是 Type 1 字体，下载后为 `mtp2fonts.zip.tpm` 文件

可以使用以下脚本安装在 Linux 上：

[Mathtime Installer -- GitHub](https://github.com/jamespfennell/mathtime-installer)

下载 `mtpro2-texlive.sh`，并安装 `unzip` 软件包，之后执行：

```bash
bash mtpro2-texlive.sh -i mtp2fonts.zip.tpm
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

### **Thunderbird 安装与配置**

#### **Thunderbird 安装**

在官方仓库中安装 Thunderbird 邮件新闻客户端：

```bash
sudo pacman -S thunderbird
```

可以安装中文语言包：

```bash
sudo pacman -S thunderbird-i18n-zh-cn
```

打开 Thunderbird 后需要添加账户，输入自定义的姓名，现有的邮箱和密码即可，Thunderbird 会自动配置

再添加账户可以在右上角菜单栏选择“添加账户”中的“现有邮箱”，并可以拖动账户更改排序

#### **Thunderbird 设置**

进入设置界面调整显示：

设置 >> 常规 >> Thunderbird 起始页 >> 清空并取消勾选

设置 >> 常规 >> 默认搜索引擎 >> 改为 Bing 或 Google

设置 >> 隐私 >> 邮件内容 >> 勾选“允许消息中的远程内容”

右键点击上方邮件工具栏，选择“自定义”，自行配置即可

#### **Thunderbird 账户设置**

点击邮箱帐号，配置“账户设置”如下：

服务器 >> 服务器设置 >> 每隔 1 分钟检查一次新消息

如果要删除账户，在“账户设置”左下角的“账户操作”中选择“删除账户”

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

生成一个 SSH 密钥默认使用兼容性最好的 RSA 算法，现在推荐使用更安全的 ED25519 算法：

```bash
ssh-keygen -t ed25519 -C "(user_email)"
```

第一步生成私钥，会询问 `Enter file in which to save the key`，默认是 `~/.ssh/id_ed25519`，可以改为别的位置和名字，如 `(ssh_folder)/(key_name)`

第二步会提示输入安全密码，可以按 `Enter` 跳过，不影响后续操作和使用

这样创建的私钥位置为 `(ssh_folder)/(key_name)`，公钥位置为 `(ssh_folder)/(key_name).pub`

如果 SSH 密钥不在默认的 `~/.ssh`，则需要创建设置文件 `~/.ssh/config`（这个文件必须在 `~/.ssh/` 文件夹内）并写入：

```text
IdentityFile (ssh_folder)/(key_name)
```

之后执行：

```bash
eval "$(ssh-agent -s)"
ssh-add (ssh_folder)/(key_name)
```

#### **新增 SSH 密钥到 GitHub 帐户**

通过 `cat ~/.ssh/id_ed25519.pub` 查看公钥并复制到 GitHub 账户下的“Settings >> SSH and GPG keys”中

#### **测试 SSH 连接**

在终端中输入：

```bash
ssh -T git@github.com
```

这一步要输入 `yes` 确定

此时会显示：

```
Hi (user_name)! You've successfully authenticated, but GitHub does not provide shell access.
```

说明 SSH 连接测试成功

**注意 Linux 上和 Windows 上用的是不同的密钥，Windows 上操作步骤相同，但需要在 Git Bash（而不是 Windows Powershell）上执行**

### **Python 安装与配置**

Arch Linux 预装了 Python，但没有安装包管理器，可以使用 `pip` 或 `conda`

#### **pip 安装**

在终端中输入：

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py
```

即可安装 pip，此时不建议安装 conda，pip 下载包的命令是：

```bash
pip install (package_name)
```

列出 pip 下载的所有包，包括下载的位置：

```bash
pip list -v
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

安装过程参考以下网址：（Miniconda 和 Anaconda 的安装步骤相同）

[Anaconda Documentation -- Installing on Linux](https://docs.anaconda.com/anaconda/install/linux/)

用 `bash` 执行安装文件：

```bash
bash Miniconda3-latest-Linux-x86_64.sh
```

按 `Enter` 查看许可协议，然后按住 `Enter` 滚动

输入 `yes` 同意许可协议

输入安装 Miniconda 的目录并按 `Enter` 确定

最后一步输入 `yes` 执行 `conda init` 初始化 Miniconda

注意最后一步要选择 `yes`

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

输入以下命令：（在 Windows 中用户无法直接创建名为 `.condarc` 的文件，可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改）

```bash
vim ~/.condarc
```

修改 `~/.condarc` 以使用清华大学镜像：

```text
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

```text
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

```text
channels:
  - defaults
ssl_verify: true
```

#### **Miniconda 下载软件包**

下载一些必要的包：

```bash
conda install numpy matplotlib astropy black isort ipython jupyterlab
```

各个操作系统平台上可下载的包可以在以下网站查询：

[Anaconda Documentation -- Anaconda Package Lists](https://docs.anaconda.com/anaconda/packages/pkg-docs/)

下载 JupyterLab 插件：

```
pip install lckr_jupyterlab_variableinspector jupyterlab-lsp python-lsp-server jupyterlab_execute_time jupyterlab-code-formatter jupyterlab-spellchecker ipympl jupyterlab_h5web
```

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

更新包：（`pip` 的相应命令为 `pip install --upgrade (package_name)`）

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
conda activate (environment_name)
```

取消激活环境：

```bash
conda deactivate (environment_name)
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

```text
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

```text
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

```text
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

```text
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

下载扩展：Python（需要单独下载代码风格检查工具 Pylint 和格式化工具 autopep8、Black Formatter 等）、Jupyter、LaTeX Workshop、Markdown all in One 等

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

#### **Python 插件设置**

如果使用的是 Miniconda 提供的 Python，需要查询 Python 的安装位置：

```bash
which python
```

并将返回的结果 `(python_path)` 添加到 `settings.json` 中：

```json
"python.defaultInterpreterPath": "(python_path)"
```

#### **LaTeX Workshop 插件设置**

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

```text
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

### **Typora 安装和设置**

#### **Typora 安装**

Typora 可以从 AUR 安装：

```bash
yay -S typora
```

#### **源代码模式设置**

更改 `/usr/share/typora/resources/style/base-control.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base-control.css`）

找到 `.CodeMirror.cm-s-typora-default div.CodeMirror-cursor` 一行，将光标宽度改为 `1px`，颜色从 `#e4629a` 改为 `#000000`

更改 `/usr/share/typora/resources/style/base.css`：（在 Windows 中则是 `C:\Program Files\Typora\resources\style\base.css`）

找到 `:root` 一行，将 `--monospace` 改成自己想要的等宽字体

#### **主题渲染模式设置**

在 `/home/(user_name)/.config/Typora/themes/` 中自己写一个 CSS 文件（可以复制其中一个默认主题，重命名后更改）

找到 `body` 一行，将 `font-family` 改成自己想要的字体

找到 `tt` 一行，将 `font-family` 改成自己想要的等宽字体（`monospace`）

### **SAOImageDS9 安装和设置**

AUR 中有 `ds9` 和 `ds9-bin` 两个版本，推荐选择二进制包 `ds9-bin`：

```bash
yay -S ds9-bin
```

如果出现这样的错误导致 SAOImageDS9 无法打开或闪退：

```text
application-specific initialization failed: unknown color name "BACKGROUND"
Unable to initialize window system.
```

在终端中输入：

```bash
xrdb -load /dev/null
xrdb -query
```

即可解决

设置 SAOImageDS9 使用鼠标左键拖动图片如下：

Edit >> Preferences >> Pan Zoom >> 选择“Drag to Center”

保存设置后，在“Edit >> Pan”模式下即可使用鼠标左键拖动图片

### **IRAF/PyRAF 安装**

#### **从 AUR 安装 IRAF**

可以从 AUR 安装 PyRAF：

```bash
yay -S iraf-bin
```

#### **从源代码安装 IRAF**

首先下载编译依赖：

```bash
sudo pacman -S gcc make bison flex zlib curl expat readline
```

从 GitHub 上下载软件源代码：

```bash
git clone https://github.com/iraf-community/iraf.git
```

进入 `iraf` 文件夹，并执行：

```bash
make 2>&1 | tee build.log
```

可以使用 `make test` 测试安装，输出的 `xfailed` 是预计就会失败的，不必担心

之后执行：

```bash
sudo make install
```

将其安装到系统

默认安装到 `/usr/local`，也可以更改为其它位置：

```bash
sudo make install prefix=(directory)
```

部分功能可能需要 xgterm：

```bash
yay -S xgterm-bin
```

#### **安装 PyRAF**

可以用 pip 安装 PyRAF：

```bash
pip install pyraf
```

#### **IRAF/PyRAF 常用命令**

启动 IRAF 的命令为：

```bash
irafcl
```

列出所有可以使用的 IRAF 命令：

```bash
?
```

查看命令的说明文档：

```bash
help (command)
```

启动 PyRAF：

```bash
pyraf
```

退出 IRAF：

```bash
logout
```

退出 PyRAF：（也可以用 `Ctrl+D`）

```bash
exit()
```

启动参数编辑器（the EPAR Parameter Editor）的命令为：

```bash
epar (task_name)
```

退出参数编辑器的命令和 Vim 一样，也是 `:q`

### **Topcat 安装**

天文数据表格操作工具 [Topcat](https://www.star.bris.ac.uk/~mbt/topcat/) 可以从 AUR 安装：

```bash
yay -S topcat
```

如果 Topcat 在高分辨率屏幕上显示过小，则编辑 `~/.starjava.properties` 并加入：

```text
sun.java2d.uiScale=2
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

### **相机安装（可选）**

KDE 官方的相机应用是 Kamoso：

```bash
sudo pacman -S kamoso
```

需要区别于另一个 KDE 应用 Kamera，Kamera 提供了一个配置工具和一个 KIO 工作程序，用于在采用了此协议的数码相机上进行读写操作。

### **QQ 安装（可选）**

可以下载基于 Electron 的官方 QQ Linux 版：

```bash
yay -S linuxqq
```

### **微信安装（可选）**

推荐安装以下版本：

```bash
yay -S wechat-universal-bwrap
```

### **会议软件安装（可选）**

#### **腾讯会议**

推荐安装官方原生的腾讯会议 Linux 版：

```bash
yay -S wemeet-bin
```

#### **钉钉**

```bash
yay -S dingtalk-bin
```

高分辨率屏幕下可以点击头像 >> 设置 >> 全局缩放，选择 150%

#### **Zoom**

```bash
yay -S zoom
```

高分辨率屏幕下调整全局缩放需要编辑 `~/.config/zoomus.conf`，加入一行 `scaleFactor=2`

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

```bash
yay -S qbittorrent
```

### **使用 CachyOS 内核（可选）**

首先检查 CPU 是否支持 `x86-64-v3` 和 `x86-64-v4` 微架构：

```bash
/lib/ld-linux-x86-64.so.2 --help | grep supported
```

输出结果如：

```
x86-64-v4 (supported, searched)
x86-64-v3 (supported, searched)
x86-64-v2 (supported, searched)
```

说明支持 `x86-64-v3` 和 `x86-64-v4` 微架构

导入密钥：

```bash
sudo pacman-key --recv-keys F3B607488DB35A47
sudo pacman-key --lsign-key F3B607488DB35A47
```

编辑 `/etc/pacman.conf` 文件：

```bash
sudo vim /etc/pacman.conf
```

如果 CPU 支持 `x86-64-v3`，则添加：

```text
[cachyos-v3]
Include = /etc/pacman.d/cachyos-v3-mirrorlist
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
```

如果 CPU 支持 `x86-64-v4`，则添加：

```text
[cachyos-v4]
Include = /etc/pacman.d/cachyos-v4-mirrorlist
[cachyos]
Include = /etc/pacman.d/cachyos-mirrorlist
```

之后下载想要的内核，例如：

```
sudo pacman -S linux-cachyos
```

之后重新生成 GRUB 文件：

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

重启电脑即可

参考以下网址：

https://github.com/CachyOS/linux-cachyos
