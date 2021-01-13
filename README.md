<font face="JetBrains Mono">

# **在 Surface Pro 6 上安装 Manjaro 20 KDE Plasma + Windows 10 双系统的指南**

```
firestar@FIRESTAR
OS: Manjaro 20.1 Mikah
Kernel: x86_64 Linux 5.8.10-arch1-3-surface
Uptime: 13m
Packages: 1257
Shell: zsh 5.8
Resolution: 2736x1824
DE: KDE 5.73.0 / Plasma 5.19.5
WM: KWin
GTK Theme: Mojave-light [GTK2/3]
Icon Theme: Mojave-CT-Light
Disk: 30G / 112G (29%)
CPU: Intel Core i5-8250U @ 8x 3.4GHz
GPU: Mesa Intel(R) UHD Graphics 620 (KBL GT2)
```

## **Windows 的准备工作**

### **关闭快速启动**

控制面板 --> 电源选项 --> 选择电源按钮的功能 --> 更改当前不可用的设置 --> 保存修改

### **关闭 Bitlocker**

开始菜单 --> 设置 --> 更新和安全 --> 设备加密 --> 关闭

### **进入 UEFI 设置**

关闭 Surface，然后等待大约 10 秒钟以确保其处于关闭状态 

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮 
    
屏幕上会显示 Microsoft 或 Surface 徽标 继续按住调高音量按钮 显示 UEFI 屏幕后，松开此按钮 

Security --> Secure Boot --> Disabled(第三个选项)

### **制作启动盘**

在清华大学镜像中下载 Manjaro KDE 镜像，网址如下：

https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/

