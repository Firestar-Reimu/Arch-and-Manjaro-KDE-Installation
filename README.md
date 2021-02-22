# **在 Surface Pro 6 上安装 Manjaro 20 KDE Plasma + Windows 10 双系统的指南**

```
System:    Host: FIRESTAR
           Kernel: 5.10.13-arch1-1-surface x86_64
           bits: 64
           Desktop: KDE
           Plasma 5.20.5
           Distro: Manjaro Linux
Machine:   Type: Laptop
           System: Microsoft
           product: Surface Pro 6
           UEFI: Microsoft
           v: 235.3440.768
           date: 11.16.2020
Battery:   ID-1: BAT1
CPU:       Info: Quad Core Intel Core i5-8250U [MT MCP]
           speed: 800 MHz
           min/max: 400/3400 MHz
Graphics:  Device-1: Intel UHD Graphics 620 driver: i915 v: kernel
           Display: x11 server: X.Org 1.20.10 driver: loaded: intel s-res: 2736x1824
           OpenGL: renderer: Mesa Intel UHD Graphics 620 (KBL GT2) v: 4.6 Mesa 20.3.4
Network:   Device-1: Marvell 88W8897 [AVASTAR] 802.11ac Wireless driver: mwifiex_pcie
           Device-2: Marvell Bluetooth and Wireless LAN Composite type: USB driver: btusb
Drives:    Local Storage: total: 238.47 GiB
```

## **Windows 的准备工作**

### **关闭快速启动**

控制面板 --> 电源选项 --> 选择电源按钮的功能 --> 更改当前不可用的设置 --> 保存修改

### **关闭 Bitlocker（Windows 10 家庭版无此选项）**

开始菜单 --> 设置 --> 更新和安全 --> 设备加密 --> 关闭

### **进入 UEFI 设置**

关闭 Surface，然后等待大约 10 秒钟以确保其处于关闭状态

长按 Surface 上的调高音量按钮，同时按下再松开电源按钮

屏幕上会显示 Microsoft 或 Surface 徽标 继续按住调高音量按钮 显示 UEFI 屏幕后，松开此按钮

Security --> Secure Boot --> Disabled(第三个选项)

### **制作启动盘**

在清华大学镜像中下载 Manjaro KDE 镜像，网址如下：

https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/kde/

或者在 Github 上下载：

https://github.com/manjaro/release-review

在这里可以找到所有的发行版（包括[官方版](https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro/)、[社区版](https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro-community/)、[KDE-dev版](https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/manjaro-community/kde-dev/)和每个版本对应的 minimal ISO）：

https://mirrors.tuna.tsinghua.edu.cn/osdn/storage/g/m/ma/

