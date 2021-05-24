# **在 Surface Pro 6 上安装 Manjaro 21 KDE Plasma + Windows 10 双系统的指南**

```
firestar@FIRESTAR
OS: Manjaro 21.0.4 Ornara
Kernel: x86_64 Linux 5.12.5-arch1-1-surface
Shell: bash 5.1.8
Resolution: 2736x1824
DE: KDE 5.82.0 / Plasma 5.21.5
WM: KWin
GTK Theme: Mojave-light-alt [GTK2/3]
Icon Theme: la-capitaine-icon-theme
CPU: Intel Core i5-8250U @ 8x 3.4GHz
GPU: Mesa Intel(R) UHD Graphics 620 (KBL GT2)
```

## **Windows 的准备工作**

### **关闭快速启动**

控制面板 --> 电源选项 --> 选择电源按钮的功能 --> 更改当前不可用的设置 --> 关闭快速启动 --> 保存修改

### **关闭设备加密**

开始菜单 --> 设置 --> 更新和安全 --> 设备加密 --> 关闭

### **进入 UEFI 设置**

关闭 Surface，然后等待大约 10 秒钟以确保其处于关闭状态

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮

屏幕上会显示 Microsoft 或 Surface 徽标，继续按住调高音量按钮，显示 UEFI 屏幕后，松开此按钮

Security --> Secure Boot --> Disabled（第三个选项）

### **制作启动盘**

从 Manjaro 官网上下载：

https://manjaro.org/downloads/official/kde/ （KDE Plasma 版本）

https://manjaro.org/get-manjaro/ （所有官方版本）

或者在 Github 上下载：

https://github.com/manjaro-plasma/download/releases （KDE Plasma 版本）

https://github.com/manjaro/release-review/releases （所有官方版本）