使用 [Rufus](https://github.com/pbatard/rufus) 刻录启动盘（注意启动盘如果用移动硬盘会无法被识别），直接选中镜像点确定即可（现在已经没有ISO/DD选项）

或使用 [Ventoy](https://github.com/ventoy/Ventoy) 制作启动盘，然后将下载的`.iso`文件复制到 USB 的第一个分区中即可（未验证，请谨慎尝试）

### **安装 Manjaro**

**如果之前安装过 Manjaro， 需要使用 [EasyUEFI](https://www.easyuefi.com/index-us.html) 删除 Manjaro 开机启动项，并在“磁盘管理”中删除 Manjaro 磁盘（卷）**

设置 --> 恢复 --> 立即重新启动 --> USB Storage

或按照以下步骤直接从 USB 启动:

关闭 Surface

将可启动 U 盘插入 Surface 上的 USB 端口

长按 Surface 上的调低音量按钮，同时按下并释放 "电源" 按钮，屏幕上会显示 Microsoft 或 Surface 徽标

继续按住调低音量按钮，释放按钮后，徽标下方将显示旋转圆点，按照屏幕说明从 U 盘启动

#### **分区设置**

|     大小     |  文件系统  |   挂载点   |  标记  |
| :---------: | :--------: | :-------: | :----: |
|    >40GB    |    ext4    |     /     |  root  |
|    260MB    |            | /boot/efi |        |

**挂载`/boot/efi`时一定要选择“保留”而不是“格式化”**

**使用 swap 分区可能会缩短 SSD 的寿命，如果需要 swap 的话建议用 swap 文件，详见 [Swap（简体中文）- Arch Wiki](https://wiki.archlinux.org/index.php/Swap_(简体中文)#交换文件)**

**系统安装时 Office 一项选择 No Office Suite，在安装软件时再下载 WPS Office**

## **初始配置**

### **电源设置**

系统设置 --> 电源管理 --> 节能 --> 勾选“按键事件处理” --> 合上笔记本盖时 --> 选择“关闭屏幕” --> 勾选“即使已连接外部显示器”

#### **与电源管理相关的常见英文名词**

Suspend：挂起，Reboot：重启，Shutdown：关机，Logout：注销

### **sudo 免密码及更改默认编辑器为 nano**

首先在终端中输入：

	sudo visudo

在开头的一个空行键入：

	Defaults editor=/usr/bin/nano

在最后一行（空行）按 `i` 进入输入模式，加上这一行：

	Defaults:(user_name) !authenticate

按 `Esc` 进入命令模式，再按 `:x` 保存，按 `Enter` 退出

### **官方软件源更改镜像**

    sudo pacman-mirrors -i -c China -m rank

在广州建议用上海交大或阿里云的镜像，在北京建议用清华镜像，确认后输入：

    sudo pacman -Syyu

### **终端输出语言为英语**

在每一条命令前面添加：

	LANG=C
    
例如:

    LANG=C sudo pacman -Syyu

### **AUR**

#### 安装 base-devel

AUR 上的某些 PKGBUILD 会默认你已经安装 `base-devel` 组的所有软件包而不将它们写入构建依赖。为了避免在构建过程中出现一些奇怪的错误，建议先安装 `base-devel`：

	sudo pacman -S base-devel

或

	pamac install base-devel

#### 启用 pamac 的 AUR 支持

添加/删除软件 --> 右上角 ··· --> 首选项 --> AUR --> 启用AUR支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build` 及 `pamac install` 获取 AUR 的软件包。

#### 安装 yay

除了预装的 `pamac`，Manjaro 官方仓库中的 AUR 助手还有 `yay`

	sudo pacman -S yay

或

	pamac install yay

执行以下命令以启用清华的 AUR 反代:

	yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

修改的配置文件位于 `~/.config/yay/config.json` ，还可通过以下命令查看修改过的配置：

	yay -P -g

### **Arch Linux CN 软件源**

在 `/etc/pacman.conf` 文件末尾添加以下两行以启用上海交大镜像：

	[archlinuxcn]

	Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch

之后执行下面的命令安装 archlinuxcn-keyring 包导入 GPG key

	sudo pacman -Sy archlinuxcn-keyring

由于 Manjaro 的更新滞后于 Arch，使用 archlinuxcn 仓库可能会出现“部分更新”的情况，导致某些软件包损坏。用下面的命令切换到 unstable 分支可以尽量跟进 Arch 的更新：

	sudo pacman-mirrors -a -f -B unstable
	sudo pacman -Syyuu
	
### **为 pacman 和 yay 添加多线程下载**

执行下面的命令下载 axel

	 yay -S axel

编辑`/etc/pacman.conf`文件（在第21行）:

    XferCommand = /usr/bin/axel -n 10 -o %o %u

编辑`/etc/makepkg.conf`文件（在第11-16行）:

    DLAGENTS=('file::/usr/bin/curl -gqC - -o %o %u'
          'ftp::/usr/bin/axel -n 10 -o %o %u'
          'http::/usr/bin/axel -n 10 -o %o %u'
          'https::/usr/bin/axel -n 10 -o %o %u'
          'rsync::/usr/bin/rsync --no-motd -z %u %o'
          'scp::/usr/bin/scp -C %u %o')

### **双系统时间不同步 + 24小时制**

#### **双系统时间不同步**

可以在 Manjaro 上设置硬件时间为 localtime，与 Windows 保持一致

	sudo timedatectl set-local-rtc 1

#### **Manjaro 设置24小时制**

时钟点右键 --> 配置数字时钟 --> 时间显示 --> 24小时制

### **自动连接 Wifi**

确保 KDE 钱包开启即可，调整路径如下：

应用 --> 系统 --> KWalletManager

### **动态 Swap 文件设置**

先下载`systemd-swap`软件包：

	yay -S systemd-swap

编辑`/etc/systemd/swap.conf`:

	kate /etc/systemd/swap.conf
	
去掉`swapfc_enabled`前的注释并设置为`swapfc_enabled=1`，保存并关闭

在终端输入`sudo systemctl enable --now systemd-swap`以启动`systemd-swap`服务

**Linux 的内存策略可以参考这个网站：https://www.linuxatemyram.com/**

### **连接北京大学 VPN**

按 `Fn+F12` 打开 Yakuake，输入：

	sudo openconnect --user (student_ID) https://vpn.pku.edu.cn --juniper

之后点击窗口外任意位置或按 `Fn+F12` 让它收起，不要关闭窗口（关闭窗口则VPN断开）

### **Linux 挂载 Windows 磁盘**

**首先要确保 Bitlocker 已经关闭，这个时候一般来讲会自动显示出来，在 Dolphin 中点击即可挂载**

**如果要挂载 C 盘请确保快速启动已经关闭**

在终端中输入：

    lsblk -f    

在输出结果中可以发现 Windows 的硬盘分区，每个分区有一段 `UUID` 的信息，应为16位十六进制数，右键选中复制下来 

接着就来修改系统文件：

    kate /etc/fstab

在最后加入这两句：

    UUID=8494B8C594B8BACE                     /run/media/firestar/System    ntfs-3g uid=firestar,gid=users,auto 0 0
    UUID=A2668A50668A24DF                     /run/media/firestar/Data    ntfs-3g uid=firestar,gid=users,auto 0 0

重启电脑后，即可自动挂载

#### **如果文件系统突然变成只读**

一般来讲是 Windows 进行了优化磁盘等操作导致的，下面以 Data 盘为例：

检查占用进程：

    sudo fuser -m -u /dev/nvme0n1p4

可以看到数字，就是占用目录的进程 PID，终止进程：

    sudo kill (PID_number)

取消挂载：

    sudo umount /dev/nvme0n1p4

执行硬盘 NTFS 分区修复：

    sudo ntfsfix /dev/nvme0n1p4

再重新挂载即可：

    sudo mount /dev/nvme0n1p4 /run/media/firestar/Data

### **Linux-Surface 安装**

**安装和更新 Linux-Surface 需要登录北京大学 VPN**

参考以下网址：

Linux-Surface -- Installation and Setup
https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup

在终端中输入：

	systemctl enable iptsd

可以开机时自动启动触屏功能

### **SONY LE_WH-1000XM3 耳机连接**

长按耳机电源键约7s即可进入配对模式，可以在蓝牙中配对。

### **Logitech M590 鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Manjaro 系统在鼠标上会被识别为两个设备。如果 Windows 系统被识别为设备1，需要按滚轮后的圆形按钮切换至设备2。并长按圆形按钮直到灯2快速闪烁进入配对模式。

首先要安装`bluez-utils`以启用`bluetoothctl`命令：

	yay -S bluez-utils
	
然后参考以下网站：

Arch Wiki -- 关于Logitech BLE鼠标的问题
https://wiki.archlinux.org/index.php/Bluetooth_mouse#Problems_with_the_Logitech_BLE_mouse_(M557,_M590,_anywhere_mouse_2,_etc)

### **解决用 root 登录没有声音的问题**

用 root 登录，并在`/root/.config/autostart/`下创建一个`pulseaudio.desktop`文件，写入：

	[Desktop Entry]
	Encoding=UTF-8
	Type=Application
	Name=pulseaudio
	Exec=pulseaudio --start --log-target=syslog
	StartupNotify=false
	Terminal=true
	Hidden=false

保存退出即可

### **切换图形化界面和命令行界面**

登录时默认进入的是图形化界面，有时候开机后黑屏是图形化界面显示不出来所致，此时可以按快捷键`Ctrl+Alt+Fn+(F2~F6)`进入`tty2 ~ tty6`的任何一个命令行界面

注意此时需要手动输入用户名和密码

在命令行界面解决问题后，按快捷键`Ctrl+Alt+Fn+F1`可以转换回图形化界面

### **打字时桌面卡死，鼠标可以移动，点击无效**

参考以下网址

https://forum.manjaro.org/t/kde/39610

可以归纳为：切 tty，输入`killall plasmashell; plasmashell`，再回到原来的 tty，打开终端，执行 `plasmashell &`

## **美化**

**一定要先美化再装软件！**

### **添加用户图标**

系统设置 --> 用户账户 --> 图像

**更改用户图标后要先点击“应用”再点击“确定”方可生效！**

### **桌面美化**

屏幕分辨率是2736×1824，需要配置高分屏优化：

系统设置 --> 显示和监控 --> 显示配置 --> 分辨率 --> 全局缩放 --> 200%

系统设置 --> 光标 --> 大小 --> 36

然后重启电脑

#### **主题美化**

**不要用全局主题！**

参考以下网址：

Kde 桌面的 Mac 化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

其中 Plasma 主题、GTK主题和图标主题分别选择：
	
	Plasma Theme: Mojave-CT
	GTK Theme: Mojave-light-alt [GTK2/3]
    Icon Theme: Mojave-CT-Light

Latte-Dock 的推荐设置：

行为：位置 --> 底部，可见性 --> 自动隐藏，延迟 --> 显示 --> none

外观：绝对大小 --> 96，背景大小 --> 10%

#### **终端美化**

参考以下网址：

Oh-My-Zsh 及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

zsh主题选择：

	geoffgarside

#### **grub 美化**

选择主题 Slaze ，下载地址如下：

https://github.com/vinceliuice/grub2-themes

以 Slaze grub theme （2K，黑白图标） 为例，解压后在文件夹内执行：

	sudo ./install.sh -b -l -w -2

删除多余启动条目，请参考以下网址：

Linux grub 删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969

#### **pacman 添加吃豆人彩蛋**

编辑 /etc/pacman.conf

	kate /etc/pacman.conf

去掉`Color`前面的注释，并在下一行添加：

	ILoveCandy

即可添加吃豆人彩蛋

### **快捷键配置**

#### **Konsole 快捷键**

右上角 ··· --> 配置键盘快捷键 --> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V` 

#### **Dolphin 图标大小和快捷键**

右上角 ··· --> 配置键盘快捷键 --> 移至回收站改为 `Ctrl+D` ，删除改为 `Del`

### **桌面设置**

右键点击桌面 --> 配置桌面 ---> 位置 --> 自定义位置

### **调整 CPU 频率**

    kate /etc/tlp.conf

更改以下两处地方：

    CPU_MIN_PERF_ON_AC=15
    CPU_MAX_PERF_ON_AC=30
    CPU_MIN_PERF_ON_BAT=15
    CPU_MAX_PERF_ON_BAT=30

    CPU_BOOST_ON_AC=0
    CPU_BOOST_ON_BAT=0

**不需要高性能的时候可以关掉 turbo，这样 CPU 的频率就会限制在 1.9 GHz 以下，大幅增加续航、减少发热**

保存、关闭，在终端中输入：

    sudo tlp start

#### **显示 CPU 频率**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/jsalatas/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

### **禁用 baloo**

`baloo` 是 KDE 的文件索引服务，能加快文件搜索的速度，但可能会时不时产生大量硬盘读写而导致图形界面卡顿。可以用下面的命令禁用之：

	balooctl disable

## **下载软件**

**能用包管理器的尽量用包管理器安装！**

### **PGP 密钥无法导入**

如果安装软件时需要导入 PGP 密钥而发生 `gpg: 从公钥服务器接收失败：一般错误` 的问题，将 PGP 密钥复制下来并运行：

	gpg --keyserver p80.pool.sks-keyservers.net --recv-keys (pgp_key)

再重新安装软件即可

### **语言包**

系统设置 --> 语言包 --> 右上角点击“已安装的软件包”安装语言包

### **安装微软字体**

安装方法如下：

    sudo mkdir /usr/share/fonts/winfonts
    sudo cp (win-font-path)/* /usr/share/fonts/winfonts/
    cd /usr/share/fonts/winfonts/
    fc-cache -fv
    
这样就可以安装微软雅黑、宋体、黑体等字体了 

### **更改程序和终端默认中文字体为微软雅黑**

输入命令：

    kate /etc/fonts/conf.d/64-language-selector-prefer.conf

并加入以下内容：

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
	<alias>
		<family>sans-serif</family>
		<prefer>
			<family>Microsoft YaHei UI</family>
			<family>Noto Sans CJK SC</family>
			<family>Noto Sans CJK TC</family>
			<family>Noto Sans CJK HK</family>
			<family>Noto Sans CJK JP</family>
			<family>Noto Sans CJK KR</family>
		</prefer>
	</alias>
	<alias>
		<family>serif</family>
		<prefer>
			<family>SimSun</family>
			<family>Noto Sans CJK SC</family>
			<family>Noto Sans CJK TC</family>
			<family>Noto Sans CJK HK</family>
			<family>Noto Sans CJK JP</family>
			<family>Noto Sans CJK KR</family>
		</prefer>
	</alias>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>JetBrains Mono NL</family>
			<family>JetBrains Mono</family>
			<family>Consolas</family>
			<family>Microsoft YaHei UI</family>
			<family>Noto Sans Mono CJK SC</family>
			<family>Noto Sans Mono CJK TC</family>
			<family>Noto Sans Mono CJK HK</family>
			<family>Noto Sans Mono CJK JP</family>
			<family>Noto Sans Mono CJK KR</family>
		</prefer>
	</alias>
</fontconfig>
```

保存退出即可

### **安装中文输入法**

参考以下网址：

ArchWiki -- Fcitx5 (简体中文)
https://wiki.archlinux.org/index.php/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

### **设置 Konsole 界面为英文**

在`~/.bashrc`和`~/.zshrc`最后添加一行：

	export LANG=C

### **安装其它软件**

以下命令中的 `yay -S` 也可以在“添加/删除软件”（即pamac）中搜索安装，或者用 `pamac install` 安装

	yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts
	yay -S electron-netease-cloud-music
	yay -S texstudio
	yay -S stellarium
	yay -S vim

**如果用 `yay -S nautilus` 安装了 nautilus 则用 `sudo nautilus` 就可以访问没有权限粘贴/删除的文件夹（不推荐）**

很多 KDE 应用不支持直接以 root 的身份运行，但是在需要提权的时候会自动要求输入密码。例如 Kate，可以先用普通用户的身份打开文件，保存时如果需要 root 权限就会弹出密码输入框。

#### **用 debtap 安装 .deb 包（不推荐）**

首先要下载并更新debtap包：

	yay -S debtap
	sudo debtap -u

**运行 ```sudo debtap -u``` 时建议连接北京大学 VPN**

进入含有 ```.deb``` 安装包的文件夹，输入：

	sudo debtap (package_name).deb

系统会询问三个问题：文件名随便写，协议写 ```GPL``` 即可，编辑文件直接按 ```Enter``` 跳过 

此处会生成一个 ```tar.zst``` 包，双击打开（右键用“软件安装程序”打开）即可安装 

### **安装 TeX Live**

首先在[ TeX Live 下载地址](https://tug.org/texlive/acquire-netinstall.html)下载`install-tl-unx.tar.gz`

打开终端，运行：

	tar -xzvf install-tl-unx.tar.gz

进入解压后的文件夹，运行：

	sudo perl install-tl

此过程大概需要40分钟，安装后需要将 TeX Live 添加到 PATH

	kate ~/.zshrc
	
在最后添加以下语句：

	PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH; export PATH
	MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH; export MANPATH
	INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH; export INFOPATH
	
更新 zsh 配置：

	source ~/.zshrc
	
可以运行`tex -v`检查是否安装成功，若成功应显示（以 Tex Live 2020 为例）：

	TeX 3.14159265 (TeX Live 2020)
	kpathsea version 6.3.2
	Copyright 2020 D.E. Knuth.
	There is NO warranty.  Redistribution of this software is
	covered by the terms of both the TeX copyright and
	the Lesser GNU General Public License.
	For more information about these matters, see the file
	named COPYING and the TeX source.
	Primary author of TeX: D.E. Knuth.
	
### **安装 KDE 的 Wayland 支持**

与 Xorg 相比，Wayland 对触屏的支持更佳，但某些应用在 Wayland 上会有兼容性问题。目前 KDE 对 Wayland 的支持处于能用但还不太完善的状态

	yay -S plasma-wayland-session

安装后即可在登录界面选择 Wayland 会话

### **Thunderbird 美化与配置**

#### **Thunderbird 美化**

进入首选项界面调整显示：

Startpage 清空并取消勾选

Default Search Engine 改为 Bing

System Intergration 全部设为默认并取消勾选

右键点击上方工具栏 Mail Toolbar，选择 Customize，自行配置即可

#### **Thunderbird 帐号配置**

点击邮箱帐号，配置 Account Settings 如下：

Server Settings --> Server Settings --> Check for new messages every `1` minutes

Server Settings --> Server Settings --> When I delete a message --> Remove it immediately

Copies & Folders --> When sending messages, automatically --> 取消勾选 Place a copy in

### **Git 配置用户名、邮箱及免密码设置**

	git config --global user.name "(user_name)"
	git config --global user.email "(user_email)"       
	kate .git-credentials

写入如下语句：

    https://(user_name):(user_password)@github.com

保存退出

	git config --global credential.helper store

### **Anaconda 安装**

**运行 `conda` 时建议连接北京大学 VPN**

#### **默认安装**

	yay -S anaconda

#### **自定义安装**

下载地址如下（官网下载速度极慢，选择清华镜像）：

https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/

点击网页第三列的 Date 按钮，使各版本按照时间从旧到新排列，在最底端可以找到最新版本

安装过程参考以下网址：

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复之前的版本：

	conda list --revisions
	conda install --revision (revision_number)

注意：如果回滚到早期版本（revision_number 较小）之后又想回到某个高版本（revision_number 较大），必须要把两个版本中的版本都装一遍

打开 Anaconda Navigator 需要在终端中输入：

	anaconda-navigator

用 Spyder 打开某个文件需要在终端中输入：

	spyder (file_path)/(file_name)

### **Vim 安装插件**

	git clone https://github.com/tell-k/vim-autopep8.git ~/.vim/pack/vim-autopep8/start/vim-autopep8
	vim -u NONE -c "helptags ~/.vim/pack/vim-autopep8/start/vim-autopep8/doc" -c q

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用`code`命令打开：

	yay -S code

微软官方的二进制 release（包含部分私有的组件），同样可以用`code`命令打开（如果不介意私有组件而且不习惯“Code - OSS”的图标，个人推荐首选此项）：

	yay -S visual-studio-code-bin

内测版本：

	yay -S visual-studio-code-insiders

第三方发布的从开源代码构建的二进制包：

	yay -S vscodium-bin

从最新的开源代码构建：

	yay -S code-git

#### **Visual Studio Code 图标更改**

如果图标美化后 Visual Studio Code 图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 --> 编辑应用程序 --> Visual Studio Code --> 点击图标更改 --> 其他图标

#### **Visual Studio Code 缩放比例**

放大比例：`Ctrl+=`

缩小比例：`Ctrl+-`

#### **Visual Studio Code 的 C/C++ 环境配置**

参考以下网址：

基于 VS Code + MinGW-w64 的 C/C++ 简单环境配置
https://zhuanlan.zhihu.com/p/77074009

注意：下载插件 C/C++ Compile Run 后只要按 `Fn+F6` 即可编译运行 C/C++ 程序，但是不能调试。调试环境的配置请参考以下网址：

VS Code 之 C/C++程序的 debug 功能简介
https://zhuanlan.zhihu.com/p/85273055

### **能用上触控笔的软件**

#### **绘画**

	yay -S krita

#### **手写笔记**

	yay -S xournalpp

### **屏幕键盘**

目前最受欢迎的屏幕键盘应该是 OnBoard

	yay -S onboard

但 OnBoard 在 Wayland 上无法使用。如果需要在 Wayland 会话中使用屏幕键盘，推荐安装 CellWriter

	yay -S cellwriter

### **检查依赖关系**

以树状图的形式展示某软件包的依赖关系：

    pactree (package_name)

### **清理缓存**

清理全部软件安装包：

    yay -Scc

删除软件包时清理设置文件：

	yay -Rn (package_name)

清理无用的孤立软件包：

    yay -Rsn $(pacman -Qdtq)

### **重新开启 Secure Boot**

如果想去掉开机时的红色上边框，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参见：[Secure Boot - ArchWiki](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface/Secure_Boot#Using_a_signed_boot_loader)

## **参考资料**

BitLocker 恢复密钥
https://account.microsoft.com/devices/recoverykey?refd=account.microsoft.com

Windows 10 如何关闭快速启动
https://jingyan.baidu.com/article/ca00d56c7a40e6e99febcf4f.html

Win 10 如何关闭设备加密？关闭 BitLocker 加密图文教程
http://www.w10zj.com/Win10xy/Win10yh_8892.html

创建和使用 Surface 的 USB 恢复驱动器
https://support.microsoft.com/zh-cn/help/4023512/surface-creating-and-using-a-usb-recovery-drive

下载 Surface 的恢复映像
https://support.microsoft.com/zh-cn/surfacerecoveryimage

如何使用 Surface UEFI
https://support.microsoft.com/zh-cn/help/4023531/surface-how-to-use-surface-uefi

Win 10 环境下安装 Manjaro KDE（双系统） 
https://www.cnblogs.com/Jaywhen-xiang/p/11561661.html

Manjaro 20 KDE配置心得
https://blog.csdn.net/weixin_40293491/article/details/107526553

Manjaro 安装体验小结
https://zhuanlan.zhihu.com/p/76608451

Manjaro 安装后你需要这样做
https://www.cnblogs.com/haohao77/p/9034499.html#11-%E9%85%8D%E7%BD%AE%E5%AE%98%E6%96%B9%E6%BA%90

ArchWiki -- Sudo (简体中文)
https://wiki.archlinux.org/index.php/Sudo_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

在 Mac 上用 Openconnect 连接 Pulse Secure VPN
https://blog.yangl1996.com/post/use-openconnect-to-connect-to-pulse-secure-on-mac/

双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读
https://jakting.com/archives/ubuntu-rw-windows-files.html

Arch Wiki -- 关于 Logitech BLE 鼠标的问题
https://wiki.archlinux.org/index.php/Bluetooth_mouse#Problems_with_the_Logitech_BLE_mouse_(M557,_M590,_anywhere_mouse_2,_etc)

Linux-Surface -- Installation and Setup
https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup

Manjaro Forum -- 打字时 KDE 桌面卡死，鼠标可以移动，点击无效
https://forum.manjaro.org/t/kde/39610

Kde 桌面的 Mac 化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

Oh-My-Zsh 及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

Linux grub 删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969

AUR 镜像使用帮助
https://mirrors.tuna.tsinghua.edu.cn/help/AUR/

SJTUG 软件源镜像服务
https://mirrors.sjtug.sjtu.edu.cn/#/

Manjaro 为包管理器 pacman 和 yaourt/yay 添加多线程下载
https://blog.csdn.net/dc90000/article/details/101752743?utm_medium=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase&depth_1-utm_source=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase

pacman 中的 Pac-Man
https://blog.csdn.net/lujun9972/article/details/79576024?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromBaidu-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromBaidu-1.channel_param

Linux tar 命令总结
http://www.linuxdiyf.com/linux/2903.html

ArchWiki -- Microsoft fonts (简体中文)
https://wiki.archlinux.org/index.php/Microsoft_fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archlinux 使用 Windows 字体及相关配置
https://blog.csdn.net/sinat_33528967/article/details/93380729

ArchWiki -- Fcitx5 (简体中文)
https://wiki.archlinux.org/index.php/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

比较几种中文输入法后，我最终选择了 sunpinyin + cloudpinyin 组合
https://forum.manjaro.org/t/sunpinyin-cloudpinyin/114282

ArchWiki -- pacman (简体中文)
https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Font size of mailbox is too small
https://support.mozilla.org/zh-CN/questions/1297871

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复 Anaconda 环境, 卸载 Anaconda, 重装 Anaconda
https://blog.csdn.net/wangweiwells/article/details/88374361

Manjaro Wiki -- Switching Branches
https://wiki.manjaro.org/index.php?title=Switching_Branches

ArchWiki -- System time#Time standard
https://wiki.archlinux.org/index.php/System_time#Time_standard

ArchWiki -- Baloo
https://wiki.archlinux.org/index.php/Baloo

</font>