使用 [Rufus](https://github.com/pbatard/rufus) 刻录启动盘（注意启动盘如果用移动硬盘会无法被识别），直接选中镜像点确定即可（现在已经没有 ISO/DD 选项）

或使用 [Ventoy](https://github.com/ventoy/Ventoy) 制作启动盘，然后将下载的`.iso`文件复制到 USB 的第一个分区中即可（未验证，请谨慎尝试）

**若清华大学镜像速度较慢（比如在广州），可以将 https://mirrors.tuna.tsinghua.edu.cn 改为北京外国语大学镜像 https://mirrors.bfsu.edu.cn/**

### **安装 Manjaro**

**如果之前安装过 Manjaro， 需要使用 [EasyUEFI](https://www.easyuefi.com/index-us.html) 删除 Manjaro 开机启动项，并在“磁盘管理”中删除 Manjaro 磁盘（卷）**

设置 --> 恢复 --> 立即重新启动 --> USB Storage

或按照以下步骤直接从 USB 启动:

关闭 Surface

将可启动 U 盘插入 Surface 上的 USB 端口

长按 Surface 上的调低音量按钮，同时按下并释放 "电源" 按钮，屏幕上会显示 Microsoft 或 Surface 徽标

继续按住调低音量按钮，释放按钮后，徽标下方将显示旋转圆点，按照屏幕说明从 USB 启动

#### **进入 Manjaro Hello 窗口开始安装**

语言选择“简体中文”

时区选择“Asia -- Shanghai”

安装时选择“替代一个分区”，并点击之前空出来的空分区

勾选“为管理员使用相同的密码”

**使用 swap 分区可能会缩短 SSD 的寿命，如果需要 swap 的话建议用 swap 文件，详见 [Swap（简体中文）- Arch Wiki](https://wiki.archlinux.org/index.php/Swap_(简体中文)#交换文件)**

**系统安装时 Office 一项选择 No Office Suite，在安装软件时再下载 WPS Office**

## **初始配置**

### **电源设置**

系统设置 --> 电源管理 --> 节能 --> 勾选“按键事件处理” --> 合上笔记本盖时 --> 选择“关闭屏幕” --> 勾选“即使已连接外部显示器”

#### **与电源管理相关的常见英文名词**

Suspend：挂起，Reboot：重启，Shutdown：关机，Logout：注销

### **官方软件源更改镜像**

    sudo pacman-mirrors -i -c China -m rank

在广州建议用上海交大或阿里云的镜像，在北京建议用清华镜像，确认后输入：

    sudo pacman -Syyu

### **更改更新分支**

用下面的命令可以切换到 testing 或 unstable 分支：

    sudo pacman-mirrors --api --set-branch (branch)
    sudo pacman-mirrors --fasttrack 5 && sudo pacman -Syyu

### **命令行界面输出语言为英语**

在 `~/.bashrc` 的最后添加一行：

    export LANG=en_US.UTF-8

如果使用 zsh，则去掉 `~/.zshrc` 中这一行的注释即可

### **AUR**

#### 安装 base-devel

AUR 上的某些 PKGBUILD 会默认你已经安装 `base-devel` 组的所有软件包而不将它们写入构建依赖。为了避免在构建过程中出现一些奇怪的错误，建议先安装 `base-devel`：

    sudo pacman -S base-devel

或

    pamac install base-devel

#### 启用 pamac 的 AUR 支持

添加/删除软件 --> 右上角 ··· --> 首选项 --> AUR --> 启用 AUR 支持

然后就可以用 pamac 的图形界面获取 AUR 软件包，或者用命令 `pamac build` 及 `pamac install` 获取 AUR 的软件包。

#### 安装 yay

除了预装的 `pamac`，Manjaro 官方仓库中的 AUR 助手还有 `yay`：

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

若使用清华镜像，则添加：

    [archlinuxcn]
    Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch

之后执行下面的命令安装 archlinuxcn-keyring 包导入 GPG key

    sudo pacman -Sy archlinuxcn-keyring

由于 Manjaro 的更新滞后于 Arch，使用 archlinuxcn 仓库可能会出现“部分更新”的情况，导致某些软件包损坏

建议切换到 testing 或 unstable 分支以尽量跟进 Arch 的更新
    
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

### **双系统时间不同步 + 24小时制**

#### **双系统时间不同步**

在 Manjaro 上设置硬件时间为 UTC：

    sudo timedatectl set-local-rtc 0

并在 Windows 上设置硬件时间为 UTC，与 Manjaro 同步：

    reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_QWORD /f

这一步需要在 Powershell（管理员）中执行

#### **Manjaro 设置24小时制**

右键点击“数字时钟” --> 配置数字时钟 --> 时间显示 --> 24小时制

### **动态 Swap 文件设置**

先下载 `systemd-swap` 软件包：

    yay -S systemd-swap

编辑 `/etc/systemd/swap.conf`:

    sudo vim /etc/systemd/swap.conf
    
去掉 `swapfc_enabled` 前的注释并设置为 `swapfc_enabled=1` ，保存并关闭

在终端输入

    sudo systemctl enable --now systemd-swap

以启动`systemd-swap`服务

**Linux 的内存策略可以参考这个网站：https://www.linuxatemyram.com/**

### **连接北京大学 VPN**

按 `Fn+F12` 打开 Yakuake，输入：

    sudo openconnect --protocol=nc --user (student_ID) https://vpn.pku.edu.cn

之后点击窗口外任意位置或按 `Fn+F12` 让它收起，不要关闭窗口（关闭窗口则VPN断开）

### **Linux 挂载 Windows 磁盘**

**首先要确保 Bitlocker 已经关闭，这个时候一般来讲会自动显示出来，在 Dolphin 中点击即可挂载**

**如果要挂载 C 盘请确保快速启动已经关闭**

在终端中输入：

    lsblk -f

在输出结果中可以发现 Windows 的硬盘分区，每个分区有一段 `UUID` 的信息，选中复制下来 

接着就来修改系统文件：

    sudo vim /etc/fstab

在最后加入这两行：

    UUID=02A21C21A21C1BAB                     /home/firestar/System    ntfs-3g uid=firestar,gid=users,auto 0 0
    UUID=A2668A50668A24DF                     /home/firestar/Data    ntfs-3g uid=firestar,gid=users,auto 0 0

重启电脑后，即可自动挂载

**如果需要格式化 C 或 D 盘，先从 `/etc/fstab` 中删去这两行，再操作，之后磁盘的 `UUID` 会被更改，再编辑 `/etc/fstab` ，重启挂载即可**

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

    sudo mount /dev/nvme0n1p4 ~/Data

### **调整文件夹名称为英文**

    vim ~/.config/user-dirs.dirs
    
    XDG_DESKTOP_DIR="$HOME/Desktop"
    XDG_DOCUMENTS_DIR="$HOME/Documents"
    XDG_DOWNLOAD_DIR="$HOME/Downloads"
    XDG_MUSIC_DIR="$HOME/Music"
    XDG_PICTURES_DIR="$HOME/Pictures"
    XDG_PUBLICSHARE_DIR="$HOME/Public"
    XDG_TEMPLATES_DIR="$HOME/Templates"
    XDG_VIDEOS_DIR="$HOME/Videos"

### **Dolphin 在更新后删除文件/文件夹报错**

如果出现以下错误：

    无法创建输入输出后端。klauncher 回应：装入“/usr/lib/qt/plugins/kf5/kio/trash.so”时出错

说明 Qt 还在内存中保留着旧版 Dolphin，此时可以重启/重新登录，或执行

    dbus-launch dolphin

### **Linux-Surface 内核安装**

**安装和更新 Linux-Surface 需要登录北京大学 VPN**

参考以下网址：

Linux-Surface -- Installation and Setup
https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup

注意网页最后对 Firefox 和 Visual Studio Code 的进一步说明

### **SONY LE_WH-1000XM3 耳机连接**

长按耳机电源键约7s即可进入配对模式，可以在蓝牙中配对

### **Logitech M590 鼠标的蓝牙连接**

同一台电脑的 Windows 系统和 Manjaro 系统在鼠标上会被识别为两个设备。如果 Windows 系统被识别为设备1，需要按滚轮后的圆形按钮切换至设备2。并长按圆形按钮直到灯2快速闪烁进入配对模式

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

### **打字时桌面卡死，鼠标可以移动，点击无效**

首先切换到命令行界面

输入

    killall plasmashell

再回到图形化界面，打开终端，执行

    plasmashell &

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

### **开机登录美化**

开机与关机 --> 登录屏幕（SDDM） --> McMojave sddm

开机与关机 --> 欢迎屏幕 --> Snowy Night Miku 或者 Manjaro Linux Reflection Splashscreen

#### **主题美化（可选）**

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

#### **zsh 与 Oh-My-Zsh 配置（可选）**

Konsole --> 设置 --> 编辑当前方案 --> 常规 --> 命令 --> `usr/bin/zsh`

安装 Oh-My-Zsh，执行：

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

方法一：卸载 `manjaro-zsh-config`，这会卸载 `zsh` 及其所有依赖，然后重新安装 `zsh`

方法二：执行：

    sudo systemctl disable pkgfile-update.timer

方法三：执行：

    sudo systemctl mask pkgfile-update.timer

#### **GRUB 美化**

选择主题 Slaze ，下载地址如下：

https://github.com/vinceliuice/grub2-themes

以 Slaze grub theme （2K，黑白图标） 为例，解压后在文件夹内执行：

    sudo ./install.sh -b -l -w -2

删除多余启动条目，需要输入：

    sudo vim /boot/grub/grub.cfg

然后删除整一段 `submenu 'Manjaro Linux 的高级选项'`，删除整一段 `UEFI Firmware Settings`，并将 `Windows Boot Manager (在 /dev/nvme0n1p1)` 改为 `Windows`

#### **pacman 添加吃豆人彩蛋**

编辑 /etc/pacman.conf

    sudo vim /etc/pacman.conf

去掉 `Color` 前面的注释，并在下一行添加：

    ILoveCandy

即可添加吃豆人彩蛋

### **快捷键配置**

#### **Konsole 快捷键**

右上角 ··· --> 配置键盘快捷键 --> 复制改为 `Ctrl+C` ，粘贴改为 `Ctrl+V` 

### **调整 CPU 频率**

    sudo vim /etc/tlp.conf

若更改 CPU 频率，修改以下位置：

    CPU_MIN_PERF_ON_AC=0
    CPU_MAX_PERF_ON_AC=100
    CPU_MIN_PERF_ON_BAT=0
    CPU_MAX_PERF_ON_BAT=30

若更改 CPU 睿频设置，修改以下位置：

    CPU_BOOST_ON_AC=1
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

**注意需要排除掉 MS Gothic、Yu Gothic 字体，因它们只有部分日文汉字字形（与中文汉字字形一样的会被排除，最后导致部分中文汉字显示为日文字形）**

### **更改程序和终端默认中文字体为微软雅黑**

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
            <family>Consolas</family>
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

    yay -S fcitx5 manjaro-asian-input-support-fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki fcitx5-pinyin-chinese-idiom

### **安装其它软件**

以下命令中的 `yay -S` 也可以在“添加/删除软件”（即 pamac）中搜索安装，或者用 `pamac install` 安装

    yay -S wps-office-cn wps-office-mui-zh-cn ttf-wps-fonts electron-netease-cloud-music texstudio stellarium geogebra lantern-bin wechat-uos

**如果用 `yay -S nautilus` 安装了 nautilus 则用 `sudo nautilus` 就可以访问没有权限粘贴/删除的文件夹（不推荐）**

很多 KDE 应用不支持直接以 root 的身份运行，但是在需要提权的时候会自动要求输入密码

例如 Kate，可以先用普通用户的身份打开文件，保存时如果需要 root 权限就会弹出密码输入框

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

#### **默认安装**

    yay -S texlive-most texlive-lang

#### **自定义安装**

首先在 [TeX Live 下载地址](https://tug.org/texlive/acquire-netinstall.html) 下载 `install-tl-unx.tar.gz`

打开终端，运行：

    tar -xzvf install-tl-unx.tar.gz

进入解压后的文件夹，运行：

    sudo perl install-tl

此过程大概需要40分钟，安装后需要将 TeX Live 添加到 PATH

    vim ~/.bashrc
    
在最后添加以下语句：

    PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH; export PATH
    MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH; export MANPATH
    INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH; export INFOPATH
    
更新 bash 配置：

    source ~/.bashrc

可以运行 `tex -v` 检查是否安装成功，若成功应显示（以 Tex Live 2020 为例）：

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

Mail Content 勾选

右键点击上方工具栏 Mail Toolbar，选择 Customize，自行配置即可

#### **Thunderbird 帐号配置**

点击邮箱帐号，配置 Account Settings 如下：

Server Settings --> Server Settings --> Check for new messages every `1` minutes

Server Settings --> Server Settings --> When I delete a message --> Remove it immediately

### **Git 配置用户名、邮箱及免密码设置**

    git config --global user.name "(user_name)"
    git config --global user.email "(user_email)"       
    sudo vim .git-credentials

写入如下语句：

    https://(user_name):(user_password)@github.com

保存退出

    git config --global credential.helper store


### **hosts 文件设置**

为了防止 DNS 污染导致 GitHub 图片打不开，需要在 `/etc/hosts` 文件和 `C:\Windows\System32\drivers\etc\hosts` 文件中添加如下语句：

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

199.232.96.133 raw.githubusercontent.com
199.232.96.133 cloud.githubusercontent.com
199.232.96.133 gist.githubusercontent.com
199.232.96.133 marketplace-screenshots.githubusercontent.com
199.232.96.133 repository-images.githubusercontent.com
199.232.96.133 user-images.githubusercontent.com
199.232.96.133 desktop.githubusercontent.com
199.232.96.133 avatars.githubusercontent.com
199.232.96.133 avatars0.githubusercontent.com
199.232.96.133 avatars1.githubusercontent.com
199.232.96.133 avatars2.githubusercontent.com
199.232.96.133 avatars3.githubusercontent.com
199.232.96.133 avatars4.githubusercontent.com
199.232.96.133 avatars5.githubusercontent.com
199.232.96.133 avatars6.githubusercontent.com
199.232.96.133 avatars7.githubusercontent.com
199.232.96.133 avatars8.githubusercontent.com
## GitHub End
```

IP 地址可以通过对域名 `ping` 得到，例如：

    ping github.com

### **Anaconda 安装**

下载地址如下：

[Anaconda 官网](https://www.anaconda.com/products/individual)

[清华大学镜像](https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/)（点击网页第三列的 Date 按钮，使各版本按照时间排列，选择最新版本）

安装过程参考以下网址：

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

输入以下命令：

    vim ~/.condarc

修改 `.condarc` 以使用清华大学镜像源：

```
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/pro
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```

若使用上海交大的镜像源（只能用于 64 位的 Linux 系统），改为：

```
default_channels:
  - https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/r
  - https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/main
custom_channels:
  conda-forge: https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
  pytorch: https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
channels:
  - defaults
```

若不用镜像源，改为：

```
channels:
  - defaults
ssl_verify: true
```

恢复之前的版本：

    conda list --revisions
    conda install --revision (revision_number)

注意：如果回滚到早期版本（`revision_number` 较小）之后又想回到某个高版本（`revision_number` 较大），必须要把两个版本中的版本都装一遍

打开 Anaconda Navigator 需要在终端中输入：

    anaconda-navigator

用 Spyder 打开某个文件需要在终端中输入：

    spyder (file_path)/(file_name)

#### **Spyder 配置**

选择“自定义高分辨率”，并调整放大倍率为1.2

### **Vim 安装插件**

    git clone (github_repository_URL) ~/.vim/pack/(plugin_name)/start/(plugin_name)
    vim -u NONE -c "helptags ~/.vim/pack/(plugin_name)/start/(plugin_name)/doc" -c q

### **Visual Studio Code 安装与配置**

#### **Visual Studio Code 安装**

发行版维护者从开源代码构建的版本，可以用 `code` 命令打开：

    yay -S code

微软官方的二进制 release（包含部分私有的组件），同样可以用 `code` 命令打开（如果不介意私有组件而且不习惯“Code - OSS”的图标，个人推荐首选此项）：

    yay -S visual-studio-code-bin

内测版本：

    yay -S visual-studio-code-insiders

第三方发布的从开源代码构建的二进制包：

    yay -S vscodium-bin

从最新的开源代码构建：

    yay -S code-git

#### **Visual Studio Code 图标更改（可选）**

如果图标美化后 Visual Studio Code 图标变成圆形，想恢复原图标，更改路径如下：

程序启动器 --> 编辑应用程序 --> Visual Studio Code --> 点击图标更改 --> 其他图标

#### **Visual Studio Code 缩放比例**

放大比例：`Ctrl+=`

缩小比例：`Ctrl+-`

#### **Visual Studio Code 的 C/C++ 环境配置（未测试）**

参考以下网址：

基于 VS Code + MinGW-w64 的 C/C++ 简单环境配置
https://zhuanlan.zhihu.com/p/77074009

注意：下载插件 C/C++ Compile Run 后只要按 `Fn+F6` 即可编译运行 C/C++ 程序，但是不能调试。调试环境的配置请参考以下网址：

VS Code 之 C/C++程序的 debug 功能简介
https://zhuanlan.zhihu.com/p/85273055

### **能用上触控笔的软件（可选）**

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

### **重新开启 Secure Boot（未测试）**

如果想去掉开机时的红色上边框，可以使用经过微软签名的 PreLoader 或者 shim，然后在 UEFI 设置中将 Secure Boot 级别设置为 Microsoft & 3rd Party CA

具体教程参见：[Secure Boot - ArchWiki](https://wiki.archlinux.org/index.php/Unified_Extensible_Firmware_Interface/Secure_Boot#Using_a_signed_boot_loader)

### **获取设备信息**

#### 简要信息

在终端中输入：

    screenfetch

或者：

    sudo inxi -b

#### 详细信息

在终端中输入：

    sudo inxi -Fa

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

ArchWiki -- Sudo (简体中文)
https://wiki.archlinux.org/index.php/Sudo_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Manjaro Wiki -- Switching Branches
https://wiki.manjaro.org/index.php?title=Switching_Branches

在 Mac 上用 Openconnect 连接 Pulse Secure VPN
https://blog.yangl1996.com/post/use-openconnect-to-connect-to-pulse-secure-on-mac/

双系统下 Ubuntu 读写/挂载 Windows 中的硬盘文件 + 解决文件系统突然变成只读
https://jakting.com/archives/ubuntu-rw-windows-files.html

Arch Wiki -- XDG user directories
https://wiki.archlinux.org/index.php/XDG_user_directories

ArchWiki -- Baloo
https://wiki.archlinux.org/index.php/Baloo

Arch Wiki -- 关于 Logitech BLE 鼠标的问题
https://wiki.archlinux.org/index.php/Bluetooth_mouse#Problems_with_the_Logitech_BLE_mouse_(M557,_M590,_anywhere_mouse_2,_etc)

Linux-Surface -- Installation and Setup
https://github.com/linux-surface/linux-surface/wiki/Installation-and-Setup

Manjaro Forum -- 打字时 KDE 桌面卡死，鼠标可以移动，点击无效
https://forum.manjaro.org/t/kde/39610

Arch Wiki -- System time（简体中文）
https://wiki.archlinux.org/index.php/System_time_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Kde 桌面的 Mac 化
https://www.cnblogs.com/luoshuitianyi/p/10587788.html

Oh-My-Zsh 及主题、插件的安装与配置
https://www.cnblogs.com/misfit/p/10694397.html

Linux GRUB 删除多余启动条目
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

ArchWiki -- Microsoft fonts（简体中文）
https://wiki.archlinux.org/index.php/Microsoft_fonts_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

Archlinux 使用 Windows 字体及相关配置
https://blog.csdn.net/sinat_33528967/article/details/93380729

ArchWiki -- Fcitx5 (简体中文)
https://wiki.archlinux.org/index.php/Fcitx5_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

比较几种中文输入法后，我最终选择了 sunpinyin + cloudpinyin 组合
https://forum.manjaro.org/t/sunpinyin-cloudpinyin/114282

ArchWiki -- pacman (简体中文)
https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)

修改 hosts 解决 GitHub 访问失败
https://zhuanlan.zhihu.com/p/107334179

Font size of mailbox is too small
https://support.mozilla.org/zh-CN/questions/1297871

Anaconda Documentation -- Installing on Linux
https://docs.anaconda.com/anaconda/install/linux/

恢复 Anaconda 环境, 卸载 Anaconda, 重装 Anaconda
https://blog.csdn.net/wangweiwells/article/details/88374361