使用 [Rufus](https://github.com/pbatard/rufus) 刻录启动盘（注意启动盘如果用移动硬盘会无法被识别），直接选中镜像点确定即可

### **安装 Manjaro**

设置 --> 恢复 --> 立即重新启动 --> USB Storage

或按照以下步骤直接从 USB 启动:

关闭 Surface

将可启动 U 盘插入 Surface 上的 USB 端口

长按 Surface 上的调低音量按钮，同时按下并释放“电源”按钮，屏幕上会显示 Microsoft 或 Surface 徽标

继续按住调低音量按钮，释放按钮后，徽标下方将显示旋转圆点，按照屏幕说明从 USB 启动

#### **进入 Manjaro Hello 窗口开始安装**

语言选择“简体中文”

时区选择“Asia -- Shanghai”

安装时选择“替代一个分区”，并点击之前空出来的空分区

或者手动挂载空分区，挂载点设为 `/`，标记为 `root`，手动挂载 UEFI 分区（即第一个分区`dev/nvme0n1p1`，格式为 FAT32），不要格式化，挂载点设为 `/boot/efi`，标记为 `boot`

勾选“为管理员使用相同的密码”

## **初始配置**

### **电源与开机设置**

系统设置 --> 电源管理 --> 节能 --> 勾选“按键事件处理” --> 合上笔记本盖时 --> 选择“关闭屏幕” --> 勾选“即使已连接外部显示器”

系统设置 --> 开机与关机 --> 桌面会话 --> 登入时 --> 选择“以空会话启动”

#### **与电源管理相关的常见英文名词**

Suspend：挂起，Reboot：重启，Shutdown：关机，Logout：注销

### **高分辨率设置**

屏幕分辨率是2736×1824，需要配置高分屏优化：

系统设置 --> 显示和监控 --> 显示配置 --> 分辨率 --> 全局缩放 --> 200%

系统设置 --> 光标 --> 大小 --> 36

然后重启电脑

### **快捷键配置**

#### **全局快捷键**

为打开方便，可以采用 i3wm 的默认快捷键打开 Konsole：

系统设置 --> 快捷键 --> 添加应用程序 --> Konsole --> Konsole 的快捷键设为 `Meta+Return`（即“Windows 徽标键 + Enter 键”）

#### **Konsole 快捷键**

设置 --> 配置键盘快捷键 --> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V`

### **选择镜像并更改更新分支**

选择镜像：（建议选择上海交大的镜像，其更新频率最高）

    sudo pacman-mirrors -i -c China

更改更新分支：（更新分支 `(branch)` 可以选择 stable/testing/unstable）

    sudo pacman-mirrors --api --set-branch (branch)
    sudo pacman -Syyu

一个简洁的替代版（但不能自己选择镜像，只能按照访问速度从高到低排列）：

    sudo pacman-mirrors --geoip --api --set-branch testing && sudo pacman -Syyu

### **包管理器**

Manjaro 常用的包管理器有 pacman、pamac 和 yay，其使用教程参考以下网址：

Manjaro Wiki -- Pacman Overview
https://wiki.manjaro.org/index.php/Pacman_Overview

Manjaro Wiki -- Pacman-mirrors
https://wiki.manjaro.org/index.php/Pacman-mirrors

ArchWiki -- Pacman
https://wiki.archlinux.org/index.php/Pacman

Manjaro Wiki -- Pamac
https://wiki.manjaro.org/index.php/Pamac

GitHub -- Yay
https://github.com/Jguer/yay

其中 pacman 和 pamac 是预装的，“添加/删除软件”就是 pamac 的 GUI 版本，而 yay 需要自己下载：

    sudo pacman -S yay

yay 的命令一般和 pacman 一样，只是将 `sudo pacman` 替换成 `yay`

硬件管理的包管理器是 mhwd 和 mhwd-kernel，其使用教程参考以下网址：

Manjaro Wiki -- Manjaro Hardware Detection Overview
https://wiki.manjaro.org/index.php/Manjaro_Hardware_Detection_Overview

Manjaro Wiki -- Configure Graphics Cards
https://wiki.manjaro.org/index.php/Configure_Graphics_Cards

Manjaro Wiki -- Manjaro Kernels
https://wiki.manjaro.org/index.php/Manjaro_Kernels

这两个也可以在 Manjaro Settings Manager （GUI 版本）中使用

### **AUR**

#### 安装 base-devel

AUR 上的某些 PKGBUILD 会默认你已经安装 `base-devel` 组的所有软件包而不将它们写入构建依赖。为了避免在构建过程中出现一些奇怪的错误，建议先安装 `base-devel`：

    sudo pacman -S base-devel

#### 启用 pamac 的 AUR 支持

添加/删除软件 --> 右上角 ··· --> 首选项 --> AUR --> 启用 AUR 支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build` 及 `pamac install` 获取 AUR 的软件包。

#### yay 反向代理配置

执行以下命令以启用清华的 AUR 反向代理:

    yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
    yay -Syyu

修改的配置文件位于 `~/.config/yay/config.json` ，还可通过以下命令查看修改过的配置：

    yay -P -g

### **Arch Linux CN 软件源**

在 `/etc/pacman.conf` 文件末尾添加以下两行以启用清华镜像：

    [archlinuxcn]
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch

之后执行下面的命令安装 archlinuxcn-keyring 包导入 GPG key

    sudo pacman -Sy archlinuxcn-keyring
    sudo pacman -Syyu

由于 Manjaro 的更新滞后于 Arch，使用 Arch Linux CN 仓库可能会出现“部分更新”的情况，导致某些软件包损坏

建议切换到 testing 或 unstable 分支以尽量跟进 Arch 的更新

#### **搜索软件包**

在 `pamac` 上可以执行：

    pamac search (package_name)

#### **检查依赖关系**

以树状图的形式展示某软件包的依赖关系：

    pactree (package_name)

#### **降级软件包**

在 `/var/cache/pacman/pkg/` 中找到旧软件包，双击打开安装实现手动降级，参考以下网址：

Downgrading Packages -- ArchWiki
https://wiki.archlinux.org/title/Downgrading_packages_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

#### **清理缓存**

清理全部软件安装包：

    yay -Scc

或者：

    pamac clean

删除软件包时清理设置文件：

    yay -Rn (package_name)

清理无用的孤立软件包：

    yay -Rsn $(pacman -Qdtq)

或者：

    pamac remove -o

若不小心终止了 `pacman` 进程，则需要先删除 `/var/lib/pacman/db.lck` 才能再次启动 `pacman`

#### **从本地安装包安装软件**

pacman 有从本地安装包安装软件的功能，只需输入：

    sudo pacman -U (package_path)/(package_name)

### **切换到 video-modesetting**

有时候打字时桌面卡死，只有鼠标能移动，但是无法点击

可能是 video-linux 显卡驱动的问题，已经有此类问题的报告和建议，参考以下网址：

Arch Wiki -- Cinnamon
https://wiki.archlinux.org/index.php/Cinnamon#Installation

Arch Wiki -- Intel Graphics
https://wiki.archlinux.org/index.php/Intel_graphics#Installation

KDE Community -- Plasma 5.9 Errata
https://community.kde.org/Plasma/5.9_Errata#Intel_GPUs

解决办法：

卸载 video-linux：

    sudo mhwd -r pci video-linux

下载 video-modesetting：

    sudo mhwd -i pci video-modesetting

**重启后会发现许多窗口和图标变小，建议先调整全局缩放为100%，重新启动，再调至200%，再重启**

### **Linux-Surface 内核安装**

**安装和更新 Linux-Surface 需要登录北京大学 VPN**

在终端中输入：

    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
    | sudo pacman-key --add -

如果出现错误，则需要先修改 hosts 文件，再操作

接着输入：

    sudo pacman-key --finger 56C464BAAC421453
    sudo pacman-key --lsign-key 56C464BAAC421453

在 `/etc/pacman.conf` 里面添加：

    [linux-surface]
    Server = https://pkg.surfacelinux.com/arch/

然后更新软件库并下载：

    sudo pacman -Syyu
    sudo pacman -S linux-surface linux-surface-headers iptsd

启动触屏：

    sudo systemctl enable iptsd

### **下载 vim**

建议先下载 vim，方便之后编辑各种文件：

    sudo pacman -S vim

### **更改 visudo 默认编辑器为 vim**

首先在终端中输入：

    sudo visudo

在开头的一个空行键入：

    Defaults editor=/usr/bin/vim

按 `Esc` 进入命令模式，再按 `:x` 保存，按 `Enter` 退出

### **sudo 免密码**

在最后一行（空行）按 `i` 进入输入模式，加上这一行：

    Defaults:(user_name) !authenticate

进入命令模式，保存退出即可

**注：如果想保留输入密码的步骤但是想在输入密码时显示星号，则加上一行 `Defaults env_reset,pwfeedback` 即可**

### **命令行界面输出语言为英语**

在 `~/.bashrc` 的最后添加一行：

    export LANG=en_US.UTF-8

如果使用 zsh，则去掉 `~/.zshrc` 中这一行的注释即可

### **双系统时间不同步 + 24小时制**

#### **双系统时间不同步**

系统设置 --> 时间和日期 --> 自动设置时间和日期

在 Manjaro 上设置硬件时间为 UTC：

    sudo timedatectl set-local-rtc 0

并在 Windows 上设置硬件时间为 UTC，与 Manjaro 同步：

    reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_QWORD /f

这一步需要在 Powershell（管理员）中执行

#### **Manjaro 设置24小时制**

右键点击“数字时钟” --> 配置数字时钟 --> 时间显示 --> 24小时制

#### **添加 TUNA 网络授时服务**

参考以下网址：

TUNA NTP (网络授时) 服务使用说明
https://tuna.moe/help/ntp/

### **Git 配置用户名、邮箱及免密码设置**

    git config --global user.name "(user_name)"
    git config --global user.email "(user_email)"       
    sudo vim .git-credentials

写入如下语句：

    https://(user_name):(user_password)@github.com

保存退出

    git config --global credential.helper store

### **hosts 文件设置（可选）**

参考以下网址：

修改 hosts 解决 GitHub 访问失败
https://zhuanlan.zhihu.com/p/107334179

为了防止 DNS 污染导致 GitHub 图片打不开，需要在 `/etc/hosts` 文件中添加如下语句：

```
## GitHub Start
140.82.113.4 github.com
140.82.114.10 nodeload.github.com
140.82.113.5 api.github.com
140.82.114.10 codeload.github.com
199.232.96.133 raw.github.com
185.199.108.153 training.github.com
185.199.108.153 assets-cdn.github.com
185.199.108.153 documentcloud.github.com
185.199.108.154 help.github.com

185.199.108.153 githubstatus.com
199.232.69.194 github.global.ssl.fastly.net

185.199.110.133 raw.githubusercontent.com
185.199.110.133 cloud.githubusercontent.com
185.199.110.133 gist.githubusercontent.com
185.199.110.133 marketplace-screenshots.githubusercontent.com
185.199.110.133 repository-images.githubusercontent.com
185.199.110.133 user-images.githubusercontent.com
185.199.110.133 desktop.githubusercontent.com

185.199.110.133 avatars.githubusercontent.com
185.199.110.133 avatars0.githubusercontent.com
185.199.110.133 avatars1.githubusercontent.com
185.199.110.133 avatars2.githubusercontent.com
185.199.110.133 avatars3.githubusercontent.com
185.199.110.133 avatars4.githubusercontent.com
185.199.110.133 avatars5.githubusercontent.com
185.199.110.133 avatars6.githubusercontent.com
185.199.110.133 avatars7.githubusercontent.com
185.199.110.133 avatars8.githubusercontent.com
## GitHub End
```

Windows 下对应的文件位置为： `C:\Windows\System32\drivers\etc\hosts` （注意这里是反斜杠）

IP 地址可以通过对域名 `ping` 得到，例如：

    ping github.com

### **动态 Swap 文件设置**

**使用 swap 分区可能会缩短 SSD 的寿命，如果需要 swap 的话建议用 swap 文件，详见 [Swap（简体中文）- Arch Wiki](https://wiki.archlinux.org/index.php/Swap_(简体中文)#交换文件)**

先下载 `systemd-swap` 软件包：

    yay -S systemd-swap

编辑 `/etc/systemd/swap.conf`:

    sudo vim /etc/systemd/swap.conf

去掉 `swapfc_enabled` 前的注释并设置为 `swapfc_enabled=1` ，保存并关闭

在终端输入

    sudo systemctl enable --now systemd-swap

以启动`systemd-swap`服务

### **连接北京大学校园网**

#### **命令行连接 PKU WiFi**

连接校园网 WiFi 可以使用脚本 pkuipgw，可以在[北大未名BBS](https://bbs.pku.edu.cn/v2/post-read-single.php?bid=13&type=0&postid=14139459)上下载

#### **命令行连接 PKU VPN**

按 `Fn+F12` 打开 Yakuake，输入：

    sudo openconnect --protocol=nc --user (student_ID) https://vpn.pku.edu.cn

输入密码即可连接

之后可以按 `Fn+F12` 让它收起，不要关闭窗口（关闭窗口则VPN断开）

### **Linux 挂载 Windows 磁盘**

**首先要确保设备加密已经关闭，这个时候一般来讲会自动显示出来，在 Dolphin 中点击即可挂载**

**如果要挂载 C 盘请确保快速启动已经关闭**

在终端中输入：

    lsblk -f

在输出结果中可以发现 Windows 的硬盘分区，每个分区有一段 `UUID` 的信息，选中复制下来 

接着就来修改系统文件：

    sudo vim /etc/fstab

在最后加入这两行：

    UUID=(UUID)                     /home/firestar/C    ntfs-3g uid=firestar,gid=users,auto 0 0
    UUID=(UUID)                     /home/firestar/D    ntfs-3g uid=firestar,gid=users,auto 0 0

重启电脑后，即可自动挂载

**如果需要格式化 C 或 D 盘，先从 `/etc/fstab` 中删去这两行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

#### **如果文件系统突然变成只读**

一般来讲是 Windows 开启了快速启动，或者进行了优化磁盘等操作导致的，下面以 D: 盘为例：

首先在 Windows 中关闭快速启动，重启电脑

若不能解决问题，使用下面的方法：

检查占用进程：

    sudo fuser -m -u /dev/nvme0n1p5

可以看到数字，就是占用目录的进程 PID，终止进程：

    sudo kill (PID_number)

取消挂载：

    sudo umount /dev/nvme0n1p5

执行硬盘 NTFS 分区修复：

    sudo ntfsfix /dev/nvme0n1p5

再重新挂载即可：

    sudo mount /dev/nvme0n1p5 ~/D

### **调整文件夹名称为英文**

修改 `~/.config/user-dirs.dirs`，改为：
    
    XDG_DESKTOP_DIR="$HOME/Desktop"
    XDG_DOCUMENTS_DIR="$HOME/Documents"
    XDG_DOWNLOAD_DIR="$HOME/Downloads"
    XDG_MUSIC_DIR="$HOME/Music"
    XDG_PICTURES_DIR="$HOME/Pictures"
    XDG_PUBLICSHARE_DIR="$HOME/Public"
    XDG_TEMPLATES_DIR="$HOME/Templates"
    XDG_VIDEOS_DIR="$HOME/Videos"

并在 Dolphin 中按照上面的说明更改文件名

### **Dolphin 在更新后删除文件/文件夹报错**

如果出现以下错误：

    无法创建输入输出后端。klauncher 回应：装入“/usr/lib/qt/plugins/kf5/kio/trash.so”时出错

说明 Qt 还在内存中保留着旧版 Dolphin，此时可以重启/重新登录，或执行：

    dbus-launch dolphin

### **SONY WH-1000XM3 耳机连接**

长按耳机电源键约7秒即可进入配对模式，可以在蓝牙中配对

### **Logitech M590 鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Manjaro 系统在鼠标上会被识别为两个设备

如果 Windows 系统被识别为设备1，需要按滚轮后的圆形按钮切换至设备2

长按圆形按钮直到灯2快速闪烁进入配对模式，可以在蓝牙中配对

#### **如果鼠标配对后屏幕光标无法移动**

首先要安装 `bluez-utils`：

    yay -S bluez-utils

在终端中输入：

    bluetoothctl

然后参考以下网站：

Arch Wiki -- 关于Logitech BLE鼠标的问题
https://wiki.archlinux.org/index.php/Bluetooth_mouse#Problems_with_the_Logitech_BLE_mouse_(M557,_M590,_anywhere_mouse_2,_etc)

### **解决用 root 登录没有声音的问题**

在 `/root/.config/autostart/` 下创建一个 `pulseaudio.desktop` 文件：

    sudo vim /root/.config/autostart/pulseaudio.desktop

写入：

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

登录时默认进入的是图形化界面，有时候开机后黑屏是图形化界面显示不出来所致，此时可以按快捷键 `Ctrl+Alt+Fn+(F2~F6)`进入`tty2 ~ tty6` 的任何一个命令行界面

注意此时需要手动输入用户名和密码

在命令行界面解决问题后，按快捷键 `Ctrl+Alt+Fn+F1` 可以转换回图形化界面

### **调整 CPU 频率（可选）**

    sudo vim /etc/tlp.conf

若更改 CPU 频率，修改以下位置：

    CPU_MIN_PERF_ON_AC=0
    CPU_MAX_PERF_ON_AC=100
    CPU_MIN_PERF_ON_BAT=0
    CPU_MAX_PERF_ON_BAT=30

若更改 CPU 睿频设置，修改以下位置：

    CPU_BOOST_ON_AC=1
    CPU_BOOST_ON_BAT=0

**不需要高性能的时候可以关闭睿频，这样 CPU 的频率就会限制在 1.9 GHz 以下，大幅增加续航、减少发热**

保存、关闭，在终端中输入：

    sudo tlp start

#### **显示 CPU 频率（可选）**

安装 KDE 小部件：[Intel P-state and CPU-Freq Manager](https://github.com/jsalatas/plasma-pstate)

右键点击顶栏，选择“添加部件”，找到 Intel P-state and CPU-Freq Manager 并添加在顶栏即可

### **禁用 baloo（可选）**

`baloo` 是 KDE 的文件索引服务，能加快文件搜索的速度，但可能会时不时产生大量硬盘读写而导致图形界面卡顿。可以用下面的命令禁用之：

    balooctl disable

### **为 pacman 和 yay 添加多线程下载（可选）**

执行下面的命令下载 axel

     yay -S axel

编辑 `/etc/pacman.conf` 文件（在第21行）:

    XferCommand = /usr/bin/axel -n 10 -o %o %u

编辑 `/etc/makepkg.conf` 文件（在第11-16行）:

    DLAGENTS=('file::/usr/bin/curl -gqC - -o %o %u'
          'ftp::/usr/bin/axel -n 10 -o %o %u'
          'http::/usr/bin/axel -n 10 -o %o %u'
          'https::/usr/bin/axel -n 10 -o %o %u'
          'rsync::/usr/bin/rsync --no-motd -z %u %o'
          'scp::/usr/bin/scp -C %u %o')

### **关闭启动时的系统信息**

参考以下网址：

Silent Boot -- ArchWiki
https://wiki.archlinux.org/title/Silent_boot

### **重新开启 Secure Boot（未测试）**

如果想去掉开机时的红色上边框，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参考以下网址：

Secure Boot -- ArchWiki
https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface/Secure_Boot#Microsoft_Windows

## **一些有用的命令总结**

### **获取设备信息**

#### 简要信息

在终端中输入：

    screenfetch

或者：

    sudo inxi -b

#### 详细信息

在终端中输入：

    sudo inxi -Fa

#### 命令行进程查看器

在终端中输入：

    htop

#### 内存大小

在终端中输入：

    free

#### 上一次关机的系统日志

    journalctl -rb -1

### **转换格式**

批量将图片从 PNG 格式转换为 JPG 格式：

    ls -1 *.png | xargs -n 1 bash -c 'convert "$0" "${0%.png}.jpg"'

**Linux 的内存策略可以参考这个网站：https://www.linuxatemyram.com/**

## **美化**

**一定要先美化再装软件！**

### **添加用户图标**

系统设置 --> 用户账户 --> 图像

### **开机登录美化**

开机与关机 --> 登录屏幕（SDDM） --> Fluent

外观 --> 欢迎屏幕 --> ManjaroLogo Black 或者 Snowy Night Miku 或者 Manjaro Linux Reflection Splashscreen

#### **主题美化（可选）**

参考以下网址：

KDE 桌面的 Mac 化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

其中 Plasma 主题、GTK主题和图标主题分别选择：
    
    Plasma Theme: Mojave-CT
    GTK Theme: Mojave-light-alt [GTK2/3]
    Icon Theme: La Capitaine

KDE 桌面美化指南
https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/

Latte-Dock 的推荐设置：

行为：位置 --> 底部，可见性 --> 自动隐藏，延迟 --> 显示 --> none

外观：绝对大小 --> 96，背景大小 --> 10%

#### **zsh 与 Oh-My-Zsh 配置（可选）**

Konsole --> 设置 --> 编辑当前方案 --> 常规 --> 命令 --> `usr/bin/zsh`

安装 Oh-My-Zsh，执行：（不推荐用包管理器安装）

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

安装插件，执行：

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

编辑设置文件：

    vim ~/.zshrc

选择 Oh-My-Zsh 主题：

    ZSH_THEME="geoffgarside"

选择 Oh-My-Zsh 插件：

    plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

更新 Oh-My-Zsh，执行：

    omz update

卸载 Oh-My-Zsh，执行:

    uninstall_oh_my_zsh

#### **如果遇到开关机的时候报错：\[FAILED] failed to start pkgfile database update**

卸载 `manjaro-zsh-config`，这会卸载 `zsh` 及其所有依赖，然后重新安装 `zsh` 和 `nerd-fonts-noto-sans-mono`

#### **GRUB 美化**

选择主题 Slaze ，下载地址如下：

https://github.com/vinceliuice/grub2-themes

以 Slaze grub theme （2K，黑白图标） 为例，解压后在文件夹内执行：

    sudo ./install.sh -b -t slaze -i white -s 2k

删除多余启动条目，需要修改`/boot/grub/grub.cfg`

删除整一段 `submenu 'Manjaro Linux 的高级选项'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (on /dev/nvme0n1p1)` 改为 `Windows`

恢复默认的`/boot/grub/grub.cfg`需要输入：

    echo GRUB_DISABLE_OS_PROBER=false | sudo tee -a /etc/default/grub && sudo update-grub

#### **pacman 添加吃豆人彩蛋**

编辑 `/etc/pacman.conf`

    sudo vim /etc/pacman.conf

去掉 `Color` 前面的注释，并在下一行添加：

    ILoveCandy

即可添加吃豆人彩蛋

## **下载软件**

**能用包管理器的尽量用包管理器安装！**

### **PGP 密钥无法导入**

如果安装软件时需要导入 PGP 密钥而发生 `gpg: 从公钥服务器接收失败：一般错误` 的问题，将 PGP 密钥复制下来并运行：

    gpg --keyserver p80.pool.sks-keyservers.net --recv-keys (pgp_key)

再重新安装软件即可

### **语言包**

系统设置 --> 语言包 --> 右上角点击“已安装的软件包”安装语言包

### **Kate 插件下载**

在用命令行打开 Kate 编辑文件时若不想报如下错误：

```
kf.service.sycoca: The menu spec file contains a Layout or DefaultLayout tag without the mandatory Merge tag inside. Please fix your file.
kf.sonnet.core: Sonnet: Unable to load plugin "/usr/lib/qt/plugins/kf5/sonnet/sonnet_aspell.so" Error: "Cannot load library /usr/lib/qt/plugins/kf5/sonnet/sonnet_aspell.so: (libaspell.so.15: cannot open shared object file: No such file or directory)"
kf.sonnet.core: Sonnet: Unable to load plugin "/usr/lib/qt/plugins/kf5/sonnet/sonnet_hspell.so" Error: "Cannot load library /usr/lib/qt/plugins/kf5/sonnet/sonnet_hspell.so: (libhspell.so.0: cannot open shared object file: No such file or directory)"
kf.sonnet.core: Sonnet: Unable to load plugin "/usr/lib/qt/plugins/kf5/sonnet/sonnet_voikko.so" Error: "Cannot load library /usr/lib/qt/plugins/kf5/sonnet/sonnet_voikko.so: (libvoikko.so.1: cannot open shared object file: No such file or directory)"
kf.sonnet.core: No language dictionaries for the language: "C" trying to load en_US as default
kf.kio.core: We got some errors while running testparm "Error loading services."
kf.kio.core: We got some errors while running 'net usershare info'
kf.kio.core: "Can't load /etc/samba/smb.conf - run testparm to debug it\n"
```

需要下载插件：

    yay -S aspell hspell libvoikko

### **安装微软字体**

安装方法如下：

    sudo mkdir /usr/share/fonts/winfonts
    sudo cp (win-font-path)/* /usr/share/fonts/winfonts/
    cd /usr/share/fonts/winfonts/
    fc-cache -fv

这样就可以安装微软雅黑、宋体、黑体等字体了

**注意需要排除掉 MS Gothic、Yu Gothic 字体，因它们只有部分日文汉字字形（与中文汉字字形一样的会被排除，最后导致部分中文汉字显示为日文字形）**

### **更改程序和终端默认中文字体**

输入命令：

    sudo vim /etc/fonts/conf.d/64-language-selector-prefer.conf

并加入以下内容：

```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <alias>
        <family>sans-serif</family>
        <prefer>
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
            <family>Noto Serif CJK SC</family>
            <family>Noto Serif CJK TC</family>
            <family>Noto Serif CJK HK</family>
            <family>Noto Serif CJK JP</family>
            <family>Noto Serif CJK KR</family>
        </prefer>
    </alias>
    <alias>
        <family>monospace</family>
        <prefer>
            <family>JetBrains Mono NL</family>
            <family>JetBrains Mono</family>
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

推荐使用 Fcitx5:

    yay -S fcitx5 fcitx5-chinese-addons manjaro-asian-input-support-fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool

如果无法启动输入法，在系统设置 --> 区域设置 --> 输入法 --> 添加输入法中手动添加“拼音”

对应的 git 版本为：（需要使用 Arch Linux CN 源）

    yay -S fcitx5-git fcitx5-chinese-addons-git manjaro-asian-input-support-fcitx5 fcitx5-gtk-git fcitx5-qt5-git fcitx5-configtool-git

可以添加词库：

    yay -S fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki

一个稳定的替代版本是 Fcitx 4.2.9.8-1：

    yay -S fcitx-im fcitx-configtool fcitx-cloudpinyin manjaro-asian-input-support-fcitx

可以配合 googlepinyin 或 sunpinyin 使用，即执行：

    yay -S fcitx-googlepinyin

或者：（`yay -S sunpinyin`也可以）

    yay -S fcitx-sunpinyin

**安装输入法之后需要重启电脑才能生效**

### **安装其它软件**

以下命令中的 `yay -S` 也可以在“添加/删除软件”（即 pamac）中搜索安装，或者用 `pamac install` 安装（需要使用 AUR 软件仓库）

    yay -S texstudio stellarium typora v2ray qv2ray geogebra telegram-desktop vlc thunderbird qbittorrent baidunetdisk-bin

**如果用 `yay -S nautilus` 安装了 nautilus 则用 `sudo nautilus` 就可以访问没有权限粘贴/删除的文件夹（不推荐）**

很多 KDE 应用不支持直接以 root 的身份运行，但是在需要提权的时候会自动要求输入密码

例如 Kate，可以先用普通用户的身份打开文件，保存时如果需要 root 权限就会弹出密码输入框

#### **用 debtap 安装 `.deb` 包（不推荐）**

首先要下载并更新 debtap 包：

    yay -S debtap
    sudo debtap -u

**运行 `sudo debtap -u` 时建议连接北京大学 VPN**

进入含有 `.deb` 安装包的文件夹，输入：

    sudo debtap (package_name).deb

系统会询问三个问题：文件名随便写，协议写 `GPL` 即可，编辑文件直接按 `Enter` 跳过 

此处会生成一个 `tar.zst` 包，双击打开（右键用“软件安装程序”打开）即可安装 

### **安装 TeX Live**

推荐从 ISO 安装 TeX Live，下面以 TeX Live 2021 为例

首先在[清华大学镜像站](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/)或者[上海交大镜像站](https://mirrors.sjtug.sjtu.edu.cn/ctan/systems/texlive/Images/)下载 TeX Live ISO，文件名为 texlive.iso

打开终端，运行：

    sudo mount -t iso9660 -o ro,loop,noauto (texlive_path)/texlive2021.iso /mnt

#### **使用图形界面安装**

首先要检查是否安装 tcl 和 tk：

    yay -S tcl tk

进入镜像文件夹，运行：

    sudo perl install-tl -gui

即可在图形界面下载 TeX Live（如果不加 `sudo` 则只能将其安装到 `/home/(user_name)/` 下的文件夹且无法勾选 Create symlinks in standard directories: 一项），高级设置需要点击左下角的 Advanced 按钮

**记住勾选 Create symlinks in standard directories 一项（自动添加到 PATH），Specify directories 选择默认文件夹即可，之后不需要自己添加 PATH**

#### **使用命令行界面安装**

进入镜像文件夹，运行：

    sudo perl install-tl -gui text

用大写字母命令控制安装：

    D --> 1 --> 输入要安装 TeX Live 的位置（TEXDIR） --> R
    O --> P --> L --> 都选择默认位置（按 Enter） --> R
    I

TEXDIR 建议选择 `/home/(user_name)/` 下的文件夹以方便查看和修改，TEXMFLOCAL 会随 TEXDIR 自动更改

CTAN 镜像源可以使用 TeX Live 管理器 tlmgr 更改，更改到清华大学镜像需要在命令行中执行：

    sudo tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
    sudo tlmgr --repository http://www.texlive.info/tlgpg/ install tlgpg

可以运行 `tex --version` 检查是否安装成功，若成功应显示（以 Tex Live 2021 为例）：

    TeX 3.141592653 (TeX Live 2021)
    kpathsea version 6.3.3
    Copyright 2021 D.E. Knuth.
    There is NO warranty.  Redistribution of this software is
    covered by the terms of both the TeX copyright and
    the Lesser GNU General Public License.
    For more information about these matters, see the file
    named COPYING and the TeX source.
    Primary author of TeX: D.E. Knuth.

还可以运行 `tlmgr --version` 和 `texdoc (package_name)` （选择常见的宏包名称如 `texdoc ctex`）检查是否安装成功

### **TeXstudio 配置**

帮助 --> 检查 LaTeX 安装信息

如果能检测到 LaTeX，说明 TeX Live 安装成功，开始设置

选项 --> 设置 TeXstudio

首先在左下角勾选“显示高级选项”

常规 --> 会话 --> 取消勾选“启动时恢复上一次会话”（可选）

菜单 --> 数学 --> `\frac{}{}` --> `\frac{%|}{}`

菜单 --> 数学 --> `\frac{}{}` --> `\frac{%|}{}`

快捷键 --> 数学 --> 数学字体格式 --> 罗马字体 --> 当前快捷键 --> `Alt+Shift+R`

编辑器 --> 缩进模式 --> 自动增加或减少缩进

编辑器 --> 缩进模式 --> 勾选“将缩进替换为空格”和“将文本中的制表符（Tab）替换为空格”

编辑器 --> 显示行号 --> 所有行号

编辑器 --> 取消勾选“行内检查”

高级编辑器 --> 自动保存所有文件 --> 1分钟

高级编辑器 --> 破解/变通 --> 取消勾选“自动选择最佳显示选项”，并勾选“禁用字符宽度缓存”和“关闭固定位置模式”

补全 --> 取消勾选“输入参数”

### **安装 KDE 的 Wayland 支持（不推荐）**

与 Xorg 相比，Wayland 对触屏的支持更佳，但某些应用在 Wayland 上会有兼容性问题，目前 KDE 对 Wayland 的支持处于能用但还不太完善的状态

    yay -S plasma-wayland-session

安装后即可在登录界面选择 Wayland 会话

### **Firefox Developer Edition 设置**

在 `~/.bashrc` 中添加一句：

    alias firefox='firefox-developer-edition'

这样就可以直接输入 `firefox` 以启动 Firefox Developer Edition

**Firefox 启用触屏需要在 `/etc/environment` 中写入 `MOZ_USE_XINPUT2=1`，然后重新启动，并在 about:config 中设置 `apz.allow_zooming` 和 `apz.allow_zooming_out` 为 `true`**

### **Thunderbird 配置**

#### **Thunderbird 首选项配置**

进入首选项界面调整显示：

首选项 --> 常规 --> Thunderbird 起始页 --> 清空并取消勾选

首选项 --> 常规 --> 默认搜索引擎 --> 改为 Bing

首选项 --> 隐私与安全 --> 邮件内容 --> 勾选“允许消息中的远程内容”

右键点击上方邮件工具栏，选择“自定义”，自行配置即可

#### **Thunderbird 帐号配置**

点击邮箱帐号，配置“账户设置”如下：

服务器 --> 服务器设置 --> 每隔1分钟检查一次新消息

服务器 --> 服务器设置 --> 在删除消息时 --> 立即删除

### **Miniconda 安装与配置**

Miniconda 是 Anaconda 的精简版，推荐使用 Miniconda

下载地址如下：

Miniconda -- Conda documentation
https://docs.conda.io/en/latest/miniconda.html

或者在[清华大学镜像站](https://mirrors.tuna.tsinghua.edu.cn/#)点击右侧的“获取下载链接”按钮，在“应用软件” --> Conda 里面选择

安装过程参考以下网址：（Miniconda 和 Anaconda 安装步骤相同）

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

输入以下命令：

    vim ~/.condarc

修改 `.condarc` 以使用北京大学镜像源：

```
channels:
    - defaults
show_channel_urls: true
default_channels:
    - https://mirrors.pku.edu.cn/anaconda/pkgs/main
    - https://mirrors.pku.edu.cn/anaconda/pkgs/r
custom_channels:
    conda-forge: https://mirrors.pku.edu.cn/anaconda/cloud
    pytorch: https://mirrors.pku.edu.cn/anaconda/cloud
```

若不用镜像源，改为：

```
channels:
  - defaults
ssl_verify: true
```

下载所需要的包：

    conda install numpy scipy matplotlib

Spyder 推荐使用 4.2.5 （Spyder 5.0.0 对高分辨率支持不佳）：

    conda install spyder=4.2.5

#### **Conda 常用命令**

下载包：

    conda install (package_name)

下载特定版本的包：

    conda install (package_name)=(version_number)

恢复之前的版本：

    conda list --revisions
    conda install --revision (revision_number)

**如果回滚到早期版本（`revision_number` 较小）之后又想回到某个高版本（`revision_number` 较大），必须要把两个版本中的版本都装一遍**

删除所有旧版本的包：

    conda clean -p

列出所有下载的包：

    conda list

用 Spyder 打开某个文件需要在终端中输入：

    spyder (file_path)/(file_name)

#### **Spyder 配置**

通用 --> 显示器分辨率 --> 普通

外观 --> 语法高亮主题 --> IDLE

编辑选定的方案：

文本：

```
普通文本 #000000
注释：#ff0000, B
字符串：#00aa00
数值：#995500
关键字：#ff7700, B
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

编辑器 --> 勾选“显示标签栏”、“显示缩进指导”、“显示行号”、“高亮显示当前行”、“高亮显示当前 Cell”，并把“高亮延迟时间”设定为100毫秒

### **Vim 安装插件**

执行：

    git clone (github_repository_URL) ~/.vim/pack/(plugin_name)/start/(plugin_name)
    vim -u NONE -c "helptags ~/.vim/pack/(plugin_name)/start/(plugin_name)/doc" -c q

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用 `code` 命令打开：

    yay -S code

微软官方的二进制 release（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯 Code - OSS 的图标，个人推荐首选此项）：

    yay -S visual-studio-code-bin

内测版本：

    yay -S visual-studio-code-insiders

第三方发布的从开源代码构建的二进制包：

    yay -S vscodium-bin

从最新的开源代码构建：

    yay -S code-git

下载扩展：Python, Jupyter, Markdown All in One, Chinese (Simplified) Language Pack for Visual Studio Code, Bracket Pair Colorizer 2, Latex Workshop, C/C++

#### **Visual Studio Code 图标更改（可选）**

如果图标美化后 Visual Studio Code 图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 --> 编辑应用程序 --> Visual Studio Code --> 点击图标更改 --> 其他图标

#### **Visual Studio Code 缩放比例**

放大比例：`Ctrl+=`

缩小比例：`Ctrl+-`

#### **Visual Studio Code 启用触屏**

更改 `/usr/share/applications/visual-studio-code.desktop`，在 `Exec` 一行中加入命令 `--touch-events`，这一般对以 Electron 为基础的软件有效

#### **Visual Studio Code 的 C/C++ 环境配置（未测试）**

参考以下网址：

基于 VS Code + MinGW-w64 的 C/C++ 简单环境配置
https://zhuanlan.zhihu.com/p/77074009

注意：下载插件 C/C++ Compile Run 后只要按 `Fn+F6` 即可编译运行 C/C++ 程序，但是不能调试。调试环境的配置请参考以下网址：

VS Code 之 C/C++ 程序的 debug 功能简介
https://zhuanlan.zhihu.com/p/85273055

### **Typora 设置**

#### **源代码模式**

更改 `/usr/share/typora/resources/style/base-control.css`：

找到 `.CodeMirror.cm-s-typora-default div.CodeMirror-cursor` 一行，将光标宽度改为 `1px`，颜色改为 `#000000`

找到 `#typora-source .CodeMirror-lines` 一行，将 `max-width` 改为 `1200px`

更改 `/usr/share/typora/resources/style/base.css`：

找到 `:root` 一行，将 `font-family` 改成自己想要的等宽字体

#### **实时显示模式**

在 `/home/(user_name)/.config/Typora/themes/` 中自己写一个 CSS 文件（可以复制其中一个默认主题，重命名后更改）

找到 `#write` 一行，将 `max-width` 改为 `1200px`

### **WPS 安装**

运行：

    yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts

### **微信**

可以在 pamac 中搜索：

    pamac search wechat

极简版（推荐，原生适配高分辨率屏幕，不需要 wine/deepin-wine 即可运行，对收发文件的支持较好，但是功能较少，不支持截屏和“订阅号消息”）：

```
wechat-uos                                                                           2:2.0.0-1145141919    AUR 
    UOS专业版微信 (迫真魔改版)
```

功能较多，但依赖 deepin-wine ，且对截屏和收发文件的支持不佳的版本：

```
com.qq.weixin.spark                                                                  3.1.0.41spark0-2      AUR 
    Tencent WeChat Client on Deepin Wine 5 (from Spark Store)
```

高分辨率适配调整：

    WINEPREFIX=~/.deepinwine/Spark-WeChat deepin-wine5 winecfg

Graphics --> Screen Resolution --> 192 dpi

### **网易云音乐**

可以在 pamac 中搜索：

    pamac search netease-cloud-music

功能较多的版本：

```
netease-cloud-music-imflacfix                                                        1.2.1-1        AUR 
    Netease Cloud Music, converted from .deb package, with IBus input method and online SQ support
```

极简版（原生适配高分辨率屏幕，但是功能较少，不支持歌词滚动和正在播放的曲子在歌单上标记）：

```
electron-netease-cloud-music                                                         0.9.26-1       AUR 
    UNOFFICIAL client for music.163.com . Powered by Electron, Vue, and Muse-UI.
```

### **能用上触控笔的软件（可选）**

#### **绘画**

    yay -S krita

#### **手写笔记**

可以选择 Xournal++ 或者 Write

    yay -S xournalpp
    yay -S write_stylus

### **屏幕键盘（可选）**

目前最受欢迎的屏幕键盘应该是 OnBoard

    yay -S onboard

但 OnBoard 在 Wayland 上无法使用。如果需要在 Wayland 会话中使用屏幕键盘，推荐安装 CellWriter

    yay -S cellwriter

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

下载 Windows 10 光盘映像
https://www.microsoft.com/zh-cn/software-download/windows10ISO

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

Manjaro Wiki -- Pacman Overview
https://wiki.manjaro.org/index.php/Pacman_Overview

ArchWiki -- Pacman
https://wiki.archlinux.org/index.php/Pacman

Manjaro Wiki -- Pamac
https://wiki.manjaro.org/index.php/Pamac

GitHub -- Yay
https://github.com/Jguer/yay

Manjaro Wiki -- Manjaro Hardware Detection Overview
https://wiki.manjaro.org/index.php/Manjaro_Hardware_Detection_Overview

Manjaro Wiki -- Configure Graphics Cards
https://wiki.manjaro.org/index.php/Configure_Graphics_Cards

Manjaro Wiki -- Manjaro Kernels
https://wiki.manjaro.org/index.php/Manjaro_Kernels

ArchWiki -- Sudo (简体中文)
https://wiki.archlinux.org/index.php/Sudo_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Manjaro Wiki -- Switching Branches
https://wiki.manjaro.org/index.php?title=Switching_Branches

在 Mac 上用 Openconnect 连接 Pulse Secure VPN
https://blog.yangl1996.com/post/use-openconnect-to-connect-to-pulse-secure-on-mac/

双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读
https://jakting.com/archives/ubuntu-rw-windows-files.html

修改 hosts 解决 GitHub 访问失败
https://zhuanlan.zhihu.com/p/107334179

Arch Wiki -- XDG user directories
https://wiki.archlinux.org/index.php/XDG_user_directories

Arch Wiki -- Cinnamon
https://wiki.archlinux.org/index.php/Cinnamon#Installation

Arch Wiki -- Intel Graphics
https://wiki.archlinux.org/index.php/Intel_graphics#Installation

KDE Community -- Plasma 5.9 Errata
https://community.kde.org/Plasma/5.9_Errata#Intel_GPUs

ArchWiki -- Baloo
https://wiki.archlinux.org/index.php/Baloo

Arch Wiki -- 关于 Logitech BLE 鼠标的问题
https://wiki.archlinux.org/index.php/Bluetooth_mouse#Problems_with_the_Logitech_BLE_mouse_(M557,_M590,_anywhere_mouse_2,_etc)

Linux-Surface -- Installation and Setup
https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup

Arch Wiki -- System time（简体中文）
https://wiki.archlinux.org/index.php/System_time_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

KDE 桌面的 Mac 化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

KDE 桌面美化指南
https://acherstyx.github.io/2020/06/30/KDE%E6%A1%8C%E9%9D%A2%E7%BE%8E%E5%8C%96%E6%8C%87%E5%8D%97/

Oh-My-Zsh 及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

Linux GRUB 删除多余启动条目
https://blog.csdn.net/JackLiu16/article/details/80383969

AUR 镜像使用帮助
https://mirrors.tuna.tsinghua.edu.cn/help/AUR/

TUNA NTP (网络授时) 服务使用说明
https://tuna.moe/help/ntp/

SJTUG 软件源镜像服务
https://mirrors.sjtug.sjtu.edu.cn/#/

Manjaro 为包管理器 pacman 和 yaourt/yay 添加多线程下载
https://blog.csdn.net/dc90000/article/details/101752743?utm_medium=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase&depth_1-utm_source=distribute.wap_relevant.none-task-blog-OPENSEARCH-6.nonecase

Linux tar 命令总结
http://www.linuxdiyf.com/linux/2903.html

ArchWiki -- Microsoft fonts（简体中文）
https://wiki.archlinux.org/index.php/Microsoft_fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archlinux 使用 Windows 字体及相关配置
https://blog.csdn.net/sinat_33528967/article/details/93380729

ArchWiki -- Fcitx5 (简体中文)
https://wiki.archlinux.org/index.php/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archived Manjaro Forum -- 比较几种中文输入法后，我最终选择了 sunpinyin + cloudpinyin 组合
https://archived.forum.manjaro.org/t/sunpinyin-cloudpinyin/114282

Acquiring TeX Live as an ISO image
https://www.tug.org/texlive/acquire-iso.html

TeX Live - Quick install
https://www.tug.org/texlive/quickinstall.html

TeX Live Documentation -- TeXLive Installation
https://www.tug.org/texlive/doc/texlive-en/texlive-en.html#installation

Font size of mailbox is too small
https://support.mozilla.org/zh-CN/questions/1297871

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复 Anaconda 环境, 卸载 Anaconda, 重装 Anaconda
https://blog.csdn.net/wangweiwells/article/details/88374361

Linux ate my RAM!
https://www.linuxatemyram.com/
